---
title: "Access HashiCorp Vault Secrets"
date: 2020-08-31
tags: ["vault"]
draft: false
---

# Access HashiCorp Vault Secrets

*This is the fourth post in a series on Vault. For previous posts see,
[Getting Started](/post/vault-getting-started),
[Secrets Engines](/post/vault-secrets-engine), and
[Manage Policies](/post/vault-manage-policies).*

## Overview

[Authentication](https://www.vaultproject.io/docs/concepts/auth) is the process
where users or automation provide credentials to gain a
[token](https://www.vaultproject.io/docs/concepts/tokens). The tokens,
similar to a session ID on a website, is then used to interact with Vault. The
token itself states the policies and as a result the roles and access the user
has. When using the development server, users are already familiar with using
the hard-coded root token to get started.

## Access Methods

Vault has a number of
[authentication methods](https://www.vaultproject.io/docs/auth) to choose from.
Allowing a user to choose the best method of any use case. These methods are how
clients or users access Vault.

Here are a couple of options in more detail:

### TLS Certificates

The [TLS Certificate](https://www.vaultproject.io/docs/auth/cert) method allows
for using SSL/TLS client certificates, signed by a CA or self-signed, for
access.

The following enables the certificate auth method and adds a certificate for
a "builder" policy. These builders are added to the test and build policies and
places a one hour ttl to leases:

```shell
vault auth enable cert
vault write auth/cert/certs/builder \
    display_name=builder \
    policies=test,build \
    certificate=@node-cert.pem \
    ttl=3600
```

Then on the builder to login with the client cert:

```shell
vault login \
    -method=cert \
    -ca-cert=vault-ca.pem \
    -client-cert=cert.pem \
    -client-key=key.pem \
    name=builder
```

### Userpass

The [Userpass](https://www.vaultproject.io/docs/auth/userpass) method allows
users to access Vault using a username and password.

```shell
$ vault auth enable userpass
Success! Enabled userpass auth method at: userpass/
$ vault write auth/userpass/users/joe password=secret policies=admin
Success! Data written to: auth/userpass/users/joe
```

Then to login using the new access:

```shell
$ vault login -method=userpass username=joe password=secret
Success! You are now authenticated. The token information displayed below...
```

The user's token string and TTY is printed along with the policies that apply
to the user.

### AppRole

The [AppRole](https://www.vaultproject.io/docs/auth/approle) enables a variety
of potential workflows focused around automation. A role could possibly be
created for a specific app on a machine, a user, across a number of machines,
or even something else.

The AppRole method uses a role ID and secret ID to login and fetch a token. The
role ID could be shared across a variety of machines, while the secret ID is
meant to be unique for one instance of an application. The uniqueness allows for
better auditing and having finer-grained revocation.

To start an admin enables the AppRole method and adds a role with a variety of
ttl, use restrictions, and policies:

```shell
vault auth enable approle
vault write auth/approle/role/builder \
    token_policies="test,build" \
    secret_id_ttl=10m \
    token_num_uses=10 \
    token_ttl=20m \
    token_max_ttl=30m \
    secret_id_num_uses=40
```

Then users, admins, or an orchestration mechanism can generate role and secret
IDs as needed. This is done by the following:

```shell
$ vault read auth/approle/role/builder/role-id
Key        Value
---        -----
role_id    b7094758-f0b8-3148-97c1-2aa82cd627ff
$ vault write -f auth/approle/role/builder/secret-id
Key                   Value
---                   -----
secret_id             24cfaecf-a0c7-5381-541c-4e250d48e8d7
secret_id_accessor    171b256f-024a-a34b-3add-0d49648b2a20
```

Finally, to login using this mechanism is as easy as passing the role and
secret IDs:

```shell
vault write auth/approle/login role_id=${ROLE_ID} secret_id=${SECRET_ID}
```

### Clouds

There are also authentication methods that let a user get cloud credentials.

These exist for the following clouds:

* [Amazon Web Services](https://www.vaultproject.io/docs/auth/aws)
* [Microsoft Azure](https://www.vaultproject.io/docs/auth/azure)
* [Google Cloud](https://www.vaultproject.io/docs/auth/gcp)
* [Oracle Cloud Infrastructure](https://www.vaultproject.io/docs/auth/oci)
* [Cloud Foundry](https://www.vaultproject.io/docs/auth/cf)

### Others

Finally, there are even more options that involve integration with other
services:

* [GitHub](https://www.vaultproject.io/docs/auth/github)
* [Kubernetes](https://www.vaultproject.io/docs/auth/kubernetes)
* [LDAP](https://www.vaultproject.io/docs/auth/ldap)
* [RADIUS](https://www.vaultproject.io/docs/auth/radius)

See the [authentication docs](https://www.vaultproject.io/docs/concepts/auth)
for the full list of support methods.

## Next Steps

With secrets, policies, and access in place, it is time to look deeper into
[dynamic database secret generation](/post/vault-database-dynamic-secrets).
