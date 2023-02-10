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

```s
go install gotest.tools/gotestsum@latest
```

To collect a baseline of the 10 slowest tests:

```s
$ go clean -cache
$ gotestsum --jsonfile timings.json -- -short ./...
...
DONE 5869 tests, 208 skipped in 57.745s
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

## Solutions

### require.Eventually

```go
check := func() bool {
    return acc.NMetrics() == uint64(len(expected))
}
require.Eventually(t, check, 1*time.Second, 100*time.Millisecond)
```

### Mock Servers

Tests that require networking to external services

### Sleep

```
time.Sleep(interval)
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
