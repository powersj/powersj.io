---
title: "Updatable Ubuntu Server Live Installer"
date: 2020-04-28
tags: ["ubuntu"]
draft: false
aliases:
  - /post/ubuntu-focal-live-installer-update/
---

The Ubuntu Server Live Installer, introduced with the release of Ubuntu 18.04 LTS (Bionic Beaver), provides a live Ubuntu Server environment along with a streamlined server installation experience. Building on guided installs for LVM, RAID, encrypted disks and advanced networking configuration (VLANs and bonds) the installer can refresh itself to the latest version during the live session. The update feature provides users with an access to new features and bug fixes without needing to wait for the official point releases throughout the cycle. Let’s now have a look at how it works in practice.

After booting the live Ubuntu Server session on an Internet connected server the installer will check and notify users if there is a newer version available. Users can either update the installer or skip the update.

![Update subiquity dialogue](/img/ubuntu/subiquity-update.png#center)

After selecting to update the installer, the user is shown the progress of the download and update. The install will resume after the update is complete.

![Update subiquity download](/img/ubuntu/subiquity-update-download.png#center)

The Updatable Ubuntu Server Live Installer is now available in both Ubuntu 18.04.3 LTS and Ubuntu 20.04 LTS. Users can download and try it [here](https://ubuntu.com/download/server).
