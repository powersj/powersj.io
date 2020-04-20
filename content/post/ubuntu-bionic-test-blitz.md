---
title: "Ubuntu Bionic Test Blitz"
date: 2017-11-30
tags: ["ubuntu"]
draft: false
---

As we are on the road to the next Ubuntu LTS, Bionic Beaver, I have decided to start doing what I am referring to as a testing blitz: a semi-weekly test deep dive into a particular topic, functionality, component, or software that is relevant to Ubuntu Server. This will involve quickly learning about the item under test, using, testing, filing bugs, and at the conclusion of the blitz document my learning's in as a post here.

Here are a few of the larger test blitz that I did:

* [Using Netplan on Ubuntu Bionic]({{< ref "ubuntu-bionic-netplan.md" >}})
* [Ubuntu Bionic Server Live ISO]({{< ref "ubuntu-bionic-subiquity.md" >}})
* [Time sync with Chrony]({{< ref "ubuntu-bionic-chrony.md" >}})

In addition to the above the following was accomplished:

* Upgrade testing from Xenial and Bionic
* Install all server packages (without conflicts) and upgrade
* MAAS Upgrade
* Server ISO testing
* Boot time testing
* Focused testing with upgrades with Apache, Nginx, PostgreSQL, MySQL, percona, MongoDB, libvirt/qemu, and even conjure-up K8s.
