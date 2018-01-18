---
title: "Using chdist for Distro Package Info"
date: 2017-10-19
tags: ["ubuntu", "debian"]
draft: false
---

I commonly rely on rmadison output to give me information about what version of a package is in a specific release. For example, what is the version of qemu in xenial or what version of apt is in Debian. I filtered the below examples on the amd64 architecture to keep the output sane:

```shell
$ rmadison qemu -a amd64 | grep xenial
 qemu | 1:2.5+dfsg-5ubuntu10    | xenial/universe           | amd64
 qemu | 1:2.5+dfsg-5ubuntu10.16 | xenial-security/universe  | amd64
 qemu | 1:2.5+dfsg-5ubuntu10.16 | xenial-updates/universe   | amd64
$ rmadison apt -u debian -a amd64
apt        | 0.9.7.9+deb7u7 | oldoldstable | amd64
apt        | 1.0.9.8.4      | oldstable    | amd64
apt        | 1.4.8          | stable       | amd64
apt        | 1.5            | testing      | amd64
apt        | 1.5            | unstable     | amd64
```

There are times where I need additional details about the package. Maybe I need to grep the control file for something or I am interested in additional details about the source package, like what binaries it produces. In these cases, my reliance on rmadison is insufficient and I have relied upon using LXD  machine containers to have a container of each release up and running.

# chdist

chdist is a "script to easily play with several distributions" per its' own man page. It is an incredibly powerful tool for querying package information and status across many distributions and one that I wish I knew about long ago.

chdist essentially keeps a directory where the apt files for the distribution that you specify to be kept. Then you can use tell chdist to use these files when running typical commands.

## Install

To get started with chdist install the devscripts package:

```shell
$ sudo apt update
$ sudo apt install -y devscripts
$ which chdist
/usr/bin/chdist
```

## Setup

To create a chdist it follows the following format:

```shell
create <DIST> [<URL> <RELEASE> <SECTIONS>]
```

The first part, '<DIST>', is the name of the chdist you will use later to refer to it, normally the release name.

The next part is optional as without it chdist creates an empty sources.list file, but if you include the information now, you can get started with your chdist right away. This part is essentially the line in a sources.list file where:

* 'URL' is the URL of the archive (e.g. http://archive.ubuntu.com/ubuntu)
* 'RELEASE' is the release you are interested in (e.g. xenial, artful, stretch)
* 'SECTIONS' are the specific sections you want (e.g. main, non-free, universe)

For example, to create an artful chdist run the following:

```shell
$ chdist create artful http://archive.ubuntu.com/ubuntu artful main restricted universe multiverse
Run chdist apt-get artful update
And enjoy.
$ chdist list
artful
$ chdist apt-get artful update
Get:1 http://archive.ubuntu.com/ubuntu artful InRelease [237 kB]
Get:2 http://archive.ubuntu.com/ubuntu artful/main Sources [850 kB]
Get:3 http://archive.ubuntu.com/ubuntu artful/universe Sources [8,719 kB]
Get:4 http://archive.ubuntu.com/ubuntu artful/restricted Sources [5,400 B]
Get:5 http://archive.ubuntu.com/ubuntu artful/multiverse Sources [182 kB]
Get:6 http://archive.ubuntu.com/ubuntu artful/main amd64 Packages [1,072 kB]
Get:7 http://archive.ubuntu.com/ubuntu artful/main Translation-en [542 kB]
Get:8 http://archive.ubuntu.com/ubuntu artful/universe amd64 Packages [8,100 kB]
Get:9 http://archive.ubuntu.com/ubuntu artful/universe Translation-en [4,788 kB]
Get:10 http://archive.ubuntu.com/ubuntu artful/restricted amd64 Packages [8,860 B]
Get:11 http://archive.ubuntu.com/ubuntu artful/restricted Translation-en [2,788 B]
Get:12 http://archive.ubuntu.com/ubuntu artful/multiverse amd64 Packages [150 kB]
Get:13 http://archive.ubuntu.com/ubuntu artful/multiverse Translation-en [108 kB]
Fetched 24.8 MB in 6s (3,914 kB/s)
Reading package lists... Done
```

Now that the chdist is setup and updated the files and structure of the chdist are available for viewing under the `$HOME/.chdist` directory. You can freely update the sources.list file just as if it were on your local system. As expected, the structure is identical to a system's apt file structure:

```shell
.chdist/artful/
├── etc
│   └── apt
│       ├── apt.conf
│       ├── apt.conf.d
│       ├── preferences.d
│       ├── sources.list
│       ├── sources.list.d
│       └── trusted.gpg.d
│           ├── ubuntu-archive-keyring.gpg -> /usr/share/keyrings/ubuntu-archive-keyring.gpg
│           └── ubuntu-archive-removed-keys.gpg -> /usr/share/keyrings/ubuntu-archive-removed-keys.gpg
└── var
    ├── cache
    │   └── apt
    │       ├── archives
    │       │   └── partial
    │       ├── pkgcache.bin
    │       └── srcpkgcache.bin
    └── lib
        ├── apt
        │   └── lists
        │       ├── archive.ubuntu.com_ubuntu_dists_artful_InRelease
        │       ├── archive.ubuntu.com_ubuntu_dists_artful_main_binary-amd64_Packages
        │       ├── archive.ubuntu.com_ubuntu_dists_artful_main_i18n_Translation-en
        │       ├── archive.ubuntu.com_ubuntu_dists_artful_main_source_Sources
        │       ├── archive.ubuntu.com_ubuntu_dists_artful_multiverse_binary-amd64_Packages
        │       ├── archive.ubuntu.com_ubuntu_dists_artful_multiverse_i18n_Translation-en
        │       ├── archive.ubuntu.com_ubuntu_dists_artful_multiverse_source_Sources
        │       ├── archive.ubuntu.com_ubuntu_dists_artful_restricted_binary-amd64_Packages
        │       ├── archive.ubuntu.com_ubuntu_dists_artful_restricted_i18n_Translation-en
        │       ├── archive.ubuntu.com_ubuntu_dists_artful_restricted_source_Sources
        │       ├── archive.ubuntu.com_ubuntu_dists_artful_universe_binary-amd64_Packages
        │       ├── archive.ubuntu.com_ubuntu_dists_artful_universe_i18n_Translation-en
        │       ├── archive.ubuntu.com_ubuntu_dists_artful_universe_source_Sources
        │       ├── lock
        │       └── partial
        └── dpkg
            └── status
```

### Older Distros

A quick note about creating a chdist for older distro's like precise. Some older releases were not signed or the signature cannot be checked due to a missing GPG key, which results in the following error message:

```shell
$ chdist apt-get precise update
Ign:1 http://archive.ubuntu.com/ubuntu precise InRelease
Hit:2 http://archive.ubuntu.com/ubuntu precise Release
Get:3 http://archive.ubuntu.com/ubuntu precise Release.gpg [198 B]
Ign:3 http://archive.ubuntu.com/ubuntu precise Release.gpg
Reading package lists... Done
W: GPG error: http://archive.ubuntu.com/ubuntu precise Release: The following signatures were invalid: 630239CC130E1A7FD81A27B140976EAF437D05B5
E: The repository 'http://archive.ubuntu.com/ubuntu precise Release' is not signed.
N: Updating from such a repository can't be done securely, and is therefore disabled by default.
N: See apt-secure(8) manpage for repository creation and user configuration details.
```

As a work around you can include the following sources.list:

```shell
deb [trusted=yes] http://archive.ubuntu.com....
deb-src [trusted=yes] http://archive.ubuntu.com....
```

## Query Information

To now use the chdist take a look at the list of available commands on the [man page](http://manpages.ubuntu.com/manpages/xenial/man1/chdist.1.html).

Here are a few examples:

If I want to see what source a package belongs to I can run use bin2src. Likewise, if I am interested in knowing the reverse, namely, all the binaries a source package produces I can use src2bin:

```shell
$ chdist bin2src artful vim
vim
$ chdist bin2src artful uidmap
shadow

$ chdist src2bin artful qemu
qemu
qemu-system
qemu-block-extra
qemu-system-common
qemu-system-misc
qemu-system-arm
qemu-system-mips
qemu-system-ppc
qemu-system-sparc
qemu-system-x86
qemu-user
qemu-user-static
qemu-user-binfmt
qemu-utils
qemu-guest-agent
qemu-kvm
qemu-system-aarch64
qemu-system-s390x
```

Similarly, the apt-cache, apt-file, and apt-rdepends all work as expected as well:

```shell
$ chdist apt-cache artful search chdist
devscripts - scripts to make the life of a Debian Package maintainer easier

$ chdist apt-cache artful showsrc devscripts
Package: devscripts
Format: 3.0 (native)
Binary: devscripts
Architecture: any
Version: 2.17.9build1
Priority: optional
Section: devel
<snip>

$ chdist apt-rdepends artful libc6
Reading package lists... Done
Building dependency tree... Done
libc6
  Depends: libgcc1
libgcc1
  Depends: gcc-7-base (= 7.2.0-8ubuntu2)
  Depends: libc6 (>= 2.14)
gcc-7-base
```

## Compare Distributions

Another useful feature of using chdist is the ability to compare between releases. Here are snips of output from each command:

```shell
$ chdist compare-packages zesty artful
vlc 2.2.4-14ubuntu2 2.2.6-6
vlc-plugin-vlsub 0.9.13-1 0.10.2-2

$ chdist compare-bin-packages zesty artful
vim 2:8.0.0095-1ubuntu3 2:8.0.0197-4ubuntu5
vim-addon-manager 0.5.6 0.5.6
vim-addon-mw-utils 0.1-5 0.1-5
vim-airline UNAVAIL 0.8-1
vim-airline-themes UNAVAIL 0+git.20170710.5d75d76-1
vim-asciidoc 8.6.9-5 8.6.9-5

$ chdist compare-versions zesty artful
zynjacku 6-4build1 UNAVAIL  not_in_artful
zypper 1.12.4-1build1 1.12.4-1build1  same_version
zziplib 0.13.62-3 0.13.62-3.1  newer_in_artful  local_changes_in_artful
zzuf 0.15-1 0.15-1  same_version
zzz-to-char 0.1.1-1 0.1.2-1  newer_in_artful
```

# Next Steps

chdist is an amazingly simple tool that to quickly get packages, binary or source, information in Debian and Ubuntu. In the little bit of time I spent searching for more information of chdist I found very little, which was disappointing. I hope this post is able to get other using the tool and shed a little light on its usefulness.
