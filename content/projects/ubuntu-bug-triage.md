---
title: Ubuntu Bug Triage
description: Get involved and help fix Ubuntu bugs
weight: 4
date: 2018-10-26
image: img/projects/bug.png
---

Obtain a list of bugs for an Ubuntu team or package that were created or updated yesterday.

Users can further define the number of days to triage to increase the number of bugs found, the output type to allow machine readable output, or set the behavior to open the bugs in a browser and immediately begin bug triage.

![demo](/img/projects/ubuntu-bug-triage/cli.gif#center)

## How to Install

As this is a snap it is installed easily via the [snap store](https://snapcraft.io/ubuntu-bug-triage):

```bash
snap install ubuntu-bug-triage
```

## Usage

Below is usage for the app:

```bash
ubuntu-bug-triage [team|package]
```

For example, to find bugs updated in the last 30 days for the libvirt package a user would run:

```bash
ubuntu-bug-triage libvirt 30
```

![example](/img/projects/ubuntu-bug-triage/example.png#center)

## Bugs, Feature Requests, Questions

If you encounter an issue, have a feature request or idea for something new, or have questions about the tool feel free to [file a GitHub issue](https://github.com/powersj/ubuntu-bug-triage/issues/new)!

## References

* [Snap Store Page](https://snapcraft.io/ubuntu-bug-triage)
* [Source Code](https://github.com/powersj/ubuntu-bug-triage)
* [Bug Reporting](https://github.com/powersj/ubuntu-bug-triage/issues/new)
