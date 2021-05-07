---
title: "cloud-init 18.5 Released"
date: 2018-12-13
tags: ["cloud-init"]
draft: false
aliases:
  - /post/cloud-init-18.5/
---

![Banner](/img/cloud-init/cloud-init.png#center)

As [announced](https://lists.launchpad.net/cloud-init/msg00194.html),
cloud-init 18.5 was released today! From the announcement, some highlights
include:

- Azure now supports waking from preprovision state via netlink messages
- New cli command 'cloud-id' to display what cloud on which an instance is running
- write_files config module now supports appending to a file
- instance-data.json standardized platform and subplatform values
- Select ubuntu archive mirror for armel, armhf, and arm64

Version 18.5 is already available in Ubuntu Disco and was stable release updated (SRU) to Ubuntu 18.04 LTS (Bionic) and Ubuntu 16.04 LTS (Xenial).

## Release History

Below is a breakdown and history of recent releases. It also shows the change in version to the [year.release format](https://lists.launchpad.net/cloud-init/msg00097.html):

| Release | Days | Date |
|:-------:|:----:|:----:|
[18.5](https://lists.launchpad.net/cloud-init/msg00180.html) | 70 | 2018-12-13
[18.4](https://lists.launchpad.net/cloud-init/msg00180.html) | 104 | 2018-10-03
[18.3](https://lists.launchpad.net/cloud-init/msg00164.html) | 83  | 2018-06-20
[18.2](https://lists.launchpad.net/cloud-init/msg00145.html) | 34  | 2018-03-28
[18.1](https://lists.launchpad.net/cloud-init/msg00144.html) | 68  | 2018-02-22
[17.2](https://lists.launchpad.net/cloud-init/msg00117.html) | 83  | 2017-12-14
[17.1](https://lists.launchpad.net/cloud-init/msg00106.html) | 271  | 2017-09-21
[0.7.9](https://lists.launchpad.net/cloud-init/msg00057.html) | 101  |  2016-12-23
[0.7.8](https://lists.launchpad.net/cloud-init/msg00043.html) | 32  | 2016-09-12
[0.7.7](https://lists.launchpad.net/cloud-init/msg00041.html) | - | 2016-08-10

## Follow cloud-init

- Chat with us in #cloud-init on Freenode
- Join and email the [cloud-init mailing list](https://launchpad.net/~cloud-init)
