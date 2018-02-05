---
title: "Ubuntu Bionic: Server ISO"
date: 2018-02-01
tags: ["ubuntu", "bionic", "iso"]
draft: true
---

# Server ISO

After looking at the brand new [subiquity installer]({{< ref "ubuntu-bionic-subiquity.md" >}}) last week, this week's [test blitz]({{< ref "ubuntu-bionic-test-blitz.md" >}}) takes a look at the traditional ubiquity based installer.

## Get the Server ISO

The [daily server ISO](http://cdimage.ubuntu.com/ubuntu-server/daily-live/current/) has the latest and greatest features and enhancements from the development release and is available for amd64, arm64, ppc64el, and s390x systems. The i386 image was recently discontinued.

Again, be warned though that the release can also break from time to time as it will install the in development release, in this case Bionic Beaver.

## Booting

For my testing I used qemu directly as follows:

```shell
wget http://cdimage.ubuntu.com/ubuntu-server/daily/current/bionic-server-amd64.iso
qemu-img create -f qcow2 vdisk.img 20G
qemu-system-x86_64 -enable-kvm -cpu host -m 1024 -boot d -hda vdisk.img -cdrom bionic-server-amd64.iso
```








![splash screen](/img/ubuntu/subiquity/splash.png#center)

![language select](/img/ubuntu/subiquity/language.png#center)

## Network

After selecting the language, next up is to configure the network device. By default the installer will attempt to DHCP on all devices. The user can also setup a custom configuration on each device. Unlike the previous installers the configuration you make here will also be used to configure your system after the install. Right now the setup is fairly simple and only allows for static addressing, DHCP, or not configuring the device:

![network setup](/img/ubuntu/subiquity/network.png#center)

![ens3 setup](/img/ubuntu/subiquity/ens3.png#center)

## Storage

The next step is storage setup. Here the user has a choice of using an entire disk or creating potentially complex set of custom partitioning scenarios. I find this process much easier to use than on the original server ISO.

![filesystem setup](/img/ubuntu/subiquity/filesystem.png#center)

![custom partitioning](/img/ubuntu/subiquity/partitioning.png#center)

## Install

Once the networking and storage options are set the install will begin in the background. During that time the user is asked to setup his or her profile details. A nice new addition is the ability to pull in SSH keys directly from GitHub, Launchpad, and Ubuntu One accounts.

Finally, if there are no issues or errors during the install the system will prompt you to reboot, remove the install media, and you can then boot into your freshly installed Ubuntu server system!

![profile](/img/ubuntu/subiquity/profile.png#center)

![import ssh key](/img/ubuntu/subiquity/ssh_keys.png#center)

![install](/img/ubuntu/subiquity/install.png#center)

## Try Subiquity

If you have not already please give the subiquity based server ISO a try! If you have a favorite virtualization software or custom disk setup that you use then making sure it works before Bionic is released is important to us.

You can get the latest ISO at the download link below and file any bugs you come across as well.

## Resources

* [Ubuntu Bionic Daily Live ISO Download](http://cdimage.ubuntu.com/ubuntu-server/daily-live/current/)
* [Subiquity Source Code](https://launchpad.net/subiquity)
* [Subiquity Bugs](https://bugs.launchpad.net/subiquity)
