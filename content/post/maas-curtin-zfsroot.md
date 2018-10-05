---
title: "Deploying Ubuntu root on ZFS with MAAS"
date: 2018-10-05
tags: ["ubuntu", "maas", "zfs"]
draft: true
---

# Deploying Ubuntu root on ZFS with MAAS

With recent updates to [MAAS](https://maas.io/) and [Curtin](https://launchpad.net/curtin), deploying Ubuntu with a ZFS root disk is now possible! Curtin added [zfsroot support](https://git.launchpad.net/curtin/commit/?id=15c15c7d496fe2f20a4f998fe0892fb3834c0a7a) earlier this year and MAAS has now exposed the option.

ZFS is known for its amazing list of features:

* copy-on-write cloning
* continuous integrity checking against data corruption
* snapshots
* automatic repair
* efficient data compression

The following takes a look at how using ZFS for the root filesystem of an Ubuntu system can take advantage of these features.

## MAAS Configuration

As with other MAAS settings, configuring a ZFS root disk is as easy as choosing ZFS as the partition type and setting `/` as the mount point:

![partitions](/img/maas/zfsroot/filesystems.png#center)

Once applied, the resulting disk setup should then look like the following with a EFI boot partition and the ZFS root partition:

![filesystem](/img/maas/zfsroot/partitions.png#center)

### MBR vs GPT

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

## Post-Deploy Verification

After the deployment, a user can verify the ZFS root filesystem using `lsblk` and `parted` as well as using ZFS commands:

```shell
$ lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda      8:0    0 232.9G  0 disk
├─sda1   8:1    0   476M  0 part /boot/efi
└─sda2   8:2    0 232.4G  0 part
$ sudo parted /dev/sda print
Model: ATA Samsung SSD 850 (scsi)
Disk /dev/sda: 250GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system  Name  Flags
 1      1049kB  2097kB  1049kB                     bios_grub
 2      2097kB  501MB   499MB   fat32
 3      501MB   250GB   250GB   zfs

$ zfs list
NAME                 USED  AVAIL  REFER  MOUNTPOINT
rpool               6.18G   219G   176K  /
rpool/ROOT          6.18G   219G   176K  none
rpool/ROOT/zfsroot  6.18G   219G  6.18G  /
$ zpool list
NAME    SIZE  ALLOC   FREE  EXPANDSZ   FRAG    CAP  DEDUP  HEALTH  ALTROOT
rpool   232G  6.19G   226G         -      -     2%  1.00x  ONLINE  -
```

## ZFS Snapshots & Rollback

One of the key features of ZFS is the ability to provide snapshots. This demonstrates how to take a snapshot and rollback based on that snapshot.

### Snapshot

To manually take a snapshot, provide the path to the ZFS filesystem and a snapshot name in the format `filesystem@snapshot_name`. Destroying the snapshot is similarly done with the name of the snapshot. Keep in mind that ZFS datasets cannot be destroyed if a snapshot of the dataset exists.

```shell
$ sudo zfs snapshot rpool/ROOT/zfsroot@initial
$ zfs list -t snapshot
NAME                         USED  AVAIL  REFER  MOUNTPOINT
rpool/ROOT/zfsroot@initial  3.01M      -  6.18G  -
$ sudo zfs destroy rpool/ROOT/zfsroot@initial
```

### Rollback

To do a full disk rollback, using MAAS to boot into rescue mode, using a LiveCD, or recovery mode is required. Attempting to restore the root filesystem while it is mounted will not be entirely successful. Once in rescue mode, install the ZFS utilities, and run the rollback to that snapshot:

```shell
$ sudo apt update
$ sudo apt install --yes zfsutils-linux
$ sudo zfs list -t snapshot
NAME                         USED  AVAIL  REFER  MOUNTPOINT
rpool/ROOT/zfsroot@initial  3.01M      -  6.18G  -
$ sudo zfs rollback rpool/ROOT/zfsroot@initial
```

#### Mounted Restore

Even with the mounted root filesystem some minor fixes are possible. Take for example someone deleting `/srv`, an admin can attempt to use the rollback command the initial boot snapshot:

```shell
$ ls /srv/test
important
$ sudo rm -rf /srv/test
$ ls /srv/test
ls: cannot access '/srv/test': No such file or directory
$ sudo zfs rollback rpool/ROOT/zfsroot@initial
$ ls /srv/test
important
```

Snapshots are stored on the filesystem under the `/.zfs` directory and manually find the files to restore. In the case above, the admin could have gone under `/.zfs/snapshot/initial` to find the missing data:

```shell
$ ls /.zfs/snapshot/initial/srv/test/
important
```

## zfs-auto-snapshot

For more structured snapshots one option is to use [zfs-auto-snapshot](https://github.com/zfsonlinux/zfs-auto-snapshot), which is available in Ubuntu 18.04 LTS and later releases. zfs-auto-snapshot works with zfs-linux and zfs-fuse to create periodic ZFS snapshots every 15mins (keeps 4), hourly (keeps 24), daily (keeps 31), weekly (keeps 8), and monthly (keeps 12).

After an hour, a user will see a set of new snapshots:

```shell
$ zfs list -t snapshot
NAME                                                        USED  AVAIL  REFER  MOUNTPOINT
rpool@zfs-auto-snap_hourly-2018-10-01-2217                    0B      -   176K  -
rpool@zfs-auto-snap_frequent-2018-10-01-2230                  0B      -   176K  -
rpool@zfs-auto-snap_frequent-2018-10-01-2245                  0B      -   176K  -
rpool@zfs-auto-snap_frequent-2018-10-01-2300                  0B      -   176K  -
rpool@zfs-auto-snap_frequent-2018-10-01-2315                  0B      -   176K  -
rpool@zfs-auto-snap_hourly-2018-10-01-2317                    0B      -   176K  -
rpool/ROOT@zfs-auto-snap_hourly-2018-10-01-2217               0B      -   176K  -
rpool/ROOT@zfs-auto-snap_frequent-2018-10-01-2230             0B      -   176K  -
rpool/ROOT@zfs-auto-snap_frequent-2018-10-01-2245             0B      -   176K  -
rpool/ROOT@zfs-auto-snap_frequent-2018-10-01-2300             0B      -   176K  -
rpool/ROOT@zfs-auto-snap_frequent-2018-10-01-2315             0B      -   176K  -
rpool/ROOT@zfs-auto-snap_hourly-2018-10-01-2317               0B      -   176K  -
rpool/ROOT/zfsroot@zfs-auto-snap_hourly-2018-10-01-2217    4.53M      -  6.18G  -
rpool/ROOT/zfsroot@zfs-auto-snap_frequent-2018-10-01-2230  4.30M      -  6.18G  -
rpool/ROOT/zfsroot@zfs-auto-snap_frequent-2018-10-01-2245  4.17M      -  6.18G  -
rpool/ROOT/zfsroot@zfs-auto-snap_frequent-2018-10-01-2300  4.70M      -  6.18G  -
rpool/ROOT/zfsroot@zfs-auto-snap_frequent-2018-10-01-2315  4.04M      -  6.18G  -
rpool/ROOT/zfsroot@zfs-auto-snap_hourly-2018-10-01-2317     396K      -  6.18G  -
```

Once setup, zfs-auto-snapshot will log messages to syslog when a snapshot is taken:

```text
Oct  1 22:17:01 nexus zfs-auto-snap: @zfs-auto-snap_hourly-2018-10-01-2217, 1 created, 0 destroyed, 0 warnings.
Oct  1 22:30:01 nexus CRON[7717]: (root) CMD (which zfs-auto-snapshot > /dev/null || exit 0 ; zfs-auto-snapshot --quiet --syslog --label=frequent --keep=4 //)
Oct  1 22:30:01 nexus zfs-auto-snap: @zfs-auto-snap_frequent-2018-10-01-2230, 1 created, 0 destroyed, 0 warnings.
Oct  1 22:45:01 nexus CRON[7971]: (root) CMD (which zfs-auto-snapshot > /dev/null || exit 0 ; zfs-auto-snapshot --quiet --syslog --label=frequent --keep=4 //)
Oct  1 22:45:01 nexus zfs-auto-snap: @zfs-auto-snap_frequent-2018-10-01-2245, 1 created, 0 destroyed, 0 warnings.
Oct  1 23:00:01 nexus CRON[9629]: (root) CMD (which zfs-auto-snapshot > /dev/null || exit 0 ; zfs-auto-snapshot --quiet --syslog --label=frequent --keep=4 //)
Oct  1 23:00:01 nexus zfs-auto-snap: @zfs-auto-snap_frequent-2018-10-01-2300, 1 created, 1 destroyed, 0 warnings.
Oct  1 23:15:01 nexus CRON[1271]: (root) CMD (which zfs-auto-snapshot > /dev/null || exit 0 ; zfs-auto-snapshot --quiet --syslog --label=frequent --keep=4 //)
Oct  1 23:15:01 nexus zfs-auto-snap: @zfs-auto-snap_frequent-2018-10-01-2315, 1 created, 1 destroyed, 0 warnings.
Oct  1 23:17:01 nexus zfs-auto-snap: @zfs-auto-snap_hourly-2018-10-01-2317, 1 created, 0 destroyed, 0 warnings.
```

## Backup ZFS Snapshots

Of course, taking a snapshot is not a backup and as such keeping snapshots on a different system or location is wise. The following will show how to move a snapshot from a system to a remote system using the ZFS send and receive commands.

First, on the remote system create a pool to hold the backup:

```shell
$ sudo zfs create rpool/nexus
$ zfs list
NAME                 USED  AVAIL  REFER  MOUNTPOINT
rpool               6.18G   219G   176K  /
rpool/ROOT          6.18G   219G   176K  none
rpool/ROOT/zfsroot  6.18G   219G  6.18G  /
rpool/nexus          176K   219G   176K  /nexus
```

Assuming the user already has SSH keys in place to allow for passwordless login then it is time to run the backup. This is done using the `send` and `recv` ZFS sub-commands to send a snapshot from the local system and have it received by the remote system:

```shell
sudo zfs send rpool/ROOT/zfsroot@zfs-auto-snap_frequent-2018-10-01-2245 \
    | ssh falcon "sudo zfs recv rpool/nexus/frequent"
```

On the remote system, verify the snapshot was received on the remote system by looking at the pool and the snapshot listing:

```shell
$ zfs list
NAME                   USED  AVAIL  REFER  MOUNTPOINT
rpool                 12.4G   212G   176K  /
rpool/ROOT            6.18G   212G   176K  none
rpool/ROOT/zfsroot    6.18G   212G  6.18G  /
rpool/nexus           6.18G   212G   184K  /nexus
rpool/nexus/frequent  6.18G   212G  6.18G  /nexus/frequent
$ zfs list -t snapshot
NAME                                                          USED  AVAIL  REFER  MOUNTPOINT
rpool/nexus/frequent@zfs-auto-snap_frequent-2018-10-01-2245   232K      -  6.18G  -
```

Finally, to pull a snapshot back to the local system use the same `send` and `recv` ZFS sub-commands in the opposite direction:

```shell
sudo zfs send rpool/nexus/frequent@zfs-auto-snap_frequent-2018-10-01-2245 \
    | ssh nexus "sudo zfs recv rpool/ROOT/zfsroot
```

## Conclusion

Hopefully this demonstrates the ease of setting up root ZFS with MAAS and the possible features that can be used as a part of such a configuration. Consider taking root ZFS for a spin with MAAS!
