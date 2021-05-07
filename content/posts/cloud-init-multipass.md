---
title: "Using cloud-init with Multipass"
date: 2018-03-30
tags: ["cloud-init"]
draft: false
aliases:
  - /post/cloud-init-multipass/
---

[Multipass](https://community.ubuntu.com/t/beta-release-multipass/2696) is a quick and easy way to launch virtual machine instances running Ubuntu. [Cloud-init](https://cloud-init.io/) is the standard for customizing cloud instances and now multipass can also make use of cloud-init to customize an instance during launch.

Below is an example of launching a new VM with cloud-init user-data:

```shell
multipass launch -n my-test-vm --cloud-init cloud-config.yaml
```

## user-data Format

Currently multipass only supports YAML cloud-config files. Passing a script, a MIME archive, or any of the other [user-data formats](http://cloudinit.readthedocs.io/en/latest/topics/format.html) cloud-init supports will result in an error from the YAML syntax validator. Check out the cloud-init docs for [examples of YAML cloud-config](http://cloudinit.readthedocs.io/en/latest/topics/examples.html).

## YAML Syntax Validation

Multipass will validate the YAML syntax of the cloud-config file before attempting to start the VM! A nice addition to help save time when experimenting with launching instances with various cloud-configs.

## vendor-data

Multipass uses cloud-init to pass in vendor-data to setup the VM for access by the user. If the user overrides any of the required keys (e.g. packages, ssh_authorized_keys, users, etc.) in his or her user-data then multipass will merge its own data so that the end-user will not lose access to the system.

If interested, a user can examine the executed user-data and vendor-data by looking at the files in `/var/lib/cloud/instances/`.

## Get in touch

As always, you can chat with the cloud-init developers in #cloud-init on Freenode or email the [cloud-init mailing list](https://launchpad.net/~cloud-init).

The multipass team is also on Freenode at #multipass and to view the code and report bugs check them out on [GitHub](https://github.com/CanonicalLtd/multipass).
