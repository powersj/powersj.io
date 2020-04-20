---
title: "Ubuntu Server: Ubuntu Rally in NYC"
date: 2017-10-02
tags: ["ubuntu"]
draft: false
---

The [Ubuntu Rally](https://insights.ubuntu.com/2017/09/01/ubuntu-rally-in-nyc/) occurred last week in New York City where the entirety of the Canonical Engineering teams as well as various members of the community spent time working through final plans for Artful and continued discussions for next year's LTS release.

Below are notes on a few items last week's event:

![server team](/img/sprint/2017-nyc/team.jpg#center)

## Artful Final Beta

We saw the release of the [final beta of Artful](https://lists.ubuntu.com/archives/ubuntu-announce/2017-September/000225.html)! If you are able, please give the Artful [server images](http://releases.ubuntu.com/17.10/) a test as we approach the release. Give your favorite software stack a test, install to baremetal or in a VM, or if you have not already try out the latest version of LXD. Any and all bugs and input are appreciated as they help us make another quality release.

## Merges

There were, of course, numerous topics related to packaging merges. Here are a few of the topic areas:

### Server Team Merge Success

The server team has spent considerable effort over the past few release cycles getting the package delta under control and is able to stay very current with packages in Debian. The status of which is tracked using the [merge-o-matic report](https://merges.ubuntu.com/main.html).

The primary reasons for this success are two-fold: 1) expecting the last person to touch a source package to do the next upload does not work and is not a policy we use as a team 2) the [git workflow](https://wiki.ubuntu.com/UbuntuDevelopment/Merging/GitWorkflow) the server team uses via the [git ubuntu](http://www.justgohome.co.uk/blog/2017/07/developing-ubuntu-using-git.html) tool

[git ubuntu](http://www.justgohome.co.uk/blog/2017/07/developing-ubuntu-using-git.html) enables merge reviews allowing another developer on the server team to check and validate the upcoming changes. As a result of having this peer review done and the need to justify changes with that peer confirmed deltas with Debian are minimized and the number of uploads are kept to a minimum.

### Merge-o-Matic Status

As a part of the above discussion, there was also a side topic about updating the [merge-o-matic report](https://merges.ubuntu.com/main.html) to allow for better filtering and reporting. This would allow teams to get a more clear idea of the status of packages.

### git ubuntu

There was a discussed turning on automatic imports using the [git ubuntu](http://www.justgohome.co.uk/blog/2017/07/developing-ubuntu-using-git.html) with the Launchpad team. This requires some development so Robbie Basak is learning how to set up a development environment to make these additional changes. This will enable the usage of [git ubuntu](http://www.justgohome.co.uk/blog/2017/07/developing-ubuntu-using-git.html) to even more packages.

### Change Log Templates

While the change log follows a specific format, the text for each change log item is free form. The server team is working on developing a set of best practices and formats it expects to use for various scenarios and will enforce these during the git workflow process.

## cloud-init

The cloud-init team sat down to go over the state of testing in the project and plan out the next focus areas for QA. Here is a brief list of areas the integration tests are set to receive over the coming months:

* AWS Backend Support
* Azure Backend Support
* GCE Backend Support
* Consolidate test cases into one directory
* Rename `cloud-config` key to `user-data` and allow for any valid user-data
* Enable `vendor-data` key to allow passing in of vendor-data in backends like LXD
* Enable `disks` key to specify additional storage disks for a particular test
* Enable `platforms` key to specify backends test case supports
* Refactor the data collection YAML as well to grab files, folders

The team also spent time going through new features and bugs around netplan, revamping cloud-config snap support, and timesyncd.

## Server Team QA

As the QA developer for the Server team I took advantage of having all the engineering teams on hand and met to work through methods of improving testing:

### Unexpected FTBFS

A current pain point is when doing a stable release update (SRU) and discovering that suddenly the source fails to build (FTBFS). In order to prevent these surprises, I would like to rebuild the server team's owned packages, if not all of main, on supported releases periodically to report FTBFS issues.

The foundations team, not only agreed with the importance of doing this, but further encouraged this testing. They walked me through the process of doing a rebuild of the archive on Launchpad as well as the special requirements and pain points.

By discovering and resolving these types of failures the archive is kept in a healthier state allowing others to build the source when necessary problem-free and gives yet another opportunity to contribute to Ubuntu.

### Testing on Clouds

I recently added [KVM backed testing](https://lists.launchpad.net/cloud-init/msg00101.html) to the cloud-init integration tests. My next step is to begin added support for the cloud providers. I talked to both the Foundations and Kernel teams to see how they currently deploy to their tests to [AWS](https://aws.amazon.com/), [Azure](https://azure.microsoft.com/en-us/), and [GCE](https://cloud.google.com/compute/) and was given access to their code repositories to begin working through the details.

### Solution Testing

The Solutions QA team and I discussed how to test proposed versions of cloud-init and curtin. The solutions QA team has a massive integration test effort across many products, including Ubuntu Server, Juju, MAAS, LXD, and more. This effort will lead to even great coverage in testing proposed versions of cloud-init and curtin.

### Proposed MAAS Testing

A quick sync with the MAAS team occurred to verify we can get the logs required for our [curtin SRU execption](https://wiki.ubuntu.com/CurtinUpdates) and planned [cloud-init SRU exception](https://wiki.ubuntu.com/CloudinitUpdates). This testing occurs when cloud-init and curtin our in the proposed bucket. We are working to get a substantial increase in test coverage during this time.

### Desktop Team

For the first time ever I was able to discussion QA with the Desktop Team face-to-face. It was great to learn what areas and issues the team is working through and provided a good opportunity for us to work through common areas of testing, tools, and metrics.

We also decided to work to get our daily LTS and development release ISO results publicly available. These tests gate the release of new daily ISOs, run a smoke install, and then execute dozens of various pressed installs.

### Certification Team

Also for the first time, I met with the hardware enablement (HWE) and certification (cert) teams. I now have a better understanding of the testing that occurs on hardware before a release and how hardware vendors obtain certification. The team's testing provides great coverage of the kernel and drivers.

## Server IRC Meeting

The server team is considering revamping the current [server team IRC meeting](https://wiki.ubuntu.com/ServerTeam/Meeting). The current format does not appear to engage the community effectively and we would like that to change.

The current proposal involves changing the format away from a meeting format to more of an office hours time. During which members of the server team will be around to answer questions, give any updates that need to be highlighted, and discuss any major issues with the community as a whole.

We also would like to use this time as an opportunity to tackle bugs, as we have done with our [bug triage days](https://lists.ubuntu.com/archives/ubuntu-server/2017-March/007502.html) in the past. These days have been hugely helpful and well received by many and is something the server team would like to continue to do.

## s390x Training

Finally, the server team spent time getting training on managing an [s390x](https://wiki.ubuntu.com/S390X), getting access and using the system console, how to boot and add hardware, as well as learning how to debug common issues. It was great knowledge to have given Ubuntu server's continued support of s390x.

![empire-state-building](/img/sprint/2017-nyc/empire-state-building.jpg#center)
