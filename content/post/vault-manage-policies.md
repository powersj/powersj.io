---
title: "Managing HashiCorp Vault Access Policies"
date: 2020-08-30
tags: ["vault"]
draft: false
---

*This is the third post in a series on Vault. For previous posts see,
[Getting Started](/post/vault-getting-started) and
[Secrets Engines](/post/vault-secrets-engine).*

## Overview

Vault uses [policies](https://www.vaultproject.io/docs/concepts/policies)
to determine which secrets a client can see and what the user can
do with them. Policies are deny by default in Vault and are evaluated as needed
(i.e. lazy evaluation). As such the policy needs to be explicit about what
access is granted.

## Developing Policies

To craft policies for a specific use case or deployment, consider reviewing
HashiCorp's own
[policy docs](https://www.hashicorp.com/resources/policies-vault/). These walk
users through a basic workflow with examples for an admin and a provisioner.

### Policy Structure

Policies are written in JSON or HashiCorp's Terraform language called HCL and
contain a path and capabilities. See the
[HCL docs](https://www.terraform.io/docs/configuration/syntax.html) for more
info on the syntax.

A simple policy to allow read access to a specific path looks like:

```hcl
path "engine/path" {
  capabilities = ["read"]
}
```

Policy path's can also use the wild card `*` to grant the desired capabilities
to anything in a path. As well as the `+` wildcard to match a directory path.

```hcl
# for everything under engine
path "engine/*" {
  capabilities = ["read"]
}

# For all subdirectories under engine, that also have a secrets sub-directory
# e.g. engine/v1/secrets, engine/v2/secrets
path "engine/+/secrets" {
  capabilities = ["read"]
}
```

There are
[parameter constraint](https://www.vaultproject.io/docs/concepts/policies.html#parameter-constraints)
keys that offer fine control over what path can have. These include the
following:

* `required_parameters`: list of parameters that must be specified
* `allowed_parameters`: whitelist a list of keys and values that are permitted
* `denied_parameters`: blacklists a list of parameters and values

Finally, there are additional options for required
[response wrapping TTLs](https://www.vaultproject.io/docs/concepts/policies.html#required-response-wrapping-ttls)
via a `min_wrapping_ttl` and `max_wrapping_ttl`.

### Capabilities

The capabilities options generally correspond to the HTTP verbs: `create`,
`read`, `update`, `delete`, `list`. There are also `sudo` for root-protected
paths and `deny` to specifically disallow access.

### Policy CLI

On the CLI here are the equivilient commands:

| Operation | Command |
|-----------|---------|
|    create | `vault policy write name file` |
|      read | `vault read sys/policy/name` |
|    update | `vault write sys/policy/name policy=@file` |
|    delete | `vault delete sys/policy/name` |
|      list | `vault read sys/policy` |

## Built-in Policies

There are two built-in policies that come with Vault:

### Root Policy

The [root policy](https://www.vaultproject.io/docs/concepts/policies#root-policy)
allows a user to do anything with Vault. The policy itself cannot be modified or
removed. When Vault is first set up the root token is either passed in or
provided to the user. This token is used to login as the root user and do the
initial setup. Afterward, the token should be revoked:

```shell
vault token revoke "$token"
```

### Default Policy

The [default policy](https://www.vaultproject.io/docs/concepts/policies#default-policy)
is included in all tokens and provides common permissions. However, the user can
update the administrator could update the policy to restrict these further.
Vault makes sure to say that future updates to Vault would not override any
changes an admin makes.

```shell
# view the default token
vault read sys/policy/default
# disables always attaching the default token
vault token create -no-default-policy
```

## Next Steps

With secrets stored and policies in place, it is time to
[grant access to the secrets](/post/vault-access-secrets)!
