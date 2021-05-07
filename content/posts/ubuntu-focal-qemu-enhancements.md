---
title: "QEMU & libvirt enhancements in Ubuntu 20.04 LTS"
date: 2020-04-29
tags: ["ubuntu"]
draft: false
aliases:
  - /post/ubuntu-focal-qemu-enhancements/
---

![Banner](/img/ubuntu/focal-qemu.png#center)

Ubuntu is the industry-leading operating system for cloud hosts and guests. Every day millions of Ubuntu instances are launched in private and public clouds around the world. Many launched right on top of Ubuntu itself. Canonical takes pride in offering the latest virtualization stack with each Ubuntu release.

In [Ubuntu 20.04 LTS (Focal Fossa)](https://ubuntu.com/blog/ubuntu-20-04-lts-arrives), users can find the recently released [QEMU](https://www.qemu.org/) version 4.2 and [libvirt](https://libvirt.org/) version 6.0 available on day one. These new versions have brought a number of key updates to the virtualization stack. Here are the most notable ones:

* Included in QEMU are the [qboot](https://github.com/bonzini/qboot) ROM, the [microvm](https://github.com/bonzini/qemu/blob/master/docs/microvm.rst) machine type, and a minimized QEMU build. This combination allows for much faster boot of Linux on x86 platforms.
* Support for nested virtualization
* As systems grow larger and larger QEMU guests can now create x86 guests with [memory footprints as large as 8TB](https://cpaelzer.github.io/blogs/005-guests-bigger-than-1tb/).
* Migration from SDL to GTK based UI backend to improve scaling and speed
* Increased speed of migrations via free page hinting through virtio-balloon
* [PMEM](https://docs.pmem.io/persistent-memory/getting-started-guide/creating-development-environments/virtualization/qemu) and [virtual nvdimms](https://github.com/qemu/qemu/blob/master/docs/nvdimm.txt) are available for general usage

Each release the Canonical team takes great care in considering what versions of QEMU and libvirt to include. The versions are determined through a careful process where the team weighs new upstream release features, schedules, and bug fixes. For more details on this process refer to the following [blog](https://cpaelzer.github.io/blogs/008-virt-stack-crystal-ball/).

Download [Ubuntu 20.04 LTS (Focal Fossa)](https://ubuntu.com/download/server).
