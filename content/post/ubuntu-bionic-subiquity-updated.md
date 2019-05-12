---
title: "Ubuntu Bionic: Updated Subiquity Server ISO"
date: 2018-07-27
tags: ["ubuntu", "bionic", "subiquity", "iso"]
draft: false
---

# Ubuntu Server Install ISO Updated

The [subiquity](https://github.com/CanonicalLtd/subiquity) based Ubuntu Server install ISO was [recently updated](https://lists.ubuntu.com/archives/ubuntu-server/2018-July/007725.html) with many new features and options. Among the most requested features included new storage install options (e.g. LVM and software RAID) and network bonding. These features and a couple more are now included in the [Ubuntu Bionic Server ISO](https://www.ubuntu.com/download/server).

## Proxy

First, users now have the ability to specify a proxy early in the install. The majority of users can hit enter and skip this screen without any changes. However, some users, mainly corporate users, who are behind proxies and can now set the appropriate value on this screen.

![proxy](/img/ubuntu/subiquity/proxy.png#center)

## Mirror

A user can now specify a different mirror to install from. Some users may have a better connection to a [mirror of archive.ubuntu.com](https://launchpad.net/ubuntu/+archivemirrors) or wish to use a local mirror. This screen allows for entering that information.

![mirror](/img/ubuntu/subiquity/mirror.png#center)

## Networking

New to networking comes the ability to create bonds using the discovered networking devices and specify VLAN IDs on devices.

![network connections](/img/ubuntu/subiquity/network_connections.png#center)

## Bonding

At the bottom of the network connections screen the new "Create bond" option will prompt a user to select the slave devices, bond mode, and appropriate bond options. All the various types of bond modes are provided as options to the user. If a bond mode also has additional parameters then those can be customizable further down.

![create bond](/img/ubuntu/subiquity/create_bond.png#center)

For more information on bonds, including a breakdown of the various bonding modes, check out the [Ubuntu Bonding](https://help.ubuntu.com/community/UbuntuBonding) page on the wiki.

## VLANs

To add a VLAN to an interface a user selects the devices and chooses "Add a VLAN tag". In the new windows enter the appropriate VLAN ID.

![vlan](/img/ubuntu/subiquity/vlan.png#center)

For more information on VLANs, check out the [vlan](https://wiki.ubuntu.com/vlan) page on the wiki.

## Filesystem

The filesystem setup screen was updated to include an additional option to allow for the commonly requested LVM setup across an entire disk.

![filesystem setup](/img/ubuntu/subiquity/filesystem_setup.png#center)

If the user instead chooses to select a manual install method, two new options to provide the ability to create a Software RAID volume and to create an LVM volume group:

![lvm + raid](/img/ubuntu/subiquity/lvm_raid.png#center)

### Software RAID

The Software RAID screen allows the user to select the RAID level and then the specific drives for the RAID group. The correct minimum number of drives is required before continuing. Finally, the total amount of useable space will be shown at the bottom depending on the type of RAID level as well as the size and number of drives.

![raid](/img/ubuntu/subiquity/raid.png#center)

### LVM

Creating LVM volume groups is as easy as selecting the drive or drives required for the group. Afterwards the user can create a logical volume on top of the group and specify the size, format type, and mount point.

![lvm](/img/ubuntu/subiquity/lvm.png#center)

## Try It

With the recent release of 18.04.1, if you are getting ready to install Bionic Server please give the new subiquity-based [Ubuntu Bionic Server ISO](https://www.ubuntu.com/download/server) a try!

## Resources

* [Subiquity Source Code](https://github.com/CanonicalLtd/subiquity)
* [Subiquity Bugs](https://bugs.launchpad.net/subiquity)
