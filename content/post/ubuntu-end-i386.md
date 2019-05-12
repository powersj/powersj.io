---
title: "End 32-bit x86 Support in Ubuntu"
date: 2018-05-18
tags: ["ubuntu", "32-bit", "bionic", "cosmic"]
draft: false
---

# End 32-bit x86 Support in Ubuntu

With the recent release of the latest LTS of Ubuntu Bionic Beaver now is the perfect time to end support for the i386 architecture. The amount of time, effort, and resources to maintain an architecture that is not under active development, heavily utilized, or in demand should end.

Recently there was a post to ubuntu-devel-discuss proposing to [end i386 support](https://lists.ubuntu.com/archives/ubuntu-devel-discuss/2018-May/018004.html) and I have not seen a final conclusion. However, I wanted to document my own opinion based on seeing this discussion get brought up numerous times in the past.

## Brief History

The first Intel x86 32-bit processor, the [Intel 80386](https://en.wikipedia.org/wiki/Intel_80386), where 386 in i386 comes from, was released in the mid-1980s. For nearly 20 years, there were additional revisions and advancements to the 32-bit x86 architecture.

However, at the turn of the century, many 32-bit x86 systems were pushing the [3Gb memory barrier](https://en.wikipedia.org/wiki/3_GB_barrier). To solve this, Intel produced [Itanium](https://en.wikipedia.org/wiki/Itanium) in 2001 a brand new 64-bit architecture. Two years later AMD responded with [Opteron](https://en.wikipedia.org/wiki/Opteron), whose instruction set was called amd64, had backwards compatibility with 32-bit software, and as a result won over the market.

Nearly every new PC, laptop, and server has shipped with an x86 64-bit capable processor since then. New Intel 32-bit only x86 processors have released for specific use-cases such as embedded processors found on the Intel Atom and even many, but admittedly not all, of those have 64-bit support.

## Image Deprecation

During the last cycle, I proposed ending the [server i386 images](https://lists.ubuntu.com/archives/ubuntu-server/2017-October/007611.html). The general consensus was of course this should be done and surprise that it had not already occurred. After no objection server images were removed from Bionic and future releases.

Ubuntu has also discontinued the generation of 32-bit x86 cloud images for future releases after Bionic. The cloud is certainly not heavily run with 32-bit instances.

At this time, going forward the only way to install 32-bit x86 Ubuntu is via Lubuntu and Xubuntu after Bionic.

**Question:** Why would we continue to develop on an architecture that has greatly diminished user base?

## Security Support

Security deserves its own call out for two reasons:

First, the recent Spectre and Meltdown security vulnerabilities demonstrated how hardware can lead to massive security vulnerabilities. Legacy, 32-bit x86 systems will not be getting the same attention from chip makers as recently released, more heavily used processors.

Second, at the start of the Cosmic cycle, Mark called for [raising the bar on security](https://www.markshuttleworth.com/archives/1521). As Mark put it "we are stewards of a shared platform" due to the extensive use of Ubuntu across the computing spectrum. Passing onto someone else the security of an entire architecture that is not widely used or developed off is unacceptable. Even then it is difficult to find someone actively caring and feeding for 32-bit x86.

**Question:** How ethical is it to continue to try to maintain an architecture that receives little to no active development?

## There is no free lunch

Every architecture that is supported comes with costs in various forms. The number of 32-bit x86 issues, test failures, development work is not insignificant. Here are a few items that come with any architecture that is supported:

- Autopackage test and failure to build from source (FTBFS) failures require triage of architecture specific issues, builds, testing, and tooling
- Architecture specific machines need to be made available and maintained
- The archive admins have to take care of each architecture
- Each architecture has images, not only ISOs, that need to be tested both manually and automated and released for each flavor
- Security updates need to be packaged, tested, and shipped
- Defects and questions come in due to architecture specific issues

**Question:** Is the cost of supporting this architecture worth the time sacrificed working on new development?

## The Path Forward

For users wanting to continue using Ubuntu on 32-bit processors: they can. Ubuntu Xenial will be fully supported for another 3 years (2021) and then users can migrate or start using Ubuntu Bionic now and get support for 5 more years (2023).

Consider usage data from [Mozilla](https://hardware.metrics.mozilla.com/#goto-os-and-architecture), [Steam](https://store.steampowered.com/hwsurvey/), and [StatCounter](http://gs.statcounter.com/) and it is clear that 64-bit systems and mobile devices have overtaken the domination of 32-bit x86 systems of the 1990s.

Legacy software and processors should not be expected to be supported on every new development release of any software, including Ubuntu: end i386
