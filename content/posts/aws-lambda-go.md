---
title: "Migrating AWS Lambda from go1.x to al2 Runtime"
date: 2023-11-17
tags: ["influxdata"]
draft: false
aliases:
  - /post/aws-lambda-go-runtime/
---

As part of the [telegraf][], we have a bot called the [telegraf-tiger][]. The
bot is made up of a number of AWS Lambda functions to do various actions for us.
For example, it can auto-label new issues, close old issues, share build,
artifcts on PRs, and more.

These lambda functions were originally set up to run on the go1.x runtime as the
functions themselves are all small Go scripts. However, [AWS announced][] that
the go1.x runtime is deprecated and users should migrate to the custom runtime
on Amazon Linux 2 instead.

The following is an outline of the changes I made to migrate our existing
functions over.

[telegraf]: https://github.com/influxdata/telegraf
[telegraf-tiger]: https://github.com/apps/telegraf-tiger
[AWS announced]: https://aws.amazon.com/blogs/compute/migrating-aws-lambda-functions-from-the-go1-x-runtime-to-the-custom-runtime-on-amazon-linux-2/

## Serverless

The deployments use [serverless][] to deploy our functions, and this was fairly
easy set of changes, once you knew what was needed:

1. For the provider, set `runtime: provided.al2`
2. For the package, switched from patterns to the `individually: true`
  setting. Each function will specify a specific artifact.
3. For each function, set `handler: bootstrap` and added the
  `package.artifact` option which points to the zip artifact

Essentially I switched the run time, and then switched the packages from a
pattern to instead point to a zip file with the lambda artifact.

An example service looks like:

```yaml
service: telegraf-tiger
frameworkVersion: '3'

provider:
  name: aws
  runtime: provided.al2
  architecture: x86_64
  logRetentionInDays: 14

package:
  individually: true

functions:
  github_webhook:
    handler: bootstrap
    package:
      artifact: bin/githubwebhook/githubwebhook.zip
    ...
```

[serverless]: https://www.serverless.com/

## Builds

Our previous builds of the lambda binaries produced a folder with a binary for
each function. The current build for each lambda involves a build then
archiving the binary in the root of that archive:

```s
GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build \
    -ldflags="-s -w" -tags lambda.norpc \
    -o bin/githubwebhook/bootstrap ./githubwebhook/cmd/
cd bin/githubwebhook/ && zip githubwebhook.zip bootstrap
```

As a part of this change, I took the opportunity to ensure the builds are
specific to amd64, given the architecture mentioned above, and set the tag to
remove the RPC dependency for an even smaller binary.

## Deployment

Once I redeployed the changes took effect immediately and I could see in the
Lambda functions list the runtime get updated to "Custom runtime on Amazon Linux
2".

## References

I found the following very helpful during the migration:

* [Deploy Go Lambda functions with .zip file archives](https://docs.aws.amazon.com/lambda/latest/dg/golang-package.html)
* [Using a custom runtime for Go-based Lambda functions](https://www.capitalone.com/tech/cloud/custom-runtimes-for-go-based-lambda-functions/)
* [Running multiple Golang AWS lambda functions on ARM64 with serverless.com](https://blog.matthiasbruns.com/running-multiple-golang-aws-lambda-functions-on-arm64-with-serverlesscom)
