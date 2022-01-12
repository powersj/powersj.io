---
title: "Apple M1 and RISC-V Support for Telegraf"
date: 2022-01-12
tags: ["telegraf"]
draft: false
aliases:
  - /post/telegraf-apple-m1-riscv-support/
---

***This is a copy of a [blog post](https://www.influxdata.com/blog/apple-m1-and-risc-v-support-for-telegraf/)
I wrote originally posted on [InfluxData.com](https://www.influxdata.com/)***

![telegraf, m1, risc-v](/img/telegraf/telegraf-m1-riscv.png#center)

Telegraf is the open-source server agent to help you collect metrics from your
stacks, sensors, and systems. Telegraf supports almost a dozen architectures
across Linux, FreeBSD, macOS, and
Windows operating systems.

With the release of [Telegraf v1.21.2](https://www.influxdata.com/blog/release-announcement-telegraf-1-21-2/),
InfluxData is excited to announce builds for Apple’s M1-based systems and the
RISC-V architecture!

## Apple M1

Apple has transitioned its computing devices from Intel-based processors to its
custom silicon based on the ARM64 architecture. The transition came to fruition
with the release of the M1 and later M1 Pro and M1 Max processors.

Telegraf releases and nightlies will include a download for macOS ARM64 to
support Apple M1-based devices.

## RISC-V

As an open-source project, it is exciting to see the growth of the RISC-V
open-source instruction set architecture from the RISC-V consortium. As the
architecture evolves, there is a tremendous opportunity for RISC-V-based
processors in IoT microprocessors to graphics, machine learning, AI workloads,
and large server systems.

Telegraf releases and nightlies will now include Linux downloads for riscv64
binary as well as a pre-built DEB and RPM package for easy installation.

## Download Telegraf

Whether you have one of these exciting new architectures or not, head over to
the [GitHub release page](https://github.com/influxdata/telegraf/releases) for
Telegraf and let Telegraf help you collect metrics today!
