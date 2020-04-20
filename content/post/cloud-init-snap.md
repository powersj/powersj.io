---
title: "cloud-init: Creating a Classic Snap"
date: 2017-04-21
tags: ["cloud-init"]
draft: false
---

[Snaps](https://www.ubuntu.com/desktop/snappy) are a fast, easy, and safe way of packaging software. While I had some experience earlier in 2016 trying to snap up Weka and a few other projects I wanted to see how snaps have changed since then. Given my work on [cloud-init](https://cloud-init.io/) and the fact that it does not yet have a snpacraft.yaml I wanted to attempt to snap it.

## Classic Confinement

The snap team [recently announced](https://insights.ubuntu.com/2017/01/09/how-to-snap-introducing-classic-confinement/) the availability of a security policy that allows for greater access of the entire host system called classic confinement. One of the key selling points of snaps is the ability to restrict what a snap has access to on a system. In fact by default, it has access to nothing. However, there are tools and scripts that need access to the greater system.

Cloud-init is a perfect example of a software package needing access to the greater system given the setup and configuration it accomplishes. As such I decided to give making cloud-init a classic confinement snap.

## Snapcraft

The final snapcraft.yaml was merged into the [repo](https://github.com/cloud-init/cloud-init/blob/master/snapcraft.yaml) in mid-April 2017 and is below. Read through it and then read below for a greater description of each part:

```yaml
name: cloud-init
version: master
summary: Init scripts for cloud instances
description: |
  Cloud instances need special scripts to run during initialization to
  retrieve and install ssh keys and to let the user run various scripts.
grade: stable
confinement: classic

apps:
  cloud-init:
    # LP: #1669306
    command: usr/bin/python3 $SNAP/bin/cloud-init

parts:
  cloud-init:
    plugin: python
    source-type: git
    source: https://git.launchpad.net/cloud-init
```

### Metadata

The first six keys I generally refer to as metadata. The name, summary, and description are self-explanatory.

The version is master for two reasons: 1) as the parts section specifies the snapcraft checks out from master and 2) prevents the need to update the version in yet another place.

The grade is stable over devel as it was, albeit briefly, tested and not really under any further development.

The confinement as I alluded to above, is classic to take advantage of the additional system access.

### Apps

I only expose a single app, namely cloud-init. Traditionally this should be as simple as specifying the command `bin/cloud-init`, however I quickly learned that it would not be so easy. Due to [LP: #1669306](https://bugs.launchpad.net/snapcraft/+bug/1669306) I was required to specify the python3 path. This is due to the classic confinement option being so new and still working out some of the experience.

### Parts

The parts section is very straight forward, but required a great deal of consideration and a small change to cloud-init.

Cloud-init as a python based project with a setup.py obviously will use the python plugin, but not without a small change. The python plugin expects that running `python setup.py install` does not expect any required parameters. In cloud-init, we used to expect the init system as an option like `python setup.py install --init-system=systemd`. In order to get past this, if no init system is specified systemd will be used by default.

There was a brief debate on how to setup the source: either clone master each time or use the local directory. Due to the fact that the snapcraft.yaml file is kept in the git repository it seems redundant to specify the source as a git repo leading to two git checkouts.

Ultimately I choose to specify the git repo in order to prevent any accidental or untested local changes from making their way into a snap and to by default snap what is committed into master. Of course this is not prevent someone from locally modifying the value to '.' or specifying a branch, but sets up what I believe to be sane and safe defaults.

## Build & Install

At this point all that is left is to build and install the snap. Build of a classic confinement snap required installing the core snap, which I did not already have and then running `snapcraft`.

Install of the actual snap required adding a new option to allow the classic confinement.

```shell
sudo snap install core
git clone git+ssh://git.launchpad.net/cloud-init
cd cloud-init
snapcraft
sudo snap install cloud-init_master_amd64.snap --classic --dangerous
```

## Running

A brief video showing the snap installed and running a few basic commands:

[![asciicast](https://asciinema.org/a/6fj3j5n369m4b4u9ywy1mxx92.png)](https://asciinema.org/a/6fj3j5n369m4b4u9ywy1mxx92)
