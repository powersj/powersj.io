---
title: "Deploying Ubuntu root on ZFS with MAAS"
date: 2018-10-12
tags: ["ubuntu", "maas", "zfs"]
draft: false
---

# Deploying Ubuntu root on ZFS with MAAS

With [recent updates](https://docs.maas.io/2.4/en/intro-new) to [MAAS](https://maas.io/) and [Curtin](https://launchpad.net/curtin), deploying Ubuntu with a ZFS root disk is now possible! Curtin added [zfsroot support](https://git.launchpad.net/curtin/commit/?id=15c15c7d496fe2f20a4f998fe0892fb3834c0a7a) earlier this year and MAAS has now exposed the option.

ZFS is known for an amazing list of features:

* copy-on-write cloning
* continuous integrity checking
* snapshots
* automatic repair
* efficient data compression

The following article takes a look at how using ZFS for the root filesystem of an Ubuntu system can take advantage of these features.

## MAAS Configuration

As with other MAAS settings, configuring a ZFS root disk is as easy as choosing ZFS as the partition type and setting `/` as the mount point:

![partitions](/img/maas/zfsroot/filesystems.png#center)

Once applied, the resulting disk setup should then look like the following with a EFI boot partition and the ZFS root partition:

![filesystem](/img/maas/zfsroot/partitions.png#center)

### MBR Partition Record

To use ZFS root MAAS requires the disk use a GPT partition record. This type of partition type is only enabled if a disk is larger than 3TB or if the system is booting via EFI.

If a user attempts to install using a ZFS root with MBR they will receive an error message:

```text
zfsroot requires bootdisk with GPT partition table found "msdos" on disk id="sda"
```

## Post-Deploy Verification

After the deployment, a user can verify the ZFS root filesystem using `lsblk`, `parted`, as well as using ZFS commands.

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

The `lsblk` output matches the requested MAAS storage configuration. Parted output shows how the file system is using ZFS and the `zfs` and `zpool` commands show the pool used by the ZFS root.

## ZFS Snapshots & Rollback

One of the key features of ZFS is the ability to provide snapshots. The following demonstrates how to take a snapshot and rollback the entire or part of the filesystem based on that snapshot.

### Snapshot

To manually take a snapshot, provide the path to the ZFS filesystem and a snapshot name in the format `filesystem@snapshot_name`. Destroying the snapshot is similarly done with the name of the snapshot. Note that ZFS datasets cannot be destroyed if a snapshot of the dataset exists.

```shell
$ sudo zfs snapshot rpool/ROOT/zfsroot@initial
$ zfs list -t snapshot
NAME                         USED  AVAIL  REFER  MOUNTPOINT
rpool/ROOT/zfsroot@initial  3.01M      -  6.18G  -
$ sudo zfs destroy rpool/ROOT/zfsroot@initial
```

### Rollback

To do a full disk rollback, first requires that the root file system get unmounted as a mounted filesystem cannot be completely restored and will not be completely successful. The actual mechanism in ZFS will attempt to unmount a mounted filesystem during rollback.

The easiest way is to use MAAS to boot into rescue mode. This is done by selecting `Rescue mode` from the `Take action` menu of the node:

![rescue mode](/img/maas/zfsroot/rescue_mode.png#center)

Once in rescue mode, all that is required is to install the ZFS utilities and rollback to the specified snapshot. The system then needs to exit rescue mode via MAAS and the user can boot back into the restored system.

```shell
$ sudo apt update
$ sudo apt install --yes zfsutils-linux
$ sudo zfs list -t snapshot
NAME                         USED  AVAIL  REFER  MOUNTPOINT
rpool/ROOT/zfsroot@initial  3.01M      -  6.18G  -
$ sudo zfs rollback rpool/ROOT/zfsroot@initial
```


#### Manual Restore

Even with the mounted root filesystem some fixes are possible. Snapshots are stored on the filesystem under the `/.zfs` directory. A user can find the files under the appropriate snapshot and directory and attempt to restore them.

Take for example someone deleting `/srv`, the admin could have gone under `/.zfs/snapshot/initial` to find the missing data.

```shell
$ ls /srv/test
important
$ sudo rm -rf /srv
$ ls /srv/test
ls: cannot access '/srv/test': No such file or directory
$ ls /.zfs/snapshot/initial/srv/test/
important
```

## zfs-auto-snapshot

Snapshots are cheap, worth having, and [zfs-auto-snapshot](https://github.com/zfsonlinux/zfs-auto-snapshot). makes setting consistent snapshots easily. zfs-auto-snapshot is available in Ubuntu 18.04 LTS and later releases and works with zfs-linux and zfs-fuse to create periodic ZFS snapshots at the following intervals:

* every 15mins and keeps 4
* hourly and keeps 24
* daily and keeps 31
* weekly and keeps 8
* monthly and keeps 12

An hour after installing, a user will see a set of new snapshots.

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

Once setup, zfs-auto-snapshot will log messages to syslog when a snapshot is taken.

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

Of course, taking a snapshot is great for rollbacks due to mistakes, but snapshots are not to be considered a backup. As a result, keeping snapshots on a different system or location is essential if the data is considered critical.

Snapshots can be sent to a file or received from a file to allow for simple backup and restore.

```shell
sudo zfs send rpool/nexus/frequent@zfs-auto-snap_frequent-2018-10-01-2245 \
    > /tmp/frequent-2018-10-01-2245.bak
sudo zfs recv rpool/nexus/frequent@zfs-auto-snap_frequent-2018-10-01-2245 \
    < /tmp/frequent-2018-10-01-2245.bak
```

Another option is to send the snapshots to a remote system already setup with ZFS. First, on the remote system that will store our backup of a ZFS snapshot create a pool to store the snapshots.

```shell
$ sudo zfs create rpool/nexus
$ zfs list
NAME                 USED  AVAIL  REFER  MOUNTPOINT
rpool               6.18G   219G   176K  /
rpool/ROOT          6.18G   219G   176K  none
rpool/ROOT/zfsroot  6.18G   219G  6.18G  /
rpool/nexus          176K   219G   176K  /nexus
```

Assuming the user already has SSH keys in place to allow for passwordless login then it is time to send the ZFS snapshot. This is done using the `send` and `recv` ZFS sub-commands to send a snapshot from the local system and have it received by the remote system.

```shell
sudo zfs send rpool/ROOT/zfsroot@zfs-auto-snap_frequent-2018-10-01-2245 \
    | ssh falcon "sudo zfs recv rpool/nexus/frequent"
```

On the remote system, verify the snapshot was received by looking at the pool and the snapshot listing.

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

Finally, to pull a snapshot back to the local system use the same `send` and `recv` ZFS sub-commands in the opposite direction.

```shell
sudo zfs send rpool/nexus/frequent@zfs-auto-snap_frequent-2018-10-01-2245 \
    | ssh nexus "sudo zfs recv rpool/ROOT/zfsroot
```

## Scrub

As mentioned at the beginning ZFS has the ability to silently correct data errors. This is accomplished through the scrub action. A scrub will go through every block of the pool and compare it against the known checksum for that block. The consequence of which is that a scrub can impact performance of the disk while run.

By default zfsutils-linux will come with a crontab entry that will scrub the disks.

```shell
$ cat /etc/cron.d/zfsutils-linux
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# Scrub the second Sunday of every month.
24 0 8-14 * * root [ $(date +\%w) -eq 0 ] && [ -x /usr/lib/zfs-linux/scrub ] && /usr/lib/zfs-linux/scrub
```

A user can setup a second crontab to run more periodically if necessary or a scrub can also get executed manually.

```shell
$ sudo zpool scrub rpool
$ sudo zpool status rpool
  pool: rpool
 state: ONLINE
  scan: scrub repaired 0B in 0h0m with 0 errors on Thu Oct 11 16:55:14 2018
config:

   NAME                                                   STATE     READ WRITE CKSUM
   rpool                                                  ONLINE       0     0     0
     ata-Samsung_SSD_850_EVO_250GB_S2R5NX0HB20702T-part3  ONLINE       0     0     0

errors: No known data errors
```

## Upgrade

The most reason versions of ZFS utilize dataset feature flags to specify a property for changes to on-disk formats. The original method was a single version number, but given OpenZFS is developed distributedly rather than by a single company, utilizing feature flags make for easier determination of features supported versus the single number.

If a user attempts to enable a feature that the dataset version does not support a message requesting an upgrade will appear. Upgrading a dataset is as simple as running upgrade on that specific dataset. However, do note that an upgrade is a one-way path and may make the dataset unavailable to tools which do not support a particular feature.

```shell
$ sudo zfs set compression=lz4 rpool
cannot set property for 'rpool': pool and or dataset must be upgraded to set this property or value
$ sudo zpool upgrade rpool
This system supports ZFS pool feature flags.

Successfully upgraded 'rpool' from version 28 to feature flags.
Enabled the following features on 'rpool':
  async_destroy
  empty_bpobj
  lz4_compress
  multi_vdev_crash_dump
  spacemap_histogram
  enabled_txg
  hole_birth
  extensible_dataset
  embedded_data
  bookmarks
  filesystem_limits
  large_blocks
  large_dnode
  sha512
  skein
  edonr
  userobj_accounting

```

## Compression

The first of two ways to save disk space is to enable compression. With ZFS compression is done transparent to the user, as ZFS is compressing and decompressing data on the fly. Files that are not already compressed will take advantage of this, while already compressed data will not. The overall cost to enabling compression however is minimal due to modern processors handling the work easily.

The LZ4 algorithm is generally considered the best starting point if a user is uncertain of what type of compression to enable.

```shell
$ sudo zfs set compression=lz4 rpool
$ zfs get compression rpool
NAME                PROPERTY     VALUE     SOURCE
rpool  compression  lz4       local
```

A user can judge the overall efficiency of enabling compression by viewing the compression ratio on the pool. Do note that enabling compression on a dataset is not retroactive. As such the compression will only occur on new and modified data after enabling it.

```shell
$ sudo zfs get compressratio rpool
NAME                PROPERTY       VALUE  SOURCE
rpool  compressratio  1.00x  -
```

## Deduplication

A second mechanism of saving disk space is to enable deduplication. ZFS utilizes block level deduplication, rather than file or byte level, as it is a nice trade off in terms of speed and storage.

A user must be extremely careful when enabling deduplication and understand the risks associated with it. To achieve performance to justify deduplication the system is required to have sufficient memory to store deduplicate data. In the event that not enough memory exists the duplication data gets written to disk reducing performance greatly. Turning deduplication off will not solve any scenarios where the duplication table is already getting written to disk.

A general heuristic for system memory is for every TB of pool data the system should have 20GB of system memory. The large number is due to the need to account for the needs of memory for the operating system, workload, other metadata, and to account for the deduplication table to minimize the possibility of writing to disk.

In order to first test if deduplication would have any effect a user can test it by created a test pool, enable deduplication, and copy test data over. A second option is to use the `zdb -S` command to simulate deduplication and get an estimated measure of the effect.

```shell
$ sudo zfs set dedup=on rpool
$ sudo zfs get dedup rpool
NAME                PROPERTY  VALUE          SOURCE
rpool  dedup     on             local
```

## Additional Pools

Finally, if users have additional disks they can take advantage of the aforementioned ZFS features using additional pools.

In this example, two new disks `/dev/sdb` and `/dev/sdc` were added to the system.

```shell
$ lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda      8:0    0 232.9G  0 disk
├─sda1   8:1    0     1M  0 part
├─sda2   8:2    0   476M  0 part /boot/efi
└─sda3   8:3    0 232.4G  0 part
sdb      8:16   1  14.6G  0 disk
sdc      8:32   1  14.6G  0 disk
```

To create a new pool, a user runs using the create command and pointing at the additional disks.

```shell
$ sudo zpool create tank sdb sdc
$ zpool list
NAME    SIZE  ALLOC   FREE  EXPANDSZ   FRAG    CAP  DEDUP  HEALTH  ALTROOT
rpool   232G  7.97G   224G         -     0%     3%  1.00x  ONLINE  -
tank     29G    93K  29.0G         -     0%     0%  1.00x  ONLINE  -
$ zpool status -v tank
  pool: tank
 state: ONLINE
  scan: none requested
config:

	NAME        STATE     READ WRITE CKSUM
	tank        ONLINE       0     0     0
	  sdb       ONLINE       0     0     0
	  sdc       ONLINE       0     0     0

errors: No known data errors
```

## Conclusion

MAAS enables users to easily deploy ZFS as their root filesystem and explore advanced filesystem features. Consider taking root ZFS for a spin with MAAS!

## References

* [MAAS](https://maas.io/)
* [MAAS Docs](https://docs.maas.io/)
* [ZFS on Ubuntu](https://wiki.ubuntu.com/ZFS)
* [OpenZFS Docs](http://open-zfs.org/wiki/System_Administration)
