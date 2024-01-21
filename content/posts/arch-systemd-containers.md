---
title: "systemd-nspawn Containers with Arch Linux"
date: 2024-01-16
tags: ["linux"]
draft: false
aliases:
  - /post/arch-systemd-containers/
---

The following is a quick guide to create systemd-nspawn container, which is a
super-powered chroot on Arch Linux. There are a ton of ways to pull down or
create container images, as well as options to launch and control containers.
The following is only a sample of what I use to quickly get started.

## Build the container image

There are a number of tools or ways to create images. I use debootstrap:

```shell
sudo pacman -S debootstrap
```

This will demonstrate with an Ubuntu image. I need to pull down the base
packages from an [Ubuntu archive mirror][]:

[Ubuntu archive mirror]: https://launchpad.net/ubuntu/+archivemirrors

```shell
$ sudo debootstrap --include=systemd-container --components=main,universe \
    focal ubuntu-focal https://mirror.enzu.com/ubuntu/
...
I: Base system installed successfully.
~ took 2m52s
```

This creates a Ubuntu Focal container in a folder called 'ubuntu-focal' using
the specified mirror. Users can add and customize the container with any of the
other debootsrap parameters as well.

## Customize the image

Users can also copy any files directly into the directory structure at this
point.

While optional, it is nice to set a password before booting the full system:

```shell
$ sudo systemd-nspawn -D ubuntu-focal/
Spawning container ubuntu on /home/powersj/ubuntu-focal.
Press ^] three times within 1s to kill container.
root@ubuntu:~# passwd
New password:
Retype new password:
passwd: password updated successfully
root@ubuntu:~# logout
Container ubuntu exited successfully.
```

## Start the container

Finall, boot the container, using the `-b` flag to invoke init and complete a
full boot pointing to the directory of the container we created:

```shell
$ sudo systemd-nspawn -b -D ubutnu-focal
Spawning container ubuntu-focal on /home/powersj/ubuntu-focal.
Press Ctrl-] three times within 1s to kill container.
systemd 245.4-4ubuntu3 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN2 -IDN +PCRE2 default-hierarchy=hybrid)
Detected virtualization systemd-nspawn.
Detected architecture x86-64.

Welcome to Ubuntu 20.04 LTS!

...

Ubuntu 20.04 LTS x1c6 console

x1c6 login:
```

## machinectl

The `machinectl` command is useful to out what containers are running as well
as to manage other containers:

```shell
❯ machinectl
MACHINE      CLASS     SERVICE        OS     VERSION ADDRESSES
ubuntu-focal container systemd-nspawn ubuntu 20.04   -

1 machines listed.
```
