---
title: "Ubuntu Server: Team Sprint in Budapest"
date: 2018-03-16
tags: ["ubuntu"]
draft: false
---

At the beginning of March, the engineering teams of Canonical met in Budapest, Hungary to work out the final open items for Bionic and begin laying out what comes in the months after the release. As a member of the server team, the below summary describes some of the major areas that I took part in over the week:

![Team](/img/sprint/2018-budapest/team.jpg)

## Bug Triage

Members of the team heavily discussed how we should be doing triage on a weekly basis. [Bug triage](https://wiki.ubuntu.com/ServerTeam/KnowledgeBase#Bug_Triage) involves a different member of the team getting assigned a day of the week to go through all new and updated bugs for server team owned packages. Triage is defined as making sure the bug is valid and ready for action by another member of the team. Bugs that do not provide enough information, are not actually bugs, but local configuration issues, or are more support request than a bug are weeded out during the triage process.

The team as a whole wishes for all new bugs to get responded to within one business day to not only demonstrate the value of filing bugs and fostering the community, but to also shepard real bugs to get solved in a timely manner. As engineers who like to inherently like to solve problems and wish to help others who are seeking help it is hard sometimes to not spend a large amount of time responding to these individual requests.

However, we are a very small team and spending lots of extra time reduces the amount of time we can spend on many other development areas. That is why we often try to redirect bug reports that are not complete or are actually support requests to the [Ubuntu forums](https://ubuntuforums.org/). Not only is there a much large community to provide support and walk through issues there, but it is also the more correct forum for such requests.

The team spent time going through bugs as a team and watching how each other goes completes triage in order to make sure everyone had agreed upon the methodology of how and when to respond to the various types of bugs that are filed.

## SRU Team

A member of the Canonical support team, who was also one of the first of the SRU team members joined our team during sessions throughout the week. It was a wonderful addition having him there to provide insight from his perspective and to meet and hear from him in person. He also gave us insights into his day-to-day and customer interactions, which provided excellent background into how the support team is organized and functions with customers on a day-to-day basis.

## netplan.io

With [netplan.io](https://netplan.io/) the go-forward approach to generating network configurations files, the team met with the netplan.io developers over final open items for Bionic and what is to come. We discussed the current status and what remaining features and fixes need to get into it before the release. Also discussed how to best help users migrate to netplan.io and how to get examples up.

## Coding Days

During the week we had a couple opportunities to be heads down:

I first focused on getting testing going on package builds to prevent fail to build from source (FTBFS). As we discussed as a team during the last sprint in NYC, there are more and more reported cases of packages getting uploaded as a part of a support release update (SRU) that in turn break the build of that package or other packages.

With my task of ensuring the quality of the distribution, the first step is to develop a way to see the current state of the archive in terms of FTBFS. The package build jobs I am developing will build all the server-team owned packages at some cadence to find FTBFS, rather than waiting for another SRU or worse, a customer, to discovery them. The second step is to then, monitor the state of the rebuilds in a way we can focus energy finding the causes for the FTBFS and reduce the overall number.

I also spent some time on jenkins-launchpad-plugin and submitted a couple merge requests. The [first merge](https://code.launchpad.net/~powersj/jenkins-launchpad-plugin/autoland-git/+merge/340950) was to enable the ability to auto-land git based projects. This is functionality that is currently present for bzr based projects using tarmac. However, git based projects and more and more prevalent now with Launchpad and having a similar functionality will be very useful. The [second merge](https://code.launchpad.net/~powersj/jenkins-launchpad-plugin/skip-message-check/+merge/341020) was the ability to ignore a commit or description message when doing a review. This was at the request of the git-ubuntu developers who sometimes submit a merge purely to run it against the official project CI.

## Key Signing

Finally, on the last day the team did a key signing party. This is something that we have not done since I have joined Canonical. It also turns out that we did this party exactly three years after creating my initial gpg key, which was for a similar reason. The team had various levels of knowledge of keys and we even had some users create new keys for this event. It was always fun to see folks going through the key signing party for the first time.

![Danube River](/img/sprint/2018-budapest/danube.jpg)
