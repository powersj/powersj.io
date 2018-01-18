---
title: "LXD: Machine containers for Development"
date: 2017-04-18
tags: ["lxd", "lxc", "containers", "ubuntu"]
draft: false
---

# Overview

LXD is an awesome tool in my toolbox that I use everyday. LXD offers a streamlined user experience to Linux containers making them easy and simple to use. These containers are referred to as system containers or machine containers as they are not focused on a single process or software distribution. The project is [very well documented](https://linuxcontainers.org/lxd/introduction/) and even has a [try it online](https://linuxcontainers.org/lxd/try-it/) service available.

[Stephane Graber's LXD 2.0 blog post series](https://stgraber.org/2016/03/11/lxd-2-0-introduction-to-lxd-112/) is required reading. He gives a great introduction and overview of all the major features and functionality of LXD including images, profiles, configuration, and snapshots.

In my use, rather that booting up a VM I can quickly use LXD to boot up a variety of operating systems. I can then use various containers for bug reproduction and triage or to try new deployment scripts and tests in a clean enviornment.

# Install

LXD is easily installed in Ubuntu with apt and there is also the option of using a PPA to get the latest upstream release quickly. All of this is part of the [excellent documentation](https://linuxcontainers.org/lxd/getting-started-cli/).

The only item I would call out is running `lxd init`. This command is what sets up and configures the LXD daemon by telling it what storage and networking to use. Normally pressing enter through the process will get the correct settings, but it is worth reading through each option.

# Usage

While the tool is called lxd, the commands all center around 'lxc'. The basics include listing your containers with `lxc list`. To get pre-build images you can look at two example image remotes by running `lxc image list images:` or `lxc image list ubuntu:`. Based on those results launching an image is as simple as `lxc image launch ubuntu:xenial <name>`.

Executing on a container is done via `lxc exec <name> <command>`.

Stopping and deleting a container is done via `lxc stop <name>` and `lxc delete <name>`.

For even more details again take a look at [Stephane's blog post](https://stgraber.org/2016/03/11/lxd-2-0-introduction-to-lxd-112/).

# Reset

Sometimes there are days where I am switching between versions or trying various features out and I run into an issue with LXD. In these cases I like to wipe LXD out and start from scratch. This documents the process I take.

First, start with removing any containers or images and the packages themselves:

```shell
lxc list
lxc list -c n | grep '^|' | cut -d' ' -f2 | sed -n '1!p' | xargs lxc delete --force
lxc image list
lxc image list | grep '^|' | cut -d' ' -f9 | xargs lxc image delete
sudo apt-get purge lxd lxc
```

The reset is not done at this point. There are a few other areas to go and cleanup that will make sure that a new version or older version of lxd will not have any issues.

If lxd was setup to use zfs, delete the zpool lxd was using:

```shell
sudo zpool list
sudo zpool destroy default  # maybe named lxd in older versions
```

Delete the lxd bridge:

```shell
sudo ip link set lxdbr0 down
sudo brctl delbr lxdbr0
```

Finally, remove any final items in var, like logs:

```shell
sudo umount -l /var/lib/lxd/shmounts
sudo umount -l /var/lib/lxd/devlxd
sudo rm -Rf /var/lib/lxd
sudo rm -Rf /var/log/lxd
sudo rm -Rf /var/log/lxc
```

I suggest doing a reboot at this point to make sure things are fully cleaned up. Then afterwards reinstall and configure LXD:

```shell
sudo apt update
sudo apt upgrade
sudo apt install lxd lxc
sudo lxd init
```
