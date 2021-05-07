---
title: "Ubuntu Advantage Offerings in 20.04 LTS"
date: 2020-05-01
tags: ["ubuntu"]
draft: false
aliases:
  - /post/ubuntu-focal-ua/
---

Ubuntu is the most popular Linux distro today. Developers love it for it’s flexibility and reliability. You can find Ubuntu everywhere - from IoT devices to servers and on the Cloud. Yet, most Ubuntu users are not yet subscribed to Ubuntu Advantage program, which for many is (and will remain) available for free.

Ubuntu Advantage (UA) offers key services, security, and updates from Canonical to Ubuntu users. In 20.04, a new user experience arrives to simplify users' access to these key offerings. With the UA client embedded users can access all commercial services from Canonical with a single-token.

At the release of [Ubuntu 20.04 LTS (Focal Fossa)](https://ubuntu.com/blog/ubuntu-20-04-lts-arrives), users have immediate access to the Canonical Livepatch service and ESM for Infrastructure updates via UA Infrastructure.

Anyone can use UA Infrastructure Essential for free on up to 3 machines (limitations apply). All you need is an Ubuntu One account. And if you’re a recognised [Ubuntu community member](https://wiki.ubuntu.com/Membership), it’s free on up to 50 machines. To learn more and subscribe to UA Infrastructure, visit ubuntu.com/advantage. Enterprise users can purchase tokens to increase this limit or request additional support via UA Standard or UA Advanced.

To get started with UA, first create an [Ubuntu One account](https://login.ubuntu.com/) if you do not already have one. Once you have an account visit [ubuntu.com/advantage](https://ubuntu.com/advantage). On the Advantage page users can login to gain access to a free token.

![ubuntu.com/advantage](/img/ubuntu/ubuntu-com-advantage.png#center)

Once a user logs in to the site the page will show any subscriptions available. By default, every user is entitled to a free for personal use token. The steps to attach the system to the subscription using the `ua attach` command:

![ubuntu.com/advantage token](/img/ubuntu/ubuntu-com-advantage-token.png#center)

After attaching the system to a subscription, the `ua status` command will show what services and offerings are enabled. In Ubuntu 20.04 LTS, the ESM for Infrastructure and Canonical Livepatch service are both available and enabled on attach.

![ua status CLI output](/img/ubuntu/ua-status.png#center)

The UA client comes pre-installed on Ubuntu systems, with the updated client now available for Ubuntu 14.04 LTS and 20.04 LTS users and coming soon for Ubuntu 16.04 LTS and 18.04 LTS.

Learn more about [Ubuntu Advantage](https://ubuntu.com/advantage).
