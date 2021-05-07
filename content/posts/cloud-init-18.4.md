---
title: "cloud-init 18.4 Released"
date: 2018-10-03
tags: ["cloud-init"]
draft: false
aliases:
  - /post/cloud-init-18.4/
---

![Banner](/img/cloud-init/cloud-init.png#center)

As [announced](https://lists.launchpad.net/cloud-init/msg00180.html),
cloud-init 18.4 was released today! From the announcement, some highlights
include:

- Add datasource Oracle Compute Infrastructure (OCI).
- SmartOS: Support for re-reading metadata and re-applying on each boot [Mike Gerdts]
- Scaleway: Add network configuration to the DataSource [Louis Bouchard]
- Azure: allow azure to generate network configuration from IMDS per boot.
- Support access to platform meta-data in cloud-config and user-data via jinja rendering. (LP: #1791781)

Version 18.4 is already available in Ubuntu Cosmic and the stable release update (SRU) is underway for Ubuntu 18.04 LTS (Bionic) and Ubuntu 16.04 LTS (Xenial).

## Ending Python 2.6 Support

As discussed during the [2018 cloud-init summit]({{< ref "cloud-init-summit18.md" >}}) and [announced](https://lists.launchpad.net/cloud-init/msg00170.html) 18.4 is the final release with Python 2.6 support.

Python 2.7 support in cloud-init will end in June of 2020.

Versions of Python 3.5 or higher will be supported going forward.

## Release History

Below is a breakdown and history of recent releases. It also shows the change in version to the [year.release format](https://lists.launchpad.net/cloud-init/msg00097.html):

| Release | Days | Date |
|:-------:|:----:|:----:|
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
