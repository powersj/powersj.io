---
title: "Ubuntu Server: Team Sprint in Denver"
date: 2017-06-16
tags: ["ubuntu", "server", "sprint"]
drafts: false
---

# Overview

As stated in the June 9th [Ubuntu Server Development Summary](https://insights.ubuntu.com/2017/06/09/ubuntu-server-development-summary/), the Canonical Server team conducted a sprint in Denver, Colorado. The team met to complete a retrospective on the 17.04, make further progress on 17.10, and brainstorm for the 18.04 LTS.

The server team, like the rest of Canonical, all work remotely. None of us live in the same city or state and currently span six countries and three continents. As a result, meeting face-to-face every once and a while to make connections and work side-by-side are incredibly important. While we work hard throughout the day, come dinner time we get to go enjoy local food and beer, especially in Denver, and even get some friendly competition in through board games.

![Colorado Capital](/img/sprint/2017-denver/capital.jpg)

# Accomplishments

Looking back the team felt a sense of accomplishment on the progress and achievements in the following areas:

## git-ubuntu

[git-ubuntu](https://naccblog.wordpress.com/2017/03/24/usd-1-ubuntu-server-dev-git-importer/), formerly known as [USD](https://naccblog.wordpress.com/2017/05/19/usd-has-been-renamed-to-git-ubuntu/), allows the team to import git revisions from Debian packages, more easily complete merges, manage deltas between Debian and Ubuntu, and utilize it to submit merge requests to resolve bugs. This speeds up development greatly, aids in doing reviews of code changes, and simplifies the overall process.

Compared to a year ago, the team has had great success in getting packages merged from Debian and updated before the Zesty release. In large part, this is thanks to the team’s work on automating the process by using git-ubuntu. This has kept the report at the [Ubuntu Merge-o-Matic](https://merges.ubuntu.com/main.html) main report less red than in previous releases.

## Bug Triage

The team feels strongly that if someone takes the time to file a bug, they should get a response as having bugs, especially those with patches and fixes, sit is unacceptable. As a result, the team has implemented a daily rotation for triage of bugs against the server team’s packages. This way any new bugs should get a response within 24 hours. A [triage script](https://github.com/powersj/ubuntu-server-triage) was produced to get this list and we track how many bugs we have reviewed as well as how many are accepted into the backlog.

Of course identifying the work is only the first step, getting those bugs fixed and closed out is next. The team implemented [bug squashing days](https://lists.ubuntu.com/archives/ubuntu-server/2017-March/007502.html). These days gave new contributors an opportunity to work with uploads and members of the Ubuntu Server team to learn how to fix issues and get uploads completed.

## cloud-init and curtin

The cloud-init team released [version 0.7.9](https://lists.launchpad.net/cloud-init/msg00057.html), announced the new [cloud-id](https://lists.launchpad.net/cloud-init/msg00078.html) feature and functionality to improve performance when searching for data sources, in addition to the [cloudinit-analyze](https://lists.launchpad.net/cloud-init/msg00044.html) tool to look at boot time performance, and finally has made improvements to [merge request](https://lists.launchpad.net/cloud-init/msg00079.html) and [integration](https://lists.launchpad.net/cloud-init/msg00058.html) testing.

The curtin project received an [SRU exception](https://wiki.ubuntu.com/CurtinUpdates) due to its extensive configuration testing where hundreds of installs occur across all the supported releases.

![Working at hotel](/img/sprint/2017-denver/work.jpg)

# The Future

The team sat and talked through ideas for future plans. These discussions ranged from how we work as a team and what we expect of each other to features our customers want and what we should deliver. Some of the high-level items include:

* Better cross-distro support of cloud-init (e.g. [COPR](https://copr.fedorainfracloud.org/coprs/g/cloud-init/cloud-init-dev/) and [OBS](https://build.opensuse.org/package/show/Cloud:Tools:Next/cloud-init))
* Integration testing of cloud-init with KVM on actual cloud providers
* Nightly proposed testing of server team packages
* Full review of [backlog](https://bugs.launchpad.net/~ubuntu-server/+subscribedbugs) to better focus efforts and drop fixed or unnecessary items
* Increased communication to the community via weekly [development summaries](https://insights.ubuntu.com/tag/ubuntu-server).

# Call to Action

The team is always looking for productive feedback, contributions, and assistance from the community. We have a few active members who work with us but can always use more.

If you find yourself saying:

* "I want my server to do X"
* "Why can't I do Y with Ubuntu Server"
* "I wish this package was in Ubuntu Server"
* "Why does this package not work"
* "Ubuntu should do this"

Then please make an effort to let us know and get us the feedback. Knowing how our users, large and small, are using Ubuntu server is essential to continuing to deliver the best Linux server distribution.

You can get ahold of the team using IRC at #ubuntu-server on Freenode or by subscribing to the [Ubuntu Server mailing list](https://lists.ubuntu.com/mailman/listinfo/ubuntu-server).

![Team dinner](/img/sprint/2017-denver/team.jpg)
