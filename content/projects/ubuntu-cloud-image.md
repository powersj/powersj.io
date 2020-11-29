---
title: Ubuntu Cloud Image
description: Find the latest Ubuntu Images for clouds
weight: 3
date: 2020-10-14
image: img/projects/cloud.png
---

Finding the latest Ubuntu image on your favorite cloud can be difficult. Each
cloud has a unique method for finding the latest images. The
[Ubuntu Cloud Image](https://snapcraft.io/ubuntu-cloud-image) CLI tool was
created to find the latest Ubuntu images on clouds. The following clouds are
supported:

- Amazon Web Services (aws)
- Amazon Web Services China (aws-cn)
- Amazon Web Services GovCloud (aws-govcloud)
- Microsoft Azure (azure)
- Google Compute Engine (gce)
- Kernel-based Virtual Machine (kvm)
- Linux Containers (lxc)
- Metal as a Service (MAAS) Version 2 (maasv2)
- Metal as a Service (MAAS) Version 3 (maas)

The program uses the streams output provided by various clouds to determine
the latest images available on clouds. Where they are supported this includes
the latest daily, minimal, and daily minimal images as well. Daily and minimal
images are enabled with the `--daily` and `--minimal` flags.

The output is the full JSON output from streams providing details about the
requested image. If no image matches the specific filter then an empty JSON
array is printed.

## How to Install

As this is a snap it is installed easily via the
[snap store](https://snapcraft.io/ubuntu-cloud-image):

```bash
snap install ubuntu-cloud-image
```

## Usage

Below is usage for the app:

```bash
ubuntu-cloud-image {cloud} {release} [--daily] [--minimal]
```

For example, to find the latest bionic KVM image run the following:

```bash
ubuntu-cloud-image kvm bionic
```

## Bugs, Feature Requests, Questions

If you encounter an issue, have a feature request or idea for something new,
or have questions about the tool feel free to
[file a GitHub issue](https://github.com/powersj/ubuntu-cloud-image/issues/new)!

## References

- [Snap Store Page](https://snapcraft.io/ubuntu-cloud-image)
- [Source Code](https://github.com/powersj/ubuntu-cloud-image)
- [Bug Reporting](https://github.com/powersj/ubuntu-cloud-image/issues/new)
