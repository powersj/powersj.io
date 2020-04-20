---
title: "cloud-init 19.2 Released"
date: 2019-07-24
tags: ["cloud-init"]
draft: false
---

![Banner](/img/cloud-init/cloud-init.png#center)

As [announced](https://lists.launchpad.net/cloud-init/msg00219.html),
cloud-init 19.2 was released last Wednesday! From the announcement, some
highlights include:

- FreeBSD enhancements
  - Added NoCloud datasource support.
  - Added growfs support for rootfs.
  - Updated tools/build-on-freebsd for python3
- Arch distro added netplan rendering support.
- cloud-init analyze reporting on boot events.

And of course numerous bug fixes and other enhancements.

Version 19.1 is already available in Ubuntu Eoan. A stable release
updates (SRU) to Ubuntu 18.04 LTS (Bionic) and Ubuntu 16.04 LTS
(Xenial) will start in the next week.

## Release History

This release took longer than we have in the past. This was a shorter release
to catch up on quarterly releases after a much longer than expected 19.1.

Below is a breakdown and history of recent releases. It also shows the change in version to the [year.release format](https://lists.launchpad.net/cloud-init/msg00097.html):

| Release | Days | Date |
|:-------:|:----:|:----:|
[19.2](https://lists.launchpad.net/cloud-init/msg00219.html) | 67  | 2019-07-17
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
