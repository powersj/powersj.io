---
title: "Storing Secrets in HashiCorp Vault"
date: 2020-08-29
tags: ["vault"]
draft: false
---

*This is the second post in a series on Vault. For the previous post see the
[Getting Started](/post/vault-getting-started).*

## Overview

Vault has a variety of [secrets engines](https://www.vaultproject.io/docs/secrets)
that store, generate, or encrypt data. Basic engines will simply store and read
data, while more complex engines will connect to external services and have the
ability to generate dynamic credentials on demand.

## Engines

Here are some details on a few of the available engine types:

### Key Value

The most familiar, and maybe the most common engine is the
[key/value (kv)](https://www.vaultproject.io/docs/secrets/kv) store. As the
name implies, this engine stores arbitrary keys and values, like `username=root`
and `password=secret`.

When using the key value engine, use
[version 2](https://www.vaultproject.io/docs/secrets/kv/kv-v2). Version 2
provides the ability to do versioning, TTLs, and other helpful features. This
allows users to roll back to a previous version or at least have a record of what
it was.

### Clouds

Vault offers some cloud-specific engines. Trying to manage cloud credentials is
already tough as it is. What vault can do is store a main set of credentials and
then dynamically generate credentials based on cloud policies that can also be
time-based and revoked as necessary.

There are currently four clouds supported:

* [Amazon Web Services](https://www.vaultproject.io/docs/secrets/aws)
* [Microsoft Azure](https://www.vaultproject.io/docs/secrets/azure)
* [Google Cloud](https://www.vaultproject.io/docs/secrets/gcp)
* [AliCLoud](https://www.vaultproject.io/docs/secrets/alicloud).

### Databases

Similar to the clouds, the numerous
[database](https://www.vaultproject.io/docs/secrets/databases) engines allow
for generating database credentials dynamically based on roles. This allows
services using the databases to no longer need hardcoded database values.

See the docs for an extensive list of the
[supported database](https://www.vaultproject.io/docs/secrets/databases#database-capabilities).

### Others

The above only touches on a few of the secrets engines. There are many others
that cover other technologies and platforms like
[Active Directory](https://www.vaultproject.io/docs/secrets/ad),
[OpenLDAP](https://www.vaultproject.io/docs/secrets/openldap),
[PKI (Certificates)](https://www.vaultproject.io/docs/secrets/pki),
and more!

### Secrets CLI

To get a list of the current secrets engines run the following:

```shell
vault secrets list
Path          Type         Accessor              Description
----          ----         --------              -----------
cubbyhole/    cubbyhole    cubbyhole_4536baf4    per-token private secret storage
identity/     identity     identity_1ce81d16     identity store
secret/       kv           kv_9cae2ec0           key/value secret storage
sys/          system       system_f3713085       system endpoints used for control, policy and debugging
```

The cubbyhole secrets engine is used to store arbitrary secrets per token.
Secrets stored there are tied to the lifetime of an authentication token. This
means that when the token expires the corresponding cubbyhole is destroyed.

Identity is used later for access to secrets.

System is used by the system and is where policies will live.

## KV Secrets

Time to store some secrets! Below is an example which enables the kv engine v2
and stores the password to a devel mailing list:

```shell
$ vault secrets enable -version=2 -path=shared kv
Success! Enabled the kv secrets engine at: shared/
$ vault kv put shared/mailing_list/devel password=secret
Key              Value
---              -----
created_time     2020-08-28T18:14:03.334192987Z
deletion_time    n/a
destroyed        false
version          1
```

### KV CLI

Here is an overview of the CLI commands to interact with kv secrets:

| Operation | Command |
|-----------|---------|
|    create | `vault kv put engine/path key=value` |
|      read | `vault kv get engine/path` |
|    update | `vault kv patch engine/path key=value` |
|    delete | `vault kv delete engine/path` |
|   destroy | `vault kv destroy engine/path` |
|      list | `vault kv list shared/mailing_list` |
|  rollback | `vault kv -version=# engine/path` |
|  undelete | `vault kv undelete engine/path` |
|  metadata | `vault kv metadata get engine/path` |

The `delete` subcommand does a soft delete, that will not return the value
during a get. A user can still `undelete` the value if required. The `destory`
removes the value entirely.

Due to the additional versioning of kv pairs in version 2, `rollback` allows a
user to go back to a previous version of a key. The version information is
visible via the `metadata` command.

### Hiding Secrets

Having the password in shell history is less than ideal. other options include
reading from stdin or even a JSON file:

```shell
# Using JSON
echo -n '{"key":"value"}' | vault kv put engine/path  -
vault kv put engine/path @data.json
# Using simple value
echo -n "value" | vault kv put engine/path key=-
vault kv put engine/path key=@data.txt
```

See the [CLI docs](https://www.vaultproject.io/docs/commands#writing-data) for
more details on hiding a password from the CLI.

## Organizing Secrets

There are no clear documents on how to organize secrets. While this is entirely
dependent on a user's specific scenario here are some ideas someone might
consider.

A secrets engine can be created multiple times and each time it is created, the
user needs to give it a path. This path can be any arbitrary name. Under each
path, the actual secrets are stored.

Similarly, each key value secret is created under a path and then has one or
more key value entries. This results in the following structures:

`engine-path/secret-path key=value key=value`

### Domain Centric

One possible then is to have a key-value engine for each domain or site.
Then paths for different secrets can get created based on node or subset.
A couple examples could look like:

|  Engine Path |       Secret Path |        Key |    Value |
|--------------|------------------:|-----------:|---------:|
|       amazon | publication/node1 | access_key |   secret |
|       amazon | publication/node1 | secret_key |   secret |
|       amazon | publication/node2 | access_key |   secret |
|       amazon | publication/node2 | secret_key |   secret |
|        cloud |             devel |   username | password |
|        cloud |           testing |   username | password |
|    launchpad |            my-ppa |   username | password |
|    launchpad |      my-other-ppa |   username | password |
| mailing_list |             devel |   password | password |
| mailing_list |           testing |   password | password |
| mailing_list |          external |   password | password |

Keep in mind that there are cloud specific engines which allow for the creation
of dynamic credentials. These credentials also provide additional securities as
they are time-based and revoked when the Vault lease expires.

### Node Centric

For users with lots of node specific credentials another option is to have each
node specified as the engine path:

|  Engine Path |           Secret Path |      Key |    Value |
|--------------|----------------------:|---------:|---------:|
|        node1 |     cloud/development | username | password |
|        node1 |     cloud/publication | username | password |
|        node1 |         cloud/testing | username | password |
|        node2 |     cloud/development | username | password |
|        node2 |     cloud/publication | username | password |
|        node2 |         cloud/testing | username | password |
|       shared |      launchpad/my-ppa | username | password |
|       shared | mailing-list/external | username | password |

This makes creating policies to limit node acces are much easier in this way.
Nodes can be limited to their specific path only. A shared path for non-node
specific credenitals can be shared with all nodes.

Again, consider using more than the key value secrets engine whenever possible
due to the additional features, like dynamic creation, that are wrapped around
them.

## Next Steps

Now that some secrets are stored, it is time to look at
[managing access policies](/post/vault-manage-policies) for accessing the secrets.
