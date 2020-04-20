---
title: "Ubuntu Server: How to find Bugs to Fix"
date: 2017-10-12
tags: ["ubuntu"]
draft: false
---

![server](/img/ubuntu/server.png#center)

Ever wanted to help out in the development of Ubuntu Server, but did not know how? One of the best ways to get started is by working on bugs. Not only does it improve the distribution for millions of users, but also gives you an opportunity to see how the distribution is made.

I am publishing this after a year of learning various commands, tools, and processes that revolve around fixing bugs. I hope that it is helpful to others who are interested in getting involved with fixing bugs in Ubuntu Server.

The Ubuntu Server team has many hundred source packages that it is responsible for. Resolving bugs in these packages is essential to the overall quality and experience of the release. For newcomers, tackling bugs is also a great way to get involved in the development of Ubuntu and to learn more about open source development.

Here is a summary of the steps I will go over:

  1. Create an account on [Launchpad](https://launchpad.net/)
  1. View the complete [Ubuntu Server backlog](https://bugs.launchpad.net/~ubuntu-server/+subscribedbugs), the [bitesize](https://bugs.launchpad.net/~ubuntu-server/+subscribedbugs?field.searchtext=&field.status:list=NEW&field.status:list=CONFIRMED&field.status:list=TRIAGED&field.status:list=INPROGRESS&field.status:list=FIXCOMMITTED&field.status:list=INCOMPLETE_WITH_RESPONSE&field.status:list=INCOMPLETE_WITHOUT_RESPONSE&assignee_option=any&field.assignee=&field.bug_reporter=&field.bug_commenter=&field.subscriber=&field.structural_subscriber=&field.tag=bitesize&field.tags_combinator=ANY&field.status_upstream-empty-marker=1&field.has_cve.used=&field.omit_dupes.used=&field.omit_dupes=on&field.affects_me.used=&field.has_patch.used=&field.has_branches.used=&field.has_branches=on&field.has_no_branches.used=&field.has_no_branches=on&field.has_blueprints.used=&field.has_blueprints=on&field.has_no_blueprints.used=&field.has_no_blueprints=on&search=Search&orderby=-date_last_updated&start=0) tagged bugs, or [server-next](https://bugs.launchpad.net/ubuntu/?field.searchtext=&orderby=-importance&field.status:list=NEW&field.status:list=CONFIRMED&field.status:list=TRIAGED&field.status:list=INPROGRESS&field.status:list=FIXCOMMITTED&field.status:list=INCOMPLETE_WITH_RESPONSE&field.status:list=INCOMPLETE_WITHOUT_RESPONSE&assignee_option=any&field.assignee=&field.bug_reporter=&field.bug_commenter=&field.subscriber=&field.structural_subscriber=&field.component-empty-marker=1&field.tag=server-next&field.tags_combinator=ANY&field.status_upstream-empty-marker=1&field.has_cve.used=&field.omit_dupes.used=&field.omit_dupes=on&field.affects_me.used=&field.has_no_package.used=&field.has_patch.used=&field.has_branches.used=&field.has_branches=on&field.has_no_branches.used=&field.has_no_branches=on&field.has_blueprints.used=&field.has_blueprints=on&field.has_no_blueprints.used=&field.has_no_blueprints=on&search=Search) tagged bugs.
  1. Find an appropriately sized bug that aligns with your interest and ability
  1. Assign yourself to the bug and mark the bug "In Progress"
  1. Subscribe to all updates on the bug
  1. Leave a comment with your intention to work on the bug

## 1. Create an account on Launchpad

![server](/img/launchpad/logo.png#center)

If you are interested in either reporting bugs or fixing bugs in Ubuntu you need to have an account on Launchpad. [Launchpad](https://launchpad.net/) is where the development of Ubuntu is tracked. Bugs, source, planning, packages, and much more are all tracked in Launchpad. To get going with Launchpad I recommend reading through the [Get set up to work with Launchpad](http://packaging.ubuntu.com/html/getting-set-up.html#get-set-up-to-work-with-launchpad) section of the Packaging Guide.

## 2. View the Backlog

The server team maintains a list of bugs in a [backlog](https://bugs.launchpad.net/~ubuntu-server/+subscribedbugs) that needs to be fixed. This a curated list of bugs that have already undergone triage and have been deemed actionable. That is, a member of the server team, has reviewed the bug to validate that there is some action required and sufficient information exists to preseed on resolving the defect.

There are also two subsets of the backlog as described below:

### server-next

The first subset of the backlog are bugs with the tag [server-next](https://bugs.launchpad.net/ubuntu/?field.searchtext=&orderby=-importance&field.status:list=NEW&field.status:list=CONFIRMED&field.status:list=TRIAGED&field.status:list=INPROGRESS&field.status:list=FIXCOMMITTED&field.status:list=INCOMPLETE_WITH_RESPONSE&field.status:list=INCOMPLETE_WITHOUT_RESPONSE&assignee_option=any&field.assignee=&field.bug_reporter=&field.bug_commenter=&field.subscriber=&field.structural_subscriber=&field.component-empty-marker=1&field.tag=server-next&field.tags_combinator=ANY&field.status_upstream-empty-marker=1&field.has_cve.used=&field.omit_dupes.used=&field.omit_dupes=on&field.affects_me.used=&field.has_no_package.used=&field.has_patch.used=&field.has_branches.used=&field.has_branches=on&field.has_no_branches.used=&field.has_no_branches=on&field.has_blueprints.used=&field.has_blueprints=on&field.has_no_blueprints.used=&field.has_no_blueprints=on&search=search). These are high priority bugs that should be tackled next and as a result is a great place to look for bugs.

### bitesize

The second subset of bugs with the tag [bitesize](https://bugs.launchpad.net/~ubuntu-server/+subscribedbugs?field.searchtext=&field.status:list=NEW&field.status:list=CONFIRMED&field.status:list=TRIAGED&field.status:list=INPROGRESS&field.status:list=FIXCOMMITTED&field.status:list=INCOMPLETE_WITH_RESPONSE&field.status:list=INCOMPLETE_WITHOUT_RESPONSE&assignee_option=any&field.assignee=&field.bug_reporter=&field.bug_commenter=&field.subscriber=&field.structural_subscriber=&field.tag=bitesize&field.tags_combinator=ANY&field.status_upstream-empty-marker=1&field.has_cve.used=&field.omit_dupes.used=&field.omit_dupes=on&field.affects_me.used=&field.has_patch.used=&field.has_branches.used=&field.has_branches=on&field.has_no_branches.used=&field.has_no_branches=on&field.has_blueprints.used=&field.has_blueprints=on&field.has_no_blueprints.used=&field.has_no_blueprints=on&search=Search&orderby=-date_last_updated&start=0"). As the name implies, these bugs are small in size and potentially great for beginners.

## 3. Selecting A Bug

Now that you have a list of bugs it is time to choose one. Choosing something to work on can be both intimidating and daunting given the amount of information each bug may or may not contain. If you are new, the best suggestion is to start with a [bitesize](https://bugs.launchpad.net/~ubuntu-server/+subscribedbugs?field.searchtext=&field.status:list=NEW&field.status:list=CONFIRMED&field.status:list=TRIAGED&field.status:list=INPROGRESS&field.status:list=FIXCOMMITTED&field.status:list=INCOMPLETE_WITH_RESPONSE&field.status:list=INCOMPLETE_WITHOUT_RESPONSE&assignee_option=any&field.assignee=&field.bug_reporter=&field.bug_commenter=&field.subscriber=&field.structural_subscriber=&field.tag=bitesize&field.tags_combinator=ANY&field.status_upstream-empty-marker=1&field.has_cve.used=&field.omit_dupes.used=&field.omit_dupes=on&field.affects_me.used=&field.has_patch.used=&field.has_branches.used=&field.has_branches=on&field.has_no_branches.used=&field.has_no_branches=on&field.has_blueprints.used=&field.has_blueprints=on&field.has_no_blueprints.used=&field.has_no_blueprints=on&search=Search&orderby=-date_last_updated&start=0") tagged bug and jump into it, ask questions in IRC or on the bug itself, and determine what work is required.

Another way to select a bug is to find a source package or a package source in a programming language you are familiar with: if you are a fan of Python look for Python source packages.

Finally, try giving the list of [server-next](https://bugs.launchpad.net/ubuntu/?field.searchtext=&orderby=-importance&field.status:list=NEW&field.status:list=CONFIRMED&field.status:list=TRIAGED&field.status:list=INPROGRESS&field.status:list=FIXCOMMITTED&field.status:list=INCOMPLETE_WITH_RESPONSE&field.status:list=INCOMPLETE_WITHOUT_RESPONSE&assignee_option=any&field.assignee=&field.bug_reporter=&field.bug_commenter=&field.subscriber=&field.structural_subscriber=&field.component-empty-marker=1&field.tag=server-next&field.tags_combinator=ANY&field.status_upstream-empty-marker=1&field.has_cve.used=&field.omit_dupes.used=&field.omit_dupes=on&field.affects_me.used=&field.has_no_package.used=&field.has_patch.used=&field.has_branches.used=&field.has_branches=on&field.has_no_branches.used=&field.has_no_branches=on&field.has_blueprints.used=&field.has_blueprints=on&field.has_no_blueprints.used=&field.has_no_blueprints=on&search=search) tagged bugs a look. These bugs need to be fixed and are tagged next for a reason.

## 4. Make the Bug Yours

Once you have decided to work on a bug, you need to make sure others know you are working on it. This step is very important for a number of reasons:

  1. Shows the reporter that someone is working on his or her bug! It is a good feeling to know that someone is taking your report seriously and trying to drive it to resolution.
  1. Tells others to not grab and fix the bug themselves. This prevents someone stepping on your attempt to fix a bug.
  1. Give others a point of contact for providing input on how to fix the bug. If someone comes along and has more input or help that they can provide they can leave a message.

### Assigning

To do make sure the bug is not assigned to anyone. At the top of the bug in the row should show "Assigned to" as "Unassigned" like the picture below:

![Assign Launchpad Bug](/img/launchpad/bug_assign.png)

If you are logged in, press the yellow circle with a pencil. On the new window, select "Assign me" and the bug will not be assigned to you:

![Assign Me Launchpad Bug](/img/launchpad/bug_assign_me.png#center)

## 5. Subscribe

You will want to make sure you receive any email notifications about the bug status or additional comments that are made on the bug. To do this on the right-hand side, inside of the 4th box from the top, click "not directly subscribed to this bug's notifications.":

![Subscribe Launchpad Bug](/img/launchpad/bug_subscribe.png#center)

On the new window, select "Receive all emails about this bug" to have all updates sent to you:

![Emails Launchpad Bug](/img/launchpad/bug_all_emails.png#center)

## 6. Comment on the Bug

Finally, add a comment to the bug stating your intention to work on the bug. You are not signing your life away and forcing yourself to resolve the bug. Again you are communicating out to the world that you are trying to develop a fix.

Something like the following would work:

```text
Hi! I am taking the bug and will attempt to drive it to resolution.
I will be work on proposing a fix and proposing a merge to get this fixed.
```

You can also consider adding the following information:

* If you have identified fix: `I'll be using the fix from <here>`
* What versions of Ubuntu you: `I am targeting to fix in Xenial and Artful.`
* If you are new to this" `This is my first bug, but I will give it my best.`

To do this, scroll to the bottom of the page, enter your message in the text box, and press "Post Comment":

![Comment Launchpad Bug](/img/launchpad/bug_comment.png)

## Change of mind

Fast-forward a few weeks (or months) and maybe you find yourself unable to fix the bug? Do not have time to devote to fixing it? Changed your mind? Then what do you do?

Essentially reverse the last step:

* Unassign the bug from yourself
* Move from "In Progress" to "Confirmed"
* Leave a comment that you are no longer working on the bug explaining why you can no longer work on it.

Do not be embarrassed to say you could not solve the bug or you do not have time. Both of those are far better than never saying anything all, leaving people wondering.

I do suggest staying subscribed to the bug in case someone has questions for you, after all, you did spend some time working on the bug and your experience may still be helpful to others!

## Summary

Here is a quick summary of the items laid out above:

  1. Create an account on [Launchpad](https://launchpad.net/)
  1. View the complete [Ubuntu Server backlog](https://bugs.launchpad.net/~ubuntu-server/+subscribedbugs), the [bitesize](https://bugs.launchpad.net/~ubuntu-server/+subscribedbugs?field.searchtext=&field.status:list=NEW&field.status:list=CONFIRMED&field.status:list=TRIAGED&field.status:list=INPROGRESS&field.status:list=FIXCOMMITTED&field.status:list=INCOMPLETE_WITH_RESPONSE&field.status:list=INCOMPLETE_WITHOUT_RESPONSE&assignee_option=any&field.assignee=&field.bug_reporter=&field.bug_commenter=&field.subscriber=&field.structural_subscriber=&field.tag=bitesize&field.tags_combinator=ANY&field.status_upstream-empty-marker=1&field.has_cve.used=&field.omit_dupes.used=&field.omit_dupes=on&field.affects_me.used=&field.has_patch.used=&field.has_branches.used=&field.has_branches=on&field.has_no_branches.used=&field.has_no_branches=on&field.has_blueprints.used=&field.has_blueprints=on&field.has_no_blueprints.used=&field.has_no_blueprints=on&search=Search&orderby=-date_last_updated&start=0) tagged bugs, or [server-next](https://bugs.launchpad.net/ubuntu/?field.searchtext=&orderby=-importance&field.status:list=NEW&field.status:list=CONFIRMED&field.status:list=TRIAGED&field.status:list=INPROGRESS&field.status:list=FIXCOMMITTED&field.status:list=INCOMPLETE_WITH_RESPONSE&field.status:list=INCOMPLETE_WITHOUT_RESPONSE&assignee_option=any&field.assignee=&field.bug_reporter=&field.bug_commenter=&field.subscriber=&field.structural_subscriber=&field.component-empty-marker=1&field.tag=server-next&field.tags_combinator=ANY&field.status_upstream-empty-marker=1&field.has_cve.used=&field.omit_dupes.used=&field.omit_dupes=on&field.affects_me.used=&field.has_no_package.used=&field.has_patch.used=&field.has_branches.used=&field.has_branches=on&field.has_no_branches.used=&field.has_no_branches=on&field.has_blueprints.used=&field.has_blueprints=on&field.has_no_blueprints.used=&field.has_no_blueprints=on&search=Search) tagged bugs.
  1. Find an appropriately sized bug that aligns with your interest and ability
  1. Assign yourself to the bug and mark the bug "In Progress"
  1. Subscribe to all updates on the bug
  1. Leave a comment with your intention to work on the bug

## Next Steps

With a bug in hand, it is time to start the process of developing the fix, submitting a merge request, and testing the proposed package.
