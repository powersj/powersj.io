---
title: "Getting Started with HashiCorp Vault"
date: 2020-08-28
tags: ["vault"]
draft: false
---

# Getting Started with HashiCorp Vault

[Vault](https://www.vaultproject.io/) provides a feature-rich method of secure
storage of secrets. Vault is more than an API server to handle requests for
secrets. It provides a secure and encrypted mechanism for the storage of
secrets, has built-in secret engines that can generate dynamic secrets with
TTLs, and custom policies for accessing secrets.

In the age of clouds, on-prem, and hybrid deployments, Vault answers the call
for secure credentials in dynamic infrastructure. As deployments move away
from high trust networks and security by IP address Vault fills the need to
dynamically create credentials and securely store them.

This is the first in a series about Vault. The rest of this post will cover
getting started with Vault with the setup of the server and client.

## Download

The fastest way to get the server is to go to
[Vault's downloads](https://www.vaultproject.io/downloads) page. There are
downloads available for Windows, Mac OS X, Linux, a variety of BSDs, and even
Solaris.

The executable contians both the server and the standard clinet.

## Server

### Development

For [development purposes](https://learn.hashicorp.com/tutorials/vault/getting-started-dev-server),
Vault includes a way of launching a built-in, pre-configured server. All data
is lost on restart and API access is done using plain HTTP. While this is
absolutely not for production, it does make it very easy to quickly get started
with Vault.

To start the development server run:

```shell
vault server -dev
```

This will launch the server, authenticate the CLI client, and print the root
token and unseal key to stdout. A user can also specify a specific root token
using the `-dev-root-token-id=<string>` option.

### Root Token

A user who logs in with the
[root token](https://www.vaultproject.io/docs/concepts/tokens.html#root-tokens)
gets the root policy attached. As the name implies, this user can do anything
in Vault. As such this token must be kept safe, or as HashiCorp suggestions
deleted after initial setup.

### Unsealing

[Sealing](https://www.vaultproject.io/docs/concepts/seal) is the act of opening
or closing the secret database. An unsealed vault is ready for new secrets and
will respond to requests. A sealed vault is locked down and will not hand out
any secrets. The ability to seal the vault can come in handy if the vault were
under attack or there was a need to move the vault itself.

On the development server, the vault will start in the unsealed state. However,
on a production deployment, it is up to the deployer to initialize and
unseal the vault. During the initialization of a production vault multiple
unseal keys are generated and are required for later sealing the vault. These
keys are not stored anywhere and must be recorded.

### Docker

Another option is using a Docker container with the
[Vault official image](https://hub.docker.com/_/vault/) on DockerHub:

```shell
docker run \
    --cap-add=IPC_LOCK \
    --detach \
    --name=vault \
    vault
```

Similar to the above CLI option, this launches the vault interface locally at
[http://localhost:8200](http://localhost:8200) and allows web UI using the
token root.

The IPC_LOCK capability will attempt to lock memory to prevent sensitive values
from being swapped to disk

### Production

For users wanting to launch Vault into production, HashiCorp has a step-by-step
[Deployment Guide](https://learn.hashicorp.com/tutorials/vault/deployment-guide)
that goes over best practices and configuration as well as a
[Production Hardening](https://learn.hashicorp.com/tutorials/vault/production-hardening)
guide based on a security model and best practices for the ideal deployment of
Vault.

### Web UI

When users launch Vault, they can log in initially using the root token that
was provided above. Once logged in, there are four major web UI sections:

* Secrets: manage secret engines and secrets themselves
* Access: manage secret access methods
* Policies: web interface for managing policies
* Tools: these pages contain tools to wrap secrets and look them up.
  Additionally, there are some random byte generators and hash tools.

Be aware that the UI exists, but the rest of this will focus on using the CLI.

## Client

As stated above, the server and client come combined in the downloadable
executable. Users can check the version of the client using the version
subcommand:

```shell
$ vault version
Vault v1.5.2 (685fdfa60d607bca069c09d2d52b6958a7a2febd)
```

By default, the client will look at `https://127.0.0.1:8200`. However, for
development, the server is running with HTTP and not HTTPS. To change the URL
or to point at another vault server the client can take a `-address`
parameter. To prevent the need from constantly using the parameter users can
also specify the address via an environment variable:

```shell
$ export VAULT_ADDR=http://127.0.0.1:8200
$ vault status
Key             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
Total Shares    1
Threshold       1
Version         1.5.2
Cluster Name    vault-cluster-0dd51b95
Cluster ID      fdaef6b8-aaa8-33e7-4ba6-55447c84c89a
HA Enabled      false
```

From the above output, the Vault instance is initialized and is not sealed. This
means the server is ready for business. If the vault were sealed then it would
mean that no one could access any secrets.

### Output

The fields and the format of the CLI output are both configurable making the
output much easier to parse and pass to other applications.

A user can specify JSON, YAML, or table output using the `-format=<string>`
option. The table output seen above is the default.

Additionally, a user can specify a specific field to output as well using the
`-field=<string>`.

### Autocomplete

To make the client even easier to use there is a command to install
autocompletion helpers to Bash, Fish, or ZSH:

```shell
vault -autocomplete-install
```

## curl

The client provides a streamlined CLI experience, however the client is
effectively a wrapper around curl commands to the server. If instead, users
wanted to interact with a server directly with curl it is entirely possible.

Here is an example which creates a secret and passes in the token via the
header:

```shell
curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request POST \
    --data '{ "data": {"password": "secret"} }' \
    http://127.0.0.1:8200/v1/secret/data/creds | jq -r ".data"
```

## Next Steps

Now that the server is up and running and the client can talk to the server,
the next part will describe
[enabling secrets engines and adding secrets](/post/vault-secrets-engine).
