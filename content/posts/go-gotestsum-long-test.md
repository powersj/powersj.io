---
title: "gotestsum and long Go tests"
date: 2023-02-07
tags: ["go"]
draft: true
aliases:
  - /post/gotestsum-long-tests/
---

The [Telegraf]() project has a huge number of unit tests. Which is great,
except when these unit tests take an enormous amount of time to run. I believe
that unit tests should be very quick to run to encourage developers to run them
often and catch issues earlier. Hopefully, on their own system and not wait for
CI to get to it. My ideal situation is that unit tests take less than a 30
seconds to run.

https://github.com/influxdata/telegraf-internal/issues/279

## gotestsum

[gotestsum]() is a go test runner with human readable output. It also makes it
easy to quickly gather timing information.

To get started install the `gotestsum` binary:

```s
go install gotest.tools/gotestsum@latest
```

Then to collect the timings of a fresh run of all tests:

```s
$ go clean -cache
$ gotestsum --jsonfile timings.json -- ./...
...
DONE 5869 tests, 208 skipped in 57.745s
```

This will create the `timings.json` file which includes timings broken out by
each unit test. To find the longest ten tests we can sort by the slowest tests
and print out only the first 10 lines:

```s
❯ gotestsum tool slowest < timings.json  | head -n 10
github.com/influxdata/telegraf/plugins/inputs/prometheus TestPrometheusGeneratesMetricsSlowEndpointHitTheTimeout 6s
github.com/influxdata/telegraf/plugins/inputs/influxdb_v2_listener TestWriteHighTraffic 5.73s
github.com/influxdata/telegraf/plugins/inputs/prometheus TestPrometheusGeneratesMetricsSlowEndpoint 4s
github.com/influxdata/telegraf/plugins/inputs/socket_listener TestCases 2.72s
github.com/influxdata/telegraf/models TestPluginOptionValueDeprecation 1.5s
github.com/influxdata/telegraf/plugins/inputs/socket_listener TestCases/timeout 1.2s
github.com/influxdata/telegraf/plugins/inputs/cloud_pubsub TestRunErrorInSubscriber 1s
github.com/influxdata/telegraf/models TestPluginOptionValueDeprecation/None 1s
github.com/influxdata/telegraf/config TestReadBinaryFile 980ms
github.com/influxdata/telegraf/plugins/inputs/socket_listener TestSocketListener 940ms
```

With this data in hand users have an actionable list of tests to target for
possible improvements.

## Solutions

Below are some of the changes I have seen done to deal with slow tests. There
is no clear direct solution in many cases, but this are some of the common
changes I have had to make:

### Mock servers

Tests that require networking to external services often end up leading to
flaky tests or tests that do not run on developers systems. In fact, depending
on remote services is not something that should happen in unit tests in general.
Instead, users should mock out a test service for testing.

The way I look for these is to disable networking on my system and see what
tests fail. Then build out the mock service and migrate the test to spin up
and expect that.

### Random ports

TODO

### require.Eventually


```go
time.Sleep(interval)
```

```go
check := func() bool {
    return acc.NMetrics() == uint64(len(expected))
}
require.Eventually(t, check, 1*time.Second, 100*time.Millisecond)
```

### Skip long test

Leave favorite option, because now you have different test modes to care about

- all
- short
- integration

Can entire miss some tests if you are not careful.

```go
if testing.Short() {
    t.Skip("Skipping long test in short mode")
}
```
