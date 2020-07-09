---
title: "Ubuntu Support of AWS Graviton2 Instances"
date: 2020-07-09
tags: ["ubuntu"]
draft: false
---

![Banner](/img/ubuntu/ubuntu-cloud.png#center)

Ubuntu is the industry-leading operating system for use in the cloud. Every day millions of Ubuntu instances are launched in private and public clouds around the world. Canonical takes pride in offering support for the latest cloud features and functionality.

As of today, all Ubuntu Amazon Web Services (AWS) Marketplace listings are now updated to include support for the new Graviton2 instance types. [Graviton2](https://aws.amazon.com/ec2/graviton/) is Amazon’s next-generation ARM processor delivering increased performance at a lower cost. This announcement includes three new instances types:

* M6g for general-purpose workloads with a balance of CPU, memory, and network resources
* C6g for compute-optimized workloads such as encoding, modeling, and gaming
* R6g for memory-optimized workloads, which process large datasets in memory like databases

Users on Ubuntu 20.04 LTS (Focal) can take advantage of additional optimizations found on newer ARM-based processors. The large-system extensions (LSE) are enabled by using the included libc6-lse package, which can result in orders of magnitude performance improvements. Ubuntu 18.04 LTS (Bionic) will shortly be able to take advantage of this change as well.

Additionally, Amazon will soon launch instances with locally attached NVMe storage called M6gd, C6gd, and R6gd. With these instance types, users can further increase performance with additional low-latency, high-speed storage.

Launch Ubuntu instances on the AWS Marketplace today:

* [AWS Marketplace - Ubuntu 20.04 LTS (Focal)](https://aws.amazon.com/marketplace/pp/B087RLZNXK)
* [AWS Marketplace - Ubuntu 18.04 LTS (Bionic)](https://aws.amazon.com/marketplace/pp/B07KTB9TV5)
* [AWS Marketplace - Ubuntu 16.04 LTS (Xenial)](https://aws.amazon.com/marketplace/pp/B07KTDC2HN)
