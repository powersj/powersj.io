---
title: "cloud-init 19.3 Released"
date: 2019-11-05
tags: ["cloud-init"]
draft: false
---

![Banner](/img/cloud-init/cloud-init.png#center)

As [announced](https://lists.launchpad.net/cloud-init/msg00230.html),
cloud-init 19.3 was released Tuesday, November 5! From the announcement, some
highlights include:

- Microsoft Azure:
  - Emit network configuration v2 (Netplan) from Azure's instance metadata service
  - Support for dhcp6 route-metrics
- New Exocale datasource
- Add support for Zstack and e24cloud datasources.
- Google Compute Engine: add support for publishing host keys
- Oracle: configure secondary nics
- VMware & OVF:
  - add option to enable/disable custom user script. default is disabled
  - do not re-generate instance-id per boot
- ConfigDrive: fix sub-platform rendering for /config-drive directory source
- Tooling:
  - `cloud-init analyze` now tracks and reports vm and kernel boot times

And of course numerous bug fixes and other enhancements.

Version 19.3 is already available in Ubuntu 19.10 (Eoan).

## Release History

Below is a breakdown and history of recent releases. It also shows the change in version to the [year.release format](https://lists.launchpad.net/cloud-init/msg00097.html):

| Release | Days | Date |
|:-------:|:----:|:----:|
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
