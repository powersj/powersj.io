---
title: "Ubuntu Bionic: Netplan"
date: 2017-12-01
tags: ["ubuntu"]
draft: false
aliases:
  - /post/ubuntu-netplan/
---

For this week's [Bionic test blitz]({{< ref "ubuntu-bionic-test-blitz.md" >}}) I am looking at Netplan! [Netplan](https://wiki.ubuntu.com/Netplan) enables easily configuring networking on a system via YAML files. Netplan processes the YAML and generates the required configurations for either NetworkManager or systemd-network the system's renderer.

Netplan [replaced ifupdown](http://blog.cyphermox.net/2017/06/netplan-by-default-in-1710.html) as the default configuration utility starting with Ubuntu 17.10 Artful.

## Configuration

### Initial Setup in Bionic

When you install Bionic or use a cloud image of Bionic a file will appear in `/etc/netplan` depending on the renderer in use. Here is a breakdown of the various types:

| Install Type | Renderer         | File                          |
| ------------ | ---------------- | ----------------------------- |
| Server ISO   | systemd-networkd | `/etc/netplan/01-netcfg.yaml` |
| Cloud Image  | systemd-networkd | `/etc/netplan/50-cloud-init.yaml` |
| Desktop ISO  | NetworkManager   | `/etc/netplan/01-network-manager-all.yaml` |

Do note that configuration files can exist in three different locations with the precedence from most important to least as follows:

* `/run/netplan/*.yaml`
* `/etc/netplan/*.yaml`
* `/lib/netplan/*.yaml`

Alphabetically later files, no matter what directory they are in, will amend keys if the key does not already exist and override previous keys if they do.

### Examples

The best method for demonstrating what netplan can do is by showing some examples. Keep in mind that these are very simple examples that do not demonstrate complex situations that netplan can handle.

### Static and DHCP Addressing

The following configures four devices:

* enp3s0 setup with IPv4 DHCP
* enp4s0 setup with IPv4 static with custom MTU
* IPv6 static tied to a specific MAC address
* IPv4 and IPv6 DHCP with jumbo frames tied to a specific MAC address

```yaml
ethernets:
    enp3s0:
        dhcp4: true
    enp4s0:
        addresses:
            - 192.168.0.10/24
        gateway4: 192.168.0.1
        mtu: 1480
        nameservers:
            addresses:
                - 8.8.8.8
                - 9.9.9.9
    net1:
        addresses:
            - fe80::a00:10a/120
        gateway6: fe80::a00:101
        match:
            macaddress: 52:54:00:12:34:06
    net2:
        dhcp4: true
        dhcp6: true
        match:
            macaddress: 52:54:00:12:34:07
        mtu: 9000
```

### Bonding

Bonding can easily be configured with the required interfaces list and by specifying the mode. The mode can be any of the valid types: balance-rr, active-backup, balance-xor, broadcast, 802.3ad, balance-tlb, balance-alb. See the [bonding wiki page](https://help.ubuntu.com/community/UbuntuBonding#Descriptions_of_bonding_modes) for more details.

```yaml
bonds:
    bond0:
        dhcp4: yes
        interfaces:
            - enp3s0
            - enp4s0
        parameters:
            mode: active-backup
            primary: enp3s0
```

### Bridges

Here is a very simple example of a bridge using DHCP:

```yaml
bridges:
    br0:
        dhcp4: yes
        interfaces:
            - enp3s0
```

Additional parameters can be passed in to turn off STP for example or set priorities.

### Vlans

Similarly, vlans only require a name as the key and then an id and link to use for the vlan:

```yaml
vlans:
    vdev:
        id: 101
        link: net1
        addresses:
            - 10.0.1.10/24
    vprod:
        id: 102
        link: net2
        addresses:
            - 10.0.2.10/24
    vtest:
        id: 103
        link: net3
        addresses:
            - 10.0.3.10/24
    vmgmt:
        id: 104
        link: net4
        addresses:
            - 10.0.4.10/24
```

## Next Steps

I was left with an overall very positive impression of netplan. Having the ability to write YAML configuration files and not have to worry about how the actual configuration was generated or what commands need to be used depending on the backend simplifies the process. I would like to continue to attempt some more complex configurations that I can find as well as attempt additional test cases with the ifupdown-migrate subcommand.

## Links & References

* [Netplan Wiki](https://wiki.ubuntu.com/Netplan)
* [Netplan README](https://git.launchpad.net/netplan/tree/doc/netplan.md)
* [Netplan Source Code](https://git.launchpad.net/netplan?h=master)
* [Netplan Design Doc](https://wiki.ubuntu.com/Netplan/Design)
* [Netplan Bugs](https://bugs.launchpad.net/cloud-init)
