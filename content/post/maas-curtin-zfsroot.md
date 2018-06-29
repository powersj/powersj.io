---
title: "Deploying Ubuntu with MAAS and ZFS root"
date: 2018-07-14
tags: ["ubuntu", "maas", "zfs"]
draft: true
---

# Deploying Ubuntu with MAAS and ZFS root

With recent updates to MAAS and Curtin, deploying Ubuntu with a ZFS root disk is now possible! Curtin added [zfsroot support](https://git.launchpad.net/curtin/commit/?id=15c15c7d496fe2f20a4f998fe0892fb3834c0a7a) earlier this year and MAAS also exposed the option.

## MAAS Setup

As with other MAAS settings, configuring a ZFS root disk is as simple as choosing ZFS as the partition type and setting `/` as the mount point:

![partitions](/img/maas/zfsroot/filesystems.png#center)

The disks should then look like the following:

![filesystem](/img/maas/zfsroot/partitions.png#center)

## Post Deploy

Once the system is ready the user can login and verify the disk configuration:

```shell
ubuntu@falcon:~$ lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda      8:0    0 232.9G  0 disk
├─sda1   8:1    0   476M  0 part /boot/efi
└─sda2   8:2    0 232.4G  0 part
ubuntu@falcon:~$ sudo parted /dev/sda print
Model: ATA Samsung SSD 850 (scsi)
Disk /dev/sda: 250GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End    Size   File system  Name  Flags
 1      1049kB  500MB  499MB  fat32
 2      500MB   250GB  250GB  zfs
```

The user can also view the status of the root filesystem with the various zfs commands:

```shell
ubuntu@falcon:~$ sudo zfs list
NAME                 USED  AVAIL  REFER  MOUNTPOINT
rpool               6.18G   219G   176K  /
rpool/ROOT          6.18G   219G   176K  none
rpool/ROOT/zfsroot  6.18G   219G  6.18G  /
ubuntu@falcon:~$ sudo zpool list
NAME    SIZE  ALLOC   FREE  EXPANDSZ   FRAG    CAP  DEDUP  HEALTH  ALTROOT
rpool   232G  6.19G   226G         -      -     2%  1.00x  ONLINE  -
```

## MBR vs GPT

ZFS root does require a GPT partition record. This type of partition type is only enabled if a disk is larger than 3TB or if the system is booting via EFI.

If a user attempts to install using a ZFS root with MBR they will receive an error message:

```shell
curtin: Installation started. (18.1-17-gae48e86f-0ubuntu1~18.04.1)
third party drivers not installed or necessary.
zfsroot requires bootdisk with GPT partition table found "msdos" on disk id="sda"
curtin: Installation failed with exception: Unexpected error while running command.
Command: ['curtin', 'block-meta', 'custom']
Exit code: 3
Reason: -
Stdout: zfsroot requires bootdisk with GPT partition table found "msdos" on disk id="sda"
```
