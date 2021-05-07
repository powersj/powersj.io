---
title: "A month with Ubuntu 18.04 LTS Bionic"
date: 2018-05-25
tags: ["ubuntu"]
draft: false
aliases:
  - /post/ubuntu-released/
---

![Banner](/img/ubuntu/bionic.jpg#center)

Almost a month ago, [Ubuntu 18.04 LTS Bionic was released](https://lists.ubuntu.com/archives/ubuntu-announce/2018-April/000231.html). While I have used Bionic on my personal workstation and laptop since the initial beta, after a month of post-release usage I can say I am absolutely thrilled with it. I have found it to be rock stable and plenty fast on both systems. I also went ahead and upgraded my local MAAS server to use Bionic and found that the upgrade occurred very smoothly.

Here are a few of my favorite features:

- **GNOME**: Desktop environments are a very personal choice and I do love MATE's clean design, but I wanted to give GNOME another chance. While I am using relatively newer and powerful systems, I found found it to be fantastic to use daily and easy to customize via various `gsettings` options.
- **netplan**: While I already [wrote about using netplan]({{< ref "ubuntu-bionic-netplan.md" >}}), I find writing my network configuration as YAML to be far more simple and straightforward and better yet allows me to not worry about further details of the configuration.
- **LXD**: A day does not go by, that I do not use LXD. The [3.0 release of LXD](https://discuss.linuxcontainers.org/t/lxd-3-0-0-has-been-released/1491), comes with clustering support and the ability to forward TCP connections between the host and containers. Makes it easy to host a site in a container or do development on various software in a container and try them out quickly.
- **Chrony**: Setting up time synchronization is even easier now with chrony. I also wrote [a post on setting up chrony]({{< ref "ubuntu-bionic-chrony.md" >}}).
- **Server Installer**: The new, super quick [server installer]({{< ref "ubuntu-bionic-subiquity.md" >}}) is also a joy to use for fast simple installs. Additional storage and networking features to bring the [installer to parity](https://lists.ubuntu.com/archives/ubuntu-server/2018-April/007695.html) with the existing installer are coming soon and more!

Onward to [Cosmic](https://www.markshuttleworth.com/archives/1521)!
