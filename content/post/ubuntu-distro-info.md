---
title: "distro-info: Debian and Ubuntu Release Info"
date: "2017-10-26"
tags: ["ubuntu", "python"]
draft: false
---

The command `distro-info` provides information about Debian and Ubuntu releases. It can tell you what the current stable, supported, or under development releases are for both Debian and Ubuntu. The command itself is actually a symlink to either `debian-distro-info` or `ubuntu-distro-info` of course depending on what distribution you are running.

Very commonly the distro-info package will be used in place of hard coding specific releases in automated scripts. I personally use it in order to avoid needing to update what the latest development release name is or to determine what the latest LTS is.

The data used by the command comes from the distro-info-data package. It maintains a CSV file for each Debian and Ubuntu with releases, codenames, and dates. Here is a snip of the Ubuntu file with the latest releases:

```csv
version,codename,series,created,release,eol,eol-server
...
14.04 LTS,Trusty Tahr,trusty,2013-10-17,2014-04-17,2019-04-17
14.10,Utopic Unicorn,utopic,2014-04-17,2014-10-23,2015-07-23
15.04,Vivid Vervet,vivid,2014-10-23,2015-04-23,2016-01-23
15.10,Wily Werewolf,wily,2015-04-23,2015-10-22,2016-07-22
16.04 LTS,Xenial Xerus,xenial,2015-10-22,2016-04-21,2021-04-21
16.10,Yakkety Yak,yakkety,2016-04-21,2016-10-13,2017-07-20
17.04,Zesty Zapus,zesty,2016-10-13,2017-04-13,2018-01-25
17.10,Artful Aardvark,artful,2017-04-13,2017-10-19,2018-07-19
```

## No Development Release

Last week after the release of Artful Aardvark numerous tests, scripts, and metrics I run started failing. The reason was there was no development release anymore: Artful had become the latest stable release and until the next release is named and set up in the archive there will continue to be no development release.

This is what the error message showed in bash and python:

```shell
$ distro-info --devel
ubuntu-distro-info: Distribution data outdated.
Please check for an update for distro-info-data. See /usr/share/doc/distro-info-data/README.Debian for details.
$ python3
Python 3.6.3 (default, Oct  3 2017, 21:45:48)
[GCC 7.2.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> from distro_info import UbuntuDistroInfo
>>> UbuntuDistroInfo().devel()
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "/usr/lib/python3/dist-packages/distro_info.py", line 126, in devel
    raise DistroDataOutdated()
distro_info.DistroDataOutdated: Distribution data outdated. Please check for an update for distro-info-data. See /usr/share/doc/distro-info-data/README.Debian for details.
```

I am not the only person to run across this brief moment where there is no defined devel release as seen in [LP: #1309591](https://bugs.launchpad.net/ubuntu/+source/distro-info/+bug/1309591). As suggested in that bug, the correct form was not to run with the --devel flag, but instead, run with the --latest flag. Doing so will print the latest development version or in case of outdated distribution data, print the latest stable version.

Unfortunately, the python library does not seem to have the latest method defined and therefore to find the latest release I simply caught the DistroDataOutdated and called stable:

```python
try:
    latest = distro_info.UbuntuDistroInfo().devel()
except distro_info.DistroDataOutdated:
    latest = distro_info.UbuntuDistroInfo().stable()
```
