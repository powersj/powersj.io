---
title: "gotestsum and long Go tests"
date: 2023-02-22
tags: ["go"]
draft: false
aliases:
  - /post/gotestsum-long-tests/
---

Unit tests should execute quickly to encourage developers to run them often and
catch issues earlier. Hopefully, on their own system and not wait for CI to get
to it. My ideal situation is that unit tests take less than a 30 seconds to
run.

The [Telegraf][1] project has a huge number of unit tests. Which is
great, except when these unit tests take an enormous amount of time to run.
Last year I spent a couple of hours going through analyzing the time it takes
to run some tests and made a few changes to reduce some longer running tests.

The following are my notes from that endeavour.

[1]: https://github.com/influxdata/telegraf

## gotestsum

[gotestsum][2] is a Go test runner with human readable output. It also makes it
easy to quickly gather timing information.

To get started install the `gotestsum` binary:

```s
go install gotest.tools/gotestsum@latest
```

Then to collect the timings of fresh run of all tests:

```s
$ go clean -cache
$ gotestsum --jsonfile timings.json -- ./...
...
DONE 5869 tests, 208 skipped in 57.745s
```

The first command removes the Go test cache, so that you ensure that all tests
are run and you start from a clean state.

The second command creates the `timings.json` file which includes timings
broken out by each unit test. Users can take this file and pass it back to
gotestsum to analyze the results. For example, to find the longest ten tests:

```s
$ gotestsum tool slowest < timings.json  | head -n 10
github.com/influxdata/telegraf/internal/process TestRestartingRebindsPipes 5.04s
github.com/influxdata/telegraf/plugins/outputs/http TestStatusCode/1xx_status_is_an_error 5s
github.com/influxdata/telegraf/plugins/outputs/loki TestStatusCode 5s
github.com/influxdata/telegraf/plugins/outputs/loki TestStatusCode/1xx_status_is_an_error 5s
github.com/influxdata/telegraf/plugins/outputs/http TestStatusCode 5s
github.com/influxdata/telegraf/plugins/processors/topk TestTopkAggregatorsSmokeTests 4.01s
github.com/influxdata/telegraf/plugins/inputs/uwsgi TestHttpError 3.61s
github.com/influxdata/telegraf/plugins/inputs/jti_openconfig_telemetry TestOpenConfigTelemetryDataWithMultipleTags 2.029s
github.com/influxdata/telegraf/internal/rotate TestFileWriter_DeleteArchives 2.009s
github.com/influxdata/telegraf/plugins/inputs/jti_openconfig_telemetry TestOpenConfigTelemetryData 2s
```

With this data in hand users have an actionable list of tests to target for
possible improvements.

One observation to make right away is that a number of these tests are taking
exactly or slightly more than a round number of seconds (e.g. 5 seconds). This
already is a pretty clear indication that some sort of sleep is taking place
which may not be what a user wants.

[2]: https://github.com/gotestyourself/gotestsum

## Solutions

Below are some of the changes I have seen done to deal with slow tests. There
is no clear direct solution in many cases, but these are some of the common
changes I have had to make:

### require.Eventually

The most common cause of long running tests are sleeps in tests:

```go
time.Sleep(interval)
```

Almost all the long tests above are caused due to sleeps that wait for
something to happen. On a really slow system that may be I/O bound, those tests
may even fail if the sleep is not long enough leading to flaky tests.

The most common solution I have used for these types of problems is the use of
the go test library [testify][3] and the [require.Eventually][4] helper:

```go
check := func() bool {
    return acc.NMetrics() == uint64(len(expected))
}
require.Eventually(t, check, 1*time.Second, 100*time.Millisecond)
```

What this does is take a function that returns a boolean. When that function
returns true, tests move on. The additional parameters put a timeout on how
long to check that function and how often to call that function.

The result is there is a clear method for determining when to continue and
arbitrary sleeps are removed. Long running tests are usually reduced to
milliseconds in time versus the 2-5 seconds they previous took.

[3]: https://github.com/stretchr/testify
[4]: https://pkg.go.dev/github.com/stretchr/testify/require#Eventually

### Mock servers

Tests that require networking to external services often end up leading to
flaky tests or tests that do not run on developers systems. In fact, depending
on remote services is not something that should happen in unit tests in
general. Instead, users should mock out a test service for testing.

The way I look for these is to disable networking on my system and see what
tests fail. Then build out the mock service and migrate the test to spin up
and expect that.

For more on the process of mocking HTTP requests with interfaces during
tests check out [this post on interfaces][5] or [this straightforward post][6]
on mocking HTTP requests in tests.

These types of improvements can save small amounts of time if the user is able
to easily access the service, or significant amounts of time if the test
hits a timeout waiting on a service.

[5]: https://www.alexedwards.net/blog/interfaces-explained
[6]: https://www.thegreatcodeadventure.com/mocking-http-requests-in-golang/

### Random ports

While not specific to long tests, it does cause flaky tests to occur, and that
is the use of specific ports. Given that Go run's different package tests in
parallel it may mean on package might stomp on another's use of a certain port.

One way to do this is to specify the 0 port as a wildcard to find any available
port:

```go
net.Listen("tcp", ":0")
```

A second option is to use a library like [go-reuseport][7] to help with port
re-use.

[7]: https://github.com/libp2p/go-reuseport

### Skip long test

Finally, my least favorite option, because now you have different test modes to
care about, is to skip a test. One way to do this is to skip a specific test
when running with Go's [short mode][8]:

```go
if testing.Short() {
    t.Skip("Skipping long test in short mode")
}
```

The consequence of this is you would probably want all your short CI tests
to run tests with the `-short` option to be consistent, but you may never run
this test unless somewhere along the way you omit the `-short` flag.

[8]: https://pkg.go.dev/cmd/go#hdr-Testing_flags

## Results

After the various updates I made to tests, this saved users dozens of seconds
with their tests per run. This is compounded on our slower CI systems meaning
users get results faster as well.

Take a look at gotestsum and see what improvements you might be able to make!
