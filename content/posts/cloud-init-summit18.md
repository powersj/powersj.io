---
title: "cloud-init Summit 2018"
date: 2018-08-27
tags: ["cloud-init"]
draft: false
aliases:
  - /post/cloud-init-summit18/
---

![waterfront](/img/sprint/2018-cloud-init/waterfront.jpg)

Last week the cloud-init development team from Canonical ran our second annual two-day summit. Attendees included cloud developers from Amazon, Microsoft, Google, VMWare, and Oracle, as well as the maintainer of cloud-init from Amazon Linux, SUSE, and Ubuntu.

The purpose of this two-day event is to meet with contributors, demo recent developments, present future plans, resolve outstanding issues, and collect additional feedback on the past year.

Like last year, the even was held in Seattle, Washington. A special thanks goes to Microsoft for providing breakfast and lunch while hosting us and to the Amazon Linux and AWS teams for buying everyone dinner!

![roadmap talk](/img/sprint/2018-cloud-init/roadmap.jpg)

## Talks, Demos, and Discussions

The cloud-init development team came with a number of prepared demos and talks that they gave as a part of the summit:

* __Recent Features and Retrospective__: Ryan started the summit off with an overview of features landed in the past year as we all metrics since the start of faster releases with date-based versioning.
* __Community Checkpoint & Feedback__: Scott hosted a session where he explored the various avenues contributors have and received input and ideas for even better collaboration.
* __Roadmap__: Ryan presented the roadmap for upcoming releases and requested feedback from those in attendance.
* __Ending Python 2.6 Support__: Scott announced the end of Python 2.6 support and there was a discussion on ending Python 2.7 support as well. An announcement to the mailing list is coming soon.
* __Instance-data.json support and cloud-init cli__: Chad demoed a standard way of querying instance data keys to enable scripting, templating, and access across all clouds.
* __Multipass__: Alberto from the Canonical Multipass team joined us to demo the [Multipass](https://github.com/CanonicalLtd/multipass) project. Multipass is the fastest way to get a virtual machine launched with the latest Ubuntu images.
* __Integration Testing and CI__: Josh gave an update on the new CI processes, auto-landing merge requests, and demoed the integration tests. He went through what it takes to add additional clouds and his wish-list for additional testing.
* __Pre-Network Detection for Clouds__: Chad ran a discussion on collecting pre-networking detection for clouds in order to speed up instance initialization and decrease boot time.

## Breakout Sessions

In addition to the prepared demos and discussions, the summit had numerous sessions that were requested by the attendees as additional topics for discussion.

SUSE led at discussion around the sysconfig renderer and network rework, while the Amazon Linux team discussed some of their patches. Both distros are working to minimize the number of patches required.

During the summit, we took time to have merge review and bug squashing time. During this time, attendees came with outstanding bugs to discuss possible fixes as well as go through outstanding merge requests and get live reviews.

![another talk](/img/sprint/2018-cloud-init/talk.jpg)

## Conclusions

As always a huge thank you to the community for attending! The summit was a great time to see many contributors face-to-face as well as collect feedback for cloud-init development.

[Notes of both days](https://lists.launchpad.net/cloud-init/msg00169.html) can be found on the cloud-init mailing list. There you will find additional details about what I have described above and much more.

Finally, if you are interested in following or getting involved in cloud-init development check out #cloud-init on Freenode or subscribe to the [cloud-init mailing list](https://launchpad.net/~cloud-init).
