---
title: "Editing a Raspbian Image on Ubuntu"
date: 2018-04-13
tags: ["ubuntu"]
draft: false
aliases:
  - /post/raspbian-edit-image/
---

I have spent a lot of time recently playing with a variety of Raspberry Pi models. A large part of that time was spent moving a micro-SD card between a system to edit the image and my computer to clone it to other systems.

This post describes how to mount a Raspbian image on your local system so you can make edits to the image without needing to move it back and forth.

## Prereqs and the Image

First, to mount the image requires a few qemu packages:

```shell
sudo apt install -y binfmt-support qemu qemu-user-static
```

Next, the [latest Raspbian images](https://www.raspberrypi.org/downloads/raspbian/) are available on the Raspberry Pi website. I use the Lite image as I have no need for any desktop environment and prefer the lighter image.

```shell
$ wget -O raspbian.gz https://downloads.raspberrypi.org/raspbian_lite_latest
$ unzip raspbian.gz && mv *-raspbian-*.img raspbian.img
$ ls
raspbian.img raspbian.gz
```

## Mounting the Image

I am going to demonstrate two methods for mounting the image one requires a little math the other requires the ability to mount loop devices.

### By Offset

The raspbian image has two partitions on it as seen from fdisk:

```shell
$ fdisk -l raspbian.img
Disk raspbian.img: 1.7 GiB, 1858076672 bytes, 3629056 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xa8fe70f4

Device        Boot Start     End Sectors  Size Id Type
raspbian.img1       8192   93802   85611 41.8M  c W95 FAT32 (LBA)
raspbian.img2      98304 3629055 3530752  1.7G 83 Linux
```

The second partition is what I want to mount and make change to. To mount the image it requires us to calculate the offset from the start of the disk to the second partition. To do so we use the following equation:

```math
offset = I/O size * start of partition
offset = 512 * 98304
offset = 50331648
```

Time to mount the image:

```shell
sudo mount -o loop,offset=50331648 raspbian.img /mnt
```

### By Loopback Device

Begin by setting up a loopback device. The below will automatically find the next loop device to use and scan and mount the partitions. This way there is no need to calculate any offsets:

```shell
$ sudo losetup --find --partscan --show raspbian.img
/dev/loop19
$ lsblk /dev/loop19
NAME       MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
loop19       7:19   0  1.7G  0 loop
├─loop19p1 259:2    0 41.8M  0 loop
└─loop19p2 259:3    0  1.7G  0 loop
```

The p# loop devices are each of the partitions, where p1 is the boot partition and p2 is the partition to customize want. Next, mount that partition:

```shell
sudo mount /dev/loop19p2 -o rw /mnt
```

## QEMU

Before using the image there is one more step required, which involves copying the QEMU ARM static binary into the mount so binfmt-support can execute the commands we wish to run once we change into the image's root filesystem.

```shell
sudo cp /usr/bin/qemu-arm-static /mnt/usr/bin/
```

## chroot

Time to use the mounted filesystem:

```shell
$ sudo chroot /mnt bin/bash
$ uname -a
Linux z170 4.15.0-13-generic #14-Ubuntu SMP Sat Mar 17 13:44:27 UTC 2018 armv7l GNU/Linux
$ exit
$ sudo unmount /mnt
# if you mounted it using loop devices
$ sudo losetup -d /dev/loop19
```

Woohoo! I am now inside the armv7l image and able to modify as necessary.

## Enlarge the Image

Depending on what you might be doing with the image, it may be required to make the image larger. If that is required running the following will give the image another 1Gb of space.

***BEFORE*** beginning, you should make a ***backup*** of the image if it has something critical on it. These steps could lead to the loss of data if not done correctly.

Begin with the image umounted and pretend the image needs to grow by 512MB:

```shell
$ sudo dd if=/dev/zero bs=1M count=512 >> raspbian.img
512+0 records in
512+0 records out
536870912 bytes (537 MB, 512 MiB) copied, 0.193115 s, 2.8 GB/s
$ sync
$ sudo losetup --find --partscan --show raspbian.img
/dev/loop27
$ sudo parted /dev/loop27
GNU Parted 3.2
Using /dev/loop27
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) print
Model: Loopback device (loopback)
Disk /dev/loop27: 2395MB
Sector size (logical/physical): 512B/512B
Partition Table: msdos
Disk Flags:

Number  Start   End     Size    Type     File system  Flags
 1      4194kB  48.0MB  43.8MB  primary  fat32        lba
 2      50.3MB  1858MB  1808MB  primary  ext4

(parted) rm 2
# The first number comes from the start of partition 2 as stated above
# The second number comes from the disk size listed above
# This results in expanding the partition to the total size of the disk
(parted) mkpart primary 50.3 2395
(parted) print
Model: Loopback device (loopback)
Disk /dev/loop27: 2395MB
Sector size (logical/physical): 512B/512B
Partition Table: msdos
Disk Flags:

Number  Start   End     Size    Type     File system  Flags
 1      4194kB  48.0MB  43.8MB  primary  fat32        lba
 2      50.3MB  2395MB  2345MB  primary               lba

(parted) quit
Information: You may need to update /etc/fstab.
```

The final step is to clean and then grow the filesystem. Not the only change made above was to the partition, not the filesystem. These commands are fairly straight forward and should return with no errors:

```shell
$ sudo e2fsck -f /dev/loop27p2
e2fsck 1.44.1 (24-Mar-2018)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
rootfs: 39502/110432 files (0.1% non-contiguous), 258117/441344 blocks
$ sudo resize2fs /dev/loop27p2
resize2fs 1.44.1 (24-Mar-2018)
Resizing the filesystem on /dev/loop27p2 to 572416 (4k) blocks.
The filesystem on /dev/loop27p2 is now 572416 (4k) blocks long.
```
