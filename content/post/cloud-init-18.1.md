---
title: "cloud-init 18.1 Released"
date: 2018-02-22
tags: ["cloud-init", "ubuntu"]
draft: false
---

![Banner](/img/cloud-init/cloud-init.png#center)

As [announced](https://lists.launchpad.net/cloud-init/msg00144.html), cloud-init 18.1 was released this week. From the announcement, some highlights include:

- tests: Enable AWS EC2 Integration Testing. (Joshua Powers)
- OpenNebula: Improve network configuration support. (Akihiko Ota)
- GCE: Improvements and changes to ssh key behavior for default user. (Max Illfelder)
- OVF: Fix VMware support for 64-bit platforms. (Sankar Tanguturi)

Version 18.1 is already available in Ubuntu Bionic as it also nears release.

## Release History

Below is a breakdown and history of recent releases. It also shows the change in version to the [year.release format](https://lists.launchpad.net/cloud-init/msg00097.html):

| Release | Days | Date |
|:-------:|:----:|:----:|
[18.1](https://lists.launchpad.net/cloud-init/msg00144.html) | 68  | 2018-02-22
[17.2](https://lists.launchpad.net/cloud-init/msg00117.html) | 83  | 2017-12-14
[17.1](https://lists.launchpad.net/cloud-init/msg00106.html) | 271  | 2017-09-21
[0.7.9](https://lists.launchpad.net/cloud-init/msg00057.html) | 101  |  2016-12-23
[0.7.8](https://lists.launchpad.net/cloud-init/msg00043.html) | 32  | 2016-09-12
[0.7.7](https://lists.launchpad.net/cloud-init/msg00041.html) | - | 2016-08-10

## Testing

In addition to the [LXD](https://lists.launchpad.net/cloud-init/msg00058.html) and [nocloud KVM](https://lists.launchpad.net/cloud-init/msg00101.html) tests, cloud-init now runs integration tests on a third platform: AWS EC2. As stated on the [mailing list](https://lists.launchpad.net/cloud-init/msg00125.html), the backend utilizes the [boto3](https://boto3.readthedocs.io/en/latest/) Python library to create a virtual private cloud and proceeds to launch instances while testing cloud-init.

## Follow cloud-init

- Chat with us in #cloud-init on Freenode
- Join and email the [cloud-init mailing list](https://launchpad.net/~cloud-init)
