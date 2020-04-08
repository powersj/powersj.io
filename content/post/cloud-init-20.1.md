---
title: "cloud-init 20.1 Released"
date: 2020-02-20
tags: ["cloud-init"]
draft: false
---

![Banner](/img/cloud-init/cloud-init.png#center)

As [announced](https://lists.launchpad.net/cloud-init/msg00246.html),
cloud-init 20.1 was released Thursday, February 20! From the announcement, some
highlights include:

- Python 2 support has been dropped
- A number of FreeBSD improvements landed
- Two (low priority) CVEs were addressed:
  - utils: use SystemRandom when generating random password (CVE-2020-8631)
  - cc_set_password: increase random pwlength from 9 to 20 (CVE-2020-8632)

And of course numerous bug fixes and other enhancements.

Starting with this release, the project will only support Python 3 going
forward. There is a branch of 19.4 available for delivering fixes for
systems still using Python 2.7. We did a similar branch for systems
stuck on Python 2.6.

Version 20.1 is already available in Ubuntu Focal.

## Release History

Below is a breakdown and history of recent releases. It also shows the change in version to the [year.release format](https://lists.launchpad.net/cloud-init/msg00097.html):

| Release | Days | Date |
|:-------:|:----:|:----:|
[20.1](https://lists.launchpad.net/cloud-init/msg00246.html) | 63  | 2020-02-20
[19.4](https://lists.launchpad.net/cloud-init/msg00239.html) | 42  | 2019-12-18
[19.3](https://lists.launchpad.net/cloud-init/msg00230.html) | 110 | 2019-11-05
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
