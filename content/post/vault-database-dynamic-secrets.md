---
title: "Database Dynamic Secrets with HashiCorp Vault"
date: 2020-09-01
tags: ["vault"]
draft: false
---

*This is the fifth post in a series on Vault. For previous posts see,
[Getting Started](/post/vault-getting-started),
[Secrets Engines](/post/vault-secrets-engine),
[Manage Policies](/post/vault-manage-policies), and
[Access Secrets](/post/vault-access-secrets).*

## Overview

One of the key powerful features of Vault is the ability to dynamically generate
credentials. The previous post on [Secrets Engines](/post/vault-secrets-engine)
discussed the possible database options Vault provides for dynamic
credentials.

This example will take a look at using Vault to generate dynamic credentials
for PostgreSQL. However, keep in mind that there is a
[large list of supported databases](https://www.vaultproject.io/docs/secrets/databases#database-capabilities).

The general workflow is:

1. Enable database secrets engine
1. Create connection string to database with specific database plugin
1. Create necessary roles
1. Generate database role credentials as needed

## Database Connection

The workflow begins with enabling the secrets engine and configuring the
necessary [database-specific plugin](https://www.vaultproject.io/docs/secrets/databases#database-capabilities). View the page for the database required for
more specific details about the plugin name, template connection URL, as well as
other settings.

Here is an example for PostgreSQL where a templated connection URL is passed:

```shell
$ vault secrets enable database
Success! Enabled the database secrets engine at: database/
$ vault write database/config/postgres-dev \
    plugin_name="postgresql-database-plugin" \
    connection_url="postgresql://{{username}}:{{password}}@localhost:5432" \
    username="postgres" \
    password="postgres" \
    allowed_roles="read-only"
```

The above read-only role will be created in a following step.

## Rotate Password

Once the user is configured, Vault recommends rotating the user's password.
Running the following will ensure that the vault user specified above has a new
password and that user is only accessible by Vault itself:

```shell
vault write -force database/config/postgres-dev
```

## Database Role

Now that Vault can talk to the database the final configuration step is to
create a Vault role for the database that will create credentials with specific
TTLs. When a user or application requests a credential this statement will run
to create the dynamic credentials with the correct permissions and return the
new credentials.

Below is an example to give read-only access with some TTLs set:

```shell
$ vault write database/roles/read-only \
    db_name=postgres-dev \
    default_ttl="1h" \
    max_ttl="24h" \
    creation_statements="CREATE ROLE \"{{name}}\" \
        WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; \
        GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";"
Success! Data written to: database/roles/read-only
```

Of course the creation statement is flexible such that a role could grant
access to a specific database or table and with speicifc read or write
permissions.

## Database Credentials

Finally, to put this to work users can request dynamic credentials and each
request will produce a unique set of credentials:

```shell
$ vault read database/creds/read-only
Key                Value
---                -----
lease_id           database/creds/read-only/P6t8DCFroYZizzV4uVIu75q1
lease_duration     1h
lease_renewable    true
password           A1a-QhGMo......
username           v-token-read-onl-Pr2AebzyYcYey8wSti0w-1599073044
```

Vault will automatically delete expired credentials. And if a compromise is
discovered, users can revoke credentials immediately.

## Other Databases

This similar workflow applies to Vault's
[large list of supported databases](https://www.vaultproject.io/docs/secrets/databases#database-capabilities).

## Next Steps

The next post will look similarly generating dynamic secrets using a
[cloud secrets engine](/post/vault-cloud-dynamic-secrets).
