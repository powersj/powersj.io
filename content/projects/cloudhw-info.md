---
title: CloudHW.info
description: A cloud instance decoder ring - decode instance types and the hardware they use
weight: 1
date: 2020-11-02
image: img/projects/cloudhw.png
---

![screenshot](/img/projects/cloudhw/search.png#center)

Each cloud has its own unique naming scheme for cloud instance types. Some
have different sizes (e.g. small, large, xlarge). Some have versions (e.g.
v2, v3, v4). All have families made up of a variety of letters and trying to
remember what these seemingly random set of letters and numbers mean
present a challenge to users.

That challenge resulted in the creation of
[cloudhw.info](https://cloudhw.info)! The site currently has the information
on instance types from three of the major clouds:

* Amazon Web Services
* Google Cloud Platform
* Microsoft Azure

On the main page, users can search for an instance type or select a family
from one of the families at the bottom of the page.

![screenshot](/img/projects/cloudhw/families.png#center)

Once a type is selected, on the new page users receive the following:

* **Decoder**: breakdown of what each letter and number means in the type name
* **Overview**: instance type's hardware, including CPU, memory, storage,
  networking, and other devices
* **Family**: table to compare the selected instance type with the rest of
  the instance type's family

![screenshot](/img/projects/cloudhw/decoder.png#center)

Checkout [cloudhw.info](https://cloudhw.info) and search for instance types
you have used, or check out some other instance types. To get started here
are some interesting and unique instance types:

* [AWS i3en](https://cloudhw.info/search.html?type=i3en.24xlarge) with huge
  amounts of storage
* [AWS c6g](https://cloudhw.info/search.html?type=c6g.large) using the new
  ARM based processors
* [Azure hb120rs_v2](https://cloudhw.info/search.html?type=hb120rs_v2) with
  extremely fast Infiniband and large amount of AMD CPUs

Finally, users can also download the raw data or search through it on the
[Download page](https://cloudhw.info/download.html). If you find something
missing, a typo, or have a question feel free to
[file a bug on GitHub](https://github.com/powersj/cloudhw.info/issues/new).
