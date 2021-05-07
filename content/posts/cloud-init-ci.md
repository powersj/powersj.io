---
title: "cloud-init: Jenkins Pipelines for CI/CD"
date: 2017-06-20
tags: ["cloud-init"]
draft: false
aliases:
  - /post/cloud-init-ci/
---

As of today, I have incorporated additional tests and checks to cloud-init's nightly testing and merge proposals. Many of these tests were already running nightly on master and were helping to drive quality and consistency to the project. It made sense to extend these tests to merge proposals as well to continue to drive quality at every step of the project. This post provides an overview of overall architecture and a greater description of each test itself.

## Pipeline

The [cloud-init](https://cloud-init.io/) team uses the [Ubuntu Server team's Jenkins](https://jenkins.ubuntu.com/server/view/Cloud-init/) instance to run all tests. Along with a major upgrade to version 2 of Jenkins, the team gained the ability to create and run [pipeline jobs](https://jenkins.io/doc/book/pipeline/). A pipeline consists of stages and each stage has a set of steps that are executed. Once a stage completes successfully, the next stage is started. However, if a stage fails, then the remaining stages are skipped and not executed. Given there were an increasing number of tests that were providing great value to the project it made sense to combine them into a series of tests that were run.

## cloud-init

The cloud-init project has two pipelines:

1. [Nightly pipeline](https://jenkins.ubuntu.com/server/view/Cloud-init/job/cloud-init-ci-nightly/) that is running against master
1. [CI Review pipeline](https://jenkins.ubuntu.com/server/view/Cloud-init/job/cloud-init-ci/) that is running against each merge proposal.

Both are made up of the same five primary stages:

![Pipeline stages](/img/cloud-init/pipeline.png)

### Checkout

Checkout is as simple as checking out master for the nightly run. However, for merge proposal testing, the branch for review is checked out as well as the tags from master:

```shell
git remote add master https://git.launchpad.net/cloud-init
git fetch master --tags
```

This way when running tox in the next step git describe works as expected.

### Unit & Style Tests

The unit and style tests are executed using [tox](https://tox.readthedocs.io/en/latest/). Running `tox` is a check we hope all developers are able to run before submitting a merge proposal. The default run will execute the following:

* Unit tests in a Python 2.7 and Python 3 environments
* [flake8](http://flake8.pycqa.org/en/latest/), the wrapper around [pycodestyle](https://pypi.python.org/pypi/pycodestyle), [PyFlakes](https://pypi.python.org/pypi/pyflakes), and the [McCabe complexity check](https://pypi.python.org/pypi/mccabe).
* [pylint](https://www.pylint.org/), a source code analyzer
* Unit tests against Python package levels found in Ubuntu Xenial

The versions of the tools used above are set in order to keep tests reproducible and avoid potential version changes of these tools from breaking.

However, to also check the latest and greatest versions of these packages that may contain fixes or new checks, three final tests are run. These include running with the latest version found on PyPI for pycodestyle, PyFlakes, and pylint. These can be ran by any developer as well with the following:

```shell
tox -e tip-pycodestyle
tox -e tip-pyflakes
tox -e tip-pylint
```

### Ubuntu LTS: Build

In the next phase, a.k.a. "Don't break the build", the source code is packaged up and built against the latest Ubuntu LTS, specifically 16.04 Xenial. This is done by using the build deb script and sbuild:

```shell
./packages/bddeb -S
sbuild --nolog --verbose --dist=xenial cloud-init_*.dsc
```

### Ubuntu LTS: Integration

As [announced](https://lists.launchpad.net/cloud-init/msg00058.html), cloud-init now contains an [integration test framework](https://cloudinit.readthedocs.io/en/latest/topics/tests.html). Running a few more tests helps provide additional coverage and assurance that nothing major broke. As of this writing, the tests cover an apt sources, NTP servers, password list, and user/group cloud-config scenarios.

However, my desire is to write up a series of more complex integration tests that touch many areas at once to maximize the coverage, while minimizing execution time. This is an open item.

### CentOS 6 & 7: Build & Test

The cloud-init team has recently invested in getting CentOS support better across the project. In order to support that effort, I have added a CentOS 6 and 7 build and test step, which uses the `tools/run-centos` script. This step deploys a CentOS container, installs dependencies, runs unit tests, and builds the cloud-init RPM.

A future plan is to expand, in a similar fashion, the distributions tested.

## Get in touch

If you have questions, comments, or suggestions please feel free to swing by #cloud-init on Freenode to chat with the team!
