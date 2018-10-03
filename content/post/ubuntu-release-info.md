---
title: Ubuntu Release Info
date: 2018-11-01
tags: ["ubuntu", "snap", "release"]
draft: true
---

# Ubuntu Release Info

I recently needed a way to more easily gather a list of supported releases of Ubuntu and preferably installed via PyPI. There exists the distro-info package in Ubuntu that is updated after release. The probably is it needs ot be updated and when embedded inside a snap that means maintenance.

The solution was to develop a Python app that would query the data found in [metadata.ubuntu.com]() as that is kept up to date after each release. This does mean making two small file downloads.

## How to Install

As this is a snap it is installed easily via the snap store:

```bash
snap install ubuntu-release-download
```

You can also use it via PyPI:

```bash
pip3 install ubuntu-release-info
```

## Usage

Below is usage for the app:

```bash
ubuntu-release-info [lts,stable,devel,all,supported,unsupported]
```

The app takes a particular query and prints out the release codenames matching it. Below is a list of the possible queries:

* ***lts***: latest supported long-term supported (LTS) release codename
* ***stable***: current stable release codename
* ***devel***: current development release codename
* ***all***: every Ubuntu release codename
* ***supported***: all supported releases' codename
* ***unsupported***: all unsupported releases' codename

## Bugs, Feature Requests, Questions

If you encounter an issue, have a feature request or idea for something new, or have questions about the tool feel free to [file a GitHub issue]()!

If you find the tool useful feel free to [drop me a line as well]().
