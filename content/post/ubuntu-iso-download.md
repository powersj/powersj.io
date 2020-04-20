---
title: Ubuntu ISO Download
date: 2018-09-28
tags: ["ubuntu"]
draft: false
---

# Ubuntu ISO Download

I recently published a CLI based snap, which allows user's to easily download the latest Ubuntu ISOs. Various flavors and types of ISOs are supported across the supported releases of Ubuntu. Downloaded ISO's SHA-256 hash sum is verified after downloading to ensure the authenticity of the download.

Read on to learn how to install and use Ubuntu ISO Download!

![demo](/img/projects/ubuntu-iso-download/cli.gif#center)

## How to Install

As this is a snap it is installed easily via the snap store:

```bash
snap install ubuntu-iso-download
```

## Usage

Below is usage for the app:

![help](/img/projects/ubuntu-iso-download/help.png#center)

### Flavors

The snap is capable of downloading the primary Ubuntu Desktop and Ubuntu Server as well as a selection of currently supported flavors. The list of supported flavors was based on the [officially recognized flavors](https://www.ubuntu.com/download/flavours) list. These include the following:

* Ubuntu Desktop
* Ubuntu Server
* Kubuntu
* Lubuntu
* Ubuntu Budgie
* Ubuntu Kylin
* Ubuntu MATE
* Ubuntu Studio
* Xubuntu

If your favorite flavor is missing or not available feel free to [file a bug](https://github.com/powersj/ubuntu-iso-download/issues/new) to request support and let me know there is interest in it.

### Release

The release is the codename (e.g. bionic, xenial, trusty) and must be a currently supported release and defaults to the latest LTS if one is not provided.

### Architecture

Only the amd64 architecture is supported for download at this time.

### Dry Run

In dry run mode, a link to the folder containing the ISO is printed rather than downloading the entire ISO.

### Debug

Debug mode will print additional output, including the full SHA-256 string.

![example](/img/projects/ubuntu-iso-download/example.png#center)

## Hash Verification

For verification, the SHA-256 hash file and signed GPG has file are both downloaded. The signed GPG file is used to verify that the hash file is valid and the expected hash saved.

Once the ISO is downloaded, the SHA-256 hash is calculated and compared to the expected value. If a has mismatch occurs the download ISO is deleted.

## Bugs, Feature Requests, Questions

If you encounter an issue, have a feature request or idea for something new, or have questions about the tool feel free to [file a GitHub issue](https://github.com/powersj/ubuntu-iso-download/issues/new)!

## References

* [Snap Store Page](https://snapcraft.io/ubuntu-iso-download)
* [Source Code](https://github.com/powersj/ubuntu-iso-download)
* [Bug Reporting](https://github.com/powersj/ubuntu-iso-download/issues/new)
