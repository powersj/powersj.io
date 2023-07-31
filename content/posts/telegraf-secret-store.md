---
title: "Storing Secrets with Telegraf"
date: 2023-06-15
tags: ["telegraf"]
draft: false
aliases:
  - /post/telegraf-secret-store/
---

Telegraf is an open source plugin-driven agent for collecting, processing,
aggregating, and writing time series data. Telegraf relies on user-provided
configuration files to define the various plugins and flow of this data. These
configurations may require secrets or other sensitive data.

The new secret store plugin type allows a user to store secrets and reference
those secrets in their Telegraf configuration file. These stores alleviate the
need to have secrets directly in the Telegraf configuration file.

The following post provides an overview of the Secret Store feature of Telegraf
and includes a few real-life examples.

## Secret Stores

As of v1.27, Telegraf has a few Secret Store plugins to choose from:

* Docker
    * When running Docker, this plugin can read Docker provided secrets.
    * These are values stored in `/run/secrets` on the container.
* HTTP
    * Query secrets from an HTTP endpoint.
    * The format of the data is expected to be a flat JSON object.
    * Supports a variety of encryption methods and authentication.
* JOSE
    * Local encrypted files using the JavaScript Object Signing and Encryption algorithm.
    * Users can use the `telegraf secrets set` to create secrets.
* OS
    * Interact with OS-specific secret stores.
        * Linux uses kernel keyrings.
        * macOS works with the macOS Keychain.
        * Windows interacts with the Windows Credential Manager control panel.

## Plugin support

Telegraf plugins support secret stores only with specific fields. To learn if a
plugin supports secret stores, look at the plugin’s README and look for the
"Secret-store support" section. This details the plugin’s secret store
capabilities and which configuration options it supports.

## User access

When setting up secrets, another key item to consider is that the user running
Telegraf needs access to the secrets. When creating a secret store and running
Telegraf as a service, be sure to give the commonly used `telegraf` user access
to those secrets.

## Getting started checklist

Below is a set of steps to migrate an existing Telegraf configuration to one
that supports secret stores:

* Verify plugin support
    * As mentioned above, ensure that the plugin(s) you want to use supports
    secret stores.
    * Then, ensure that plugin(s) support the configuration options you need.
* Choose a secret store
    * Decide if you’re going to integrate with the OS secret stores or use an
    external store.
* Add secret store to Telegraf config
    * Add the appropriate secret store plugin to the Telegraf config.
    * Each secret store requires a unique `id` that configurations using the
    secrets can reference.
    * Set up any configuration options necessary to reference the secrets.
* Save secrets to that store
    * Telegraf’s secrets subcommand can write secrets for some, but not all the
    stores.
    * Ensure that the plugin successfully stored your secrets and that the
    secrets are accessible by the user running Telegraf. Keep in mind that some
    stores may not persist over reboots.
* Update config to use secrets
    * Finally, update the Telegraf configuration to switch from hard-coded
    credentials.
    * Use the `@{secretstore_id:secret_key}` syntax to reference the secret
    stores for a configuration value.

## Examples

Below are a few examples using different secret store plugins:

### Linux OS example

The following sets up secrets using a user’s kernel keyring on a Linux machine.

First, update the Telegraf config to include the OS secret store plugin. The
following gives the secret store the ID "mystore", which we will use to
reference the secrets later. Because you can have multiple secret stores, the ID
is what makes the stores unique for identification purposes. The keyring value
is the user’s kernel keyring to use:

```toml
[[secretstores.os]]
   id = "mystore"
   keyring = "telegraf"
```

To create secrets, use `keyctl` or the Telegraf binary. The `secrets set`
subcommand takes the keyring name used above and the secret name. Then the user
is prompted for the secret information to avoid putting the secret in their
shell history:

```shell
$ telegraf --config config.toml secrets set mystore influx_token
Enter secret value:
```

Finally, to update the Telegraf configuration to reference the new secret:

```toml
[[outputs.influxdb_v2]]
  urls = ["http://127.0.0.1:8086"]
  token = "@{mystore:influx_token}"
  organization = "myorg"
  bucket = "mybucket"
```

### Docker example

The following is an example of pulling secrets via Docker secrets. The Docker
secret store differs from the other stores in that it only reads secrets
provided by Docker itself at runtime. These secrets mount to the `/run/secrets`
directory of a container. A user cannot use Telegraf to set Docker secrets.

Below is an example of a user storing the secrets in a file, which the Docker
Compose config then references under secrets. Then update the Telegraf service
to use the that secret:

```yaml
services:
  telegraf:
    image: telegraf:latest
    secrets:
      - influx_token
    user: "${USERID}" # Use the value of `id -u` of the user launching the docker-compose

secrets:
  influx_token:
    file: influx_token.txt
```

The final Telegraf config used to access the Docker secret is similar to the
code below:

```toml
[[secretstores.docker]]
  id = "docker_store"

[[outputs.influxdb_v2]]
  urls = ["http://127.0.0.1:8086"]
  token = "@{docker_store:influx_token}"
  organization = "myorg"
  bucket = "mybucket"
```

### HTTP example

The following is an example of pulling secrets via an HTTP endpoint.

The HTTP secret store plugin can call out to an HTTP endpoint with a variety of
authentication or encryption options. The plugin expects the secrets to be in a
flat key-value JSON file where the key is the secret name and the value is the
actual secret. Here is an example of the format:

```json
{
    "influx_token_dev": "6702bf65b31941f59dfcf09afd94b1aa",
    "influx_token_test": "1af461d979344253824cbbaf88dd2563",
    "influx_token_prod": "56372127fe944e68a497bad0a6e33663"
}
```

To add this to Telegraf, provide a unique ID for the store and the URL to query
for the secrets:

```toml
[[secretstores.http]]
  id = "http_store"
  url = "http://127.0.0.1/secrets"
```

Again, there are many options available for the plugin, including: custom
headers, bearer tokens, basic authentication, oauth2, proxy, TLS config, cookie
support, and much more. You can send encrypted secrets to Telegraf and, with the
appropriate cipher and key, decrypt the secrets themselves.

Finally, add the reference to the secrets to the config:

```toml
token = "@{http_store:influx_token_prod}"
```

### JOSE example

The following is an example of pulling secrets via the JavaScript Object Signing
and Encryption (JOSE) algorithm. This secret store stores the secrets locally in
encrypted files, one for each secret. To decrypt the files, you have to provide
the password either in the Telegraf configuration file or when running Telegraf,
interactively enter the password. As a result, this secret store option is
better thought of as a security through obscurity.

```toml
[[secretstores.jose]]
  id = "jose_store"
  path = "/etc/telegraf/secrets"
```

To create secrets users can use the Telegraf binary:

```shell
$ telegraf --config config.toml secrets set jose_store influx_token
Enter secret value:
Enter passphrase to unlock "/etc/telegraf/secrets":
$ ls /etc/telegraf/secrets
influx_token
```

Then, like other secret stores, update the Telegraf configuration with the
reference to the secret:

```toml
token = "@{jose_store:influx_token}"
```

On start, if the password to the store is not provided in the configuration
file, the user is prompted to enter the password:

```shell
$ ./telegraf --config config.toml
Enter passphrase to unlock "/etc/telegraf/secrets":
```

## Get started with Secret Stores and Telegraf

This post laid out a number of ways to use the new secret store functionality in
Telegraf. Consider where you might be able to use this functionality in Telegraf
and give it a shot today!
