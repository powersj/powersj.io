---
title: "Ubuntu Bionic: Subiquity Server ISO"
date: 2018-01-25
tags: ["ubuntu", "bionic", "subiquity", "iso"]
draft: false
---

# Subiquity

For this week's [test blitz]({{< ref "ubuntu-bionic-test-blitz.md" >}}), I took the new server installer, subiquity, for a spin.

## Get Subiquity

The installer is referred to as the server-live ISO and is available for amd64, arm64, and ppc64el systems.

The [daily live-server ISO](http://cdimage.ubuntu.com/ubuntu-server/daily-live/current/) has the latest and greatest, but can also break from time to time as it will install the in development release, in this case Bionic Beaver. This ISO will have the latest features and enhancements to subiquity.

There is also a daily live-server ISO for the current release of [Ubuntu 17.10 (Artful Aardvark)](http://cdimage.ubuntu.com/ubuntu-server/artful/daily-live/current/).

## Booting

For my testing I used virt-manager, but you can also use qemu directly to fire up a quick virtual machine to try subiquity out:

```shell
qemu-img create -f qcow2 vdisk.img 20G
qemu-system-x86_64 -enable-kvm  -cpu host -m 1024 -boot d -hda vdisk.img -cdrom bionic-live-server-amd64.iso
```

Once started we are greeted with the 18.04 splash screen and then the language selection:

![splash screen](/img/ubuntu/subiquity/splash.png#center)

![language select](/img/ubuntu/subiquity/language.png#center)

## Network

The first step is configuring the network device. By default the installer will choose to use DHCP on all devices and attempt to get networking going. If that fails you will need to configure the devices some other way. Unlike the previous installers the configuration you make here will also be used to configure your system after the install. Right now the setup is fairly simple and only allows for static addressing, DHCP, or not configuring the device:

![network setup](/img/ubuntu/subiquity/network.png#center)

![ens3 setup](/img/ubuntu/subiquity/ens3.png#center)

## Storage

The next step is storage setup. Here the user has a choice of using an entire disk or going so far and creating a variety of custom partitioning schemes. I find this much easier to use than on the normal server ISO. Once this is configured the install can begin.

![filesystem setup](/img/ubuntu/subiquity/filesystem.png#center)

![custom partitioning](/img/ubuntu/subiquity/partitioning.png#center)

## Install

Once the networking and storage options are set the install will begin in the background. During that time the user is asked to setup his or her profile details. A nice new addition is the ability to pull in SSH keys directly from GitHub, Launchpad, and Ubuntu One accounts.

Finally, if there are no issues or errors during the install the system will prompt you to reboot and remove the install media and you can then boot into your freshly installed Ubuntu server system!

![profile](/img/ubuntu/subiquity/profile.png#center)

![import ssh key](/img/ubuntu/subiquity/ssh_keys.png#center)

![install](/img/ubuntu/subiquity/install.png#center)

## Try Subiquity

If you have not already, it would be asked, if you could give Subiquity a try! If you have a favorite virtualization software or custom disk setup that you use then making sure it works before Bionic is released is important.

You can get the latest the latest ISO at the download link below and file any bugs you come across as well.

## Resources

* [Ubuntu Bionic Daily Live ISO Download](http://cdimage.ubuntu.com/ubuntu-server/daily-live/current/)
* [Subiquity Source Code](https://launchpad.net/subiquity)
* [Subiquity Bugs](https://bugs.launchpad.net/subiquity)
