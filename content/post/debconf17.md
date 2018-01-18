---
title: "Attending DebConf17 in Montreal, Canada"
date: 2017-08-14
tags: ["debian", "debconf17"]
drafts: false
---

![Banner](/img/sprint/2017-debconf/banner.jpg)

# DebConf 2017

Last week I had the pleasure of not only attending, but also presenting at
DebConf 2017 in Montreal, Canada.

All talks and recordings can be found on the [DebConf17 Schedule](https://debconf17.debconf.org/schedule/)

![Olympic Stadium](/img/sprint/2017-debconf/olympic-stadium.jpg)

# Sessions

Below is a list of a few interesting sessions that I attended. I will work on a
separate post on the content of the presentation.

Titles are links to the videos of each presentation

## [Heresies in Free Software - what do the next 20 years look like?](https://debconf17.debconf.org/talks/177/)

Matthew Garrett gave a provocative challenge to the Debian community by
comparing Debian's role and success 20 years ago, where it is now, and where it
will be in 20 years.

Stated that while free software has had victories in that its use no longer
requires justification, that does not mean it has won the war. Giving examples
of areas where free software does not compete or lacks success (e.g. copyright,
easy-to-use security, etc.)

He finishes with how Debian is in a powerful position in the technology world
as a leader and decision maker, the gold standard for free operating systems,
however, it is not taking advantage of this power and could lose that power and
influence.

## [An introduction to LXD system containers](https://debconf17.debconf.org/talks/53/)

Stephan gave a great demonstration of the latest features of LXD while running
LXD as a snap on Debian. The demo included looking at GPU and USB passthrough.
It was a nice reminder of all the latest features and options available to an
end user of LXD.

## [OpenQA - the integration testing framework for fully tested daily releases](https://debconf17.debconf.org/talks/69/)

An employee of SuSE came and demonstrated the OpenQA platform: this included UI
testing of the Debian Stretch ISO and showed features including the triage of
failures. The platform primarily uses qemu and vnc together with os-autoinst to
run tests.

## [Rebuilding package build dependencies](https://debconf17.debconf.org/talks/18/)

The presenter here demonstrated using vmdebootstrap, kvm, and ansible to test
build, install, and removal of reverse dependencies. Interesting approach to
quickly test simple breakage and act as a smoke test. In addition to preventing
breakage, it also speeds up testing of packages with many, many dependencies.

## [FAI Demo Session](https://debconf17.debconf.org/talks/85/)

The FAI, the Fully Automated Installer, maintainer demonstrated building a
custom Debian image with various settings and completed an install very
quickly. Also mentioned how SSH is running on the installer to help in debug
and that it is currently used to build the Debian cloud images.

## [Techniques for using git for Debian packaging](https://debconf17.debconf.org/talks/36/)

A BOF on using git for Debian packaging. Summarized how each team or
developer seems to be a special snowflake in how he or she utilizes git given
the variety of tools and workflows that exist.

## [An apt talk](https://debconf17.debconf.org/talks/58/)

The yearly DebConf apt talk. Talked briefly about a Mac and Open BSD
port. Then focused on the work required and iterations to roll out unattended
upgrades: from using a cron to a systemd timer, to still needing the cron on
non-systemd systems. Also mentioned how apt-key is now deprecated and instead
use gpg.

## [Using Qubes OS from the POV of a Debian developer](https://debconf17.debconf.org/talks/16/)

Debian developer demonstrated how Qubes OS, based on Fedora and Xen, provides
isolation and fine grain security controls. Showed numerous desktops and
releases in use and made a point about high memory requirements. Interesting in
terms of privacy, however, the levels of abstraction made it seem overly
complex.

## [Passing the Torch: The Future of Free Software](https://debconf17.debconf.org/talks/183/)

A talk about passing on knowledge to new developers and what true mentoring
should look like. Suggested passing of knowledge looks like documenting not
only how to use tools, but going further in depth and transparency by
explaining processes and what led to those decisions. Defined mentoring as not
doing your dirty work, but instead getting the mentoree to the same place as
the mentor even if they do not come from the same background you did.

![Tech Committee](/img/sprint/2017-debconf/techcommittee.jpg)
