---
title: "cloud-init 19.1 Released"
date: 2019-05-31
tags: ["cloud-init", "ubuntu"]
draft: false
---

![Banner](/img/cloud-init/cloud-init.png#center)

As [announced](https://lists.launchpad.net/cloud-init/msg00209.html),
cloud-init 19.1 was released last Friday! From the announcement, some
highlights include:

- Azure datasource telemetry, network configuration and ssh key hardening
- new config module for interacting with third party drivers on Ubuntu
- EC2 Classic instance support for network config changes across reboot
- Add support for the com.vmware.guestInfo OVF transport.
- Scaleway: Support ssh keys provided inside an instance tag.
- Better NoCloud support for case-insensitive fs labels.
- SuSE network sysconfig rendering fixes for IPv6, default routes and startmode

It was really exciting to see that we had a large number of community
commits this release cycle as well!

Version 19.1 is already available in Ubuntu Eoan and stable release
updateds (SRU) to Ubuntu 18.04 LTS (Bionic) and Ubuntu 16.04 LTS
(Xenial) are also complete.

## Release History

This release took longer than we have in the past. We plan to quickly
release 19.2 early this summer.

Below is a breakdown and history of recent releases. It also shows the change in version to the [year.release format](https://lists.launchpad.net/cloud-init/msg00097.html):

| Release | Days | Date |
|:-------:|:----:|:----:|
[19.1](https://lists.launchpad.net/cloud-init/msg00209.html) | 147 | 2019-05-10
[18.5](https://lists.launchpad.net/cloud-init/msg00180.html) | 70  | 2018-12-13
[18.4](https://lists.launchpad.net/cloud-init/msg00180.html) | 104 | 2018-10-03
[18.3](https://lists.launchpad.net/cloud-init/msg00164.html) | 83  | 2018-06-20
[18.2](https://lists.launchpad.net/cloud-init/msg00145.html) | 34  | 2018-03-28
[18.1](https://lists.launchpad.net/cloud-init/msg00144.html) | 68  | 2018-02-22
[17.2](https://lists.launchpad.net/cloud-init/msg00117.html) | 83  | 2017-12-14
[17.1](https://lists.launchpad.net/cloud-init/msg00106.html) | 271  | 2017-09-21
[0.7.9](https://lists.launchpad.net/cloud-init/msg00057.html) | 101  |  2016-12-23
[0.7.8](https://lists.launchpad.net/cloud-init/msg00043.html) | 32  | 2016-09-12
[0.7.7](https://lists.launchpad.net/cloud-init/msg00041.html) | - | 2016-08-10

## Interact with cloud-init

- Chat with us in #cloud-init on Freenode
- Join and email the [cloud-init mailing list](https://launchpad.net/~cloud-init)
- Checkout the [HACKING](https://cloudinit.readthedocs.io/en/latest/topics/hacking.html) document to get started on cloud-init development
