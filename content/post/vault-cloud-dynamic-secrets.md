---
title: "Cloud Dynamic Secrets with HashiCorp Vault"
date: 2020-09-02
tags: ["vault"]
draft: false
---

*This is the sixth post in a series on Vault. For previous posts see,
[Getting Started](/post/vault-getting-started),
[Secrets Engines](/post/vault-secrets-engine),
[Manage Policies](/post/vault-manage-policies),
[Access Secrets](/post/vault-access-secrets), and
[Database Dynamic Secrets](/post/vault-database-dynamic-secrets).*

## Overview

One of the key powerful features of Vault is the ability to dynamically generate
credentials. The previous post on [Secrets Engines](/post/vault-secrets-engine)
discussed the possible cloud options Vault provides for dynamic
credentials.

This post will dive in and look at using Vault to generate dynamic credentials
for [Amazon Web Services](https://www.vaultproject.io/docs/secrets/aws) (AWS).
The sequence of steps is similar for
[AliCloud](https://www.vaultproject.io/docs/secrets/alicloud),
[Google Cloud](https://www.vaultproject.io/docs/secrets/gcp), and
[Microsoft Azure](https://www.vaultproject.io/docs/secrets/azure).

The general workflow is:

1. Enable cloud specific secrets engine
1. Connect to cloud with credentials
1. Create necessary roles
1. Generate cloud role credentials as needed

## Connect to the Cloud

First, enable the AWS secret engine and pass in credentials that have permission
to generate users and appropriate roles. In this example, an engine specific to
the us-west-2 region is specified:

```shell
$ vault secrets enable -path=aws-us-west-2 aws
Success! Enabled the aws secrets engine at: aws-us-west-2/
$ vault write aws-us-west-2/config/root \
    access_key={{AWS Access Key}} \
    secret_key={{AWS Secret Key}} \
    region=us-west-2
Success! Data written to: aws-us-west-2/config/root
```

Do *not* use the root account with Vault. A user should instead create a
dedicated user with the correct permissions specific for Vault. Vault provides
an [example IAM policy](https://www.vaultproject.io/docs/secrets/aws#example-iam-policy-for-vault)
that would work to do this.

## Cloud Role

Next, when users request credentials they will request targetting a specific
cloud role. The role will specify the access to the credentials grant. In the
case of AWS, a role will include an IAM policy. Here is an example that would
give the user permissions specific to AWS EC2:

```shell
$ vault write aws-us-west-2/roles/ec2 \
    credential_type=iam_user \
    policy_document=-<<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:*",
      "Resource": "*"
    }
  ]
}
EOF
Success! Data written to: aws-us-west-2/roles/ec2
```

For AWS, Vault will also accpet specific policy ARNs or an IAM group:

```shell
# Apply a specific ARN policy to a role
vault write aws-us-west-2/roles/ec2-read-only \
    credential_type=iam_user \
    policy_arns=arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess
# Create credentials for an existing IAM group
vault write aws-us-west-2/roles/iam-ec2 \
    credential_type=iam_user \
    iam_groups=ec2
```

## Cloud Credentials

Finally, when users create credentials against a role, Vault will create an
IAM user and attach the policy document to the user. Vault then creates and
returns an access key and secret key for the user.

```shell
$ vault read aws-us-west-2/creds/my-role
Key                Value
---                -----
lease_id           aws-us-west-2/creds/ec2/JXcy5a4WnnkVH9p8ouG6SYY5
lease_duration     768h
lease_renewable    true
access_key         AKIA5P4AR......
secret_key         LHjqcQpeg......
security_token     <nil>
```

In the AWS Console these users will show up with the user name of
`vault-token-$role-$timestamp`.

## Other Clouds

Again the basic workflow show above is similar on other clouds that Vault can
connect to. The differences are in specifying the role policies, which are
cloud-specific.
