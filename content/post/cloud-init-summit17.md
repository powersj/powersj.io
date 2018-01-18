---
title: "cloud-init: Summit in Seattle, Washington"
date: 2017-08-31
tags: ["cloud-init", "summit"]
draft: false
---

![Banner](/img/sprint/2017-cloud-init/seattle.jpg#center)

# Introduction

Last week the cloud-init development team from Canonical ran a two-day summit in Seattle, Washington. The purpose of the summit was to meet with contributors to cloud-init from cloud providers and OS vendors to demo recent developments in cloud-init, resolve outstanding issues, and collect feedback on development and test processes as well as future features.

Attendees included developers from Amazon, Microsoft, Google, VMWare, and IBM cloud teams, as well as the maintainers of cloud-init from Red Hat, SUSE, and of course, Ubuntu. Special thanks go to Google for hosting us and to Microsoft for buying everyone dinner!

![Banner](/img/sprint/2017-cloud-init/meeting.jpg)

# Demos

The cloud-init development team came with a number of prepared demos and talks that they gave as a part of the summit:

* __cloud-init analyze__: Ryan demoed the recently added analyze feature to aid in doing boot time performance analysis. This tool parses the cloud-init log into formatted and sorted events to assist in determining long running steps during instance initialization.
* __cloud-config Schema Validation__: Chad demonstrated the early functionality to validate cloud-configs before launching instances. He demoed two modules that exist today, how to write the validation, and what positive and negative results look like.
* __Integration Testing and CI__: Josh demonstrated the integration test framework and shared plans on running tests on actual clouds. Then showed the merge request CI process and encouraged this as a way for other OSes to participate.
* __Using lxd for Rapid Development and Testing__: Scott demoed setting userdata when launching a lxd instance and how this can be used in the development process. He also discussed lxd image remotes and types of images.

# Breakout Sessions

In addition to the prepared demos, the summit had numerous sessions that were requested by the attendees as additional topics for discussion:

* Netplan (v2 YAML) as primary format
* How to query metadata
* Version numbering
* Device hotplug
* Python 3
* And more...

During the summit, we took time to have merge review and bug squashing time. During this time, attendees came with outstanding bugs to discuss possible fixes as well as go through outstanding merge requests and get live reviews.

![Banner](/img/sprint/2017-cloud-init/bridge.jpg)

# Conclusions

A big thanks to the community for attending! The summit was a great time to meet many long time users and contributors face-to-face as well as collect feedback for cloud-init development.

[Notes of both days](https://lists.launchpad.net/cloud-init/msg00094.html) can be found on the cloud-init mailing list. There you will find additional details about what I have described above and much more.

Finally, if you are interested in following or getting involved in cloud-init development check out #cloud-init on Freenode or subscribe to the [cloud-init mailing list](https://launchpad.net/~cloud-init).
