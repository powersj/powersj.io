---
title: "Using the Common Expression Language for Metric Filtering with Telegraf"
date: 2023-06-22
tags: ["telegraf"]
draft: false
aliases:
  - /post/telegraf-common-expression-language/
---

[Telegraf][telegraf] is an open-source plugin-driven agent for collecting,
processing, aggregating, and writing time series data. When collecting metrics
it is common to filter out or pass through metrics with specific names, tags,
fields, or timestamp values.

The [Common Expression Language (CEL)][cel] is an open-source language that
provides a set of semantics for expression evaluation. Kubernetes users may
already be familiar with the language as it is used to declare validation rules,
policy rules, and other constraints or conditions.

In [v1.27][1.27], Telegraf now has the ability to parse CEL expressions to
filter metrics. The following post outlines how users can take advantage of CEL
to filter metrics easier than ever with Telegraf.

[telegraf]: https://www.github.com/influxdata/telegraf/
[cel]: https://github.com/google/cel-spec
[1.27]: https://www.influxdata.com/blog/release-announcement-telegraf-1-27

## Telegraf configuration

The new `metricpass` option enables CEL filtering. This is similar to the
existing `namepass` or `tagpass` options.

Telegraf evaluates the metrics based on the expression. Metrics that match the
expression are passed on, while other metrics are dropped.

```toml
[[inputs.cpu]]
  metricpass = "fields.usage_idle < 90"
```

This option is valid for any input, output, processor, and aggregator plugin.
For inputs the filtering takes place at the very end of an input, while for the
other plugin types the filter is run before those plugins are run.

While the CEL language is incredibly powerful, it does not alter metrics. It
only determines which metrics should continue on from an input or to other
plugins.

## CEL syntax by example

The following are a set of examples to introduce CEL usage for Telegraf. For the
complete set of types, logic, and functions users can reference the
[cel-spec language definition][cel definition] in the CEL repo. There is even a
[CEL Discussion Forum][cel forum] for help with specific questions about the
language.

[cel definition]: https://github.com/google/cel-spec/blob/master/doc/langdef.md
[cel forum]: https://groups.google.com/g/cel-go-discuss

### Referencing metric components

In order to filter metrics, users can reference specific components of a metric.
Consider the following example metric:

```s
example,host=a value=42 1686252961000000000
```

The following table shows how to reference the specific components of the
metric:

| Component   |	CEL Reference |	Example |
|-------------|---------------|---------|
| Metric name |	name 	| `name == "example"` |
| Tags 	      | tags 	| `tags.host = "a"` |
| Fields 	  | fields 	| `fields.value > 0` |
| Timestamp   |	time 	| `time >= now() - duration("24h")` |

### Logical operators

CEL supports C- and Go-style logic operators to make comparisons. The following
example checks that the field "id" exists and the field "id" contains the
substring "nwr".

```go
"id" in fields && fields.id.contains("nwr")
```

This example ensures the metric name does not start with a "t" and that the tag
"state" is equal to "on".

```go
!name.startsWith("t") || tags.state == "on"
```

### Numeric operations

For numeric values, users can do both arithmetic and equality operations. For
example:

```go
fields.value / 8 >= 1024
fields.bits % 2 == 0
```

### String operations

To aid in testing strings, users have a number of helper functions available. The following table lists a few common ones:

| Function | Test Description  | Example  |
|----------|-------------------|----------|
| contains   | String contains substring | `tags.host.contains("domain")` |
| endsWith   | Test string suffix | `tags.id.endsWith(".com")` |
| lowerAscii | Lower case string | `metric.name.lowerAscii()` |
| matches    | Compare string against a regular expression | `tags.source.matches("^[0-9a-zA-z-_]+@mycompany.com$")` |
| startsWith |	Test string prefix | `tags.host.startsWith("subdomain")` |
| size       | String length | `tags.id.size()` |

For the full list of functions, check out [string.go source][string.go], which
includes examples as well.

[string.go]: https://github.com/google/cel-go/blob/master/ext/strings.go

### Time operations

A possible use case for this type of filtering would be to remove metrics older
than a specific date. CEL includes a variety of helper functions to pick apart a
date. For example:

```js
time.getFullYear() == 2023
```

There is a large list of these helper functions available on the CEL list of
[standard definitions][std def].

[std def]: https://github.com/google/cel-spec/blob/master/doc/langdef.md#list-of-standard-definitions

Additionally, a user can compare the current time to the timestamp. With this a
user can see if a timestamp is less than a day old:

```go
time >= now() - duration("24h")
```

### Types

To test for a specific type, the `type()` function returns what a particular tag
or field is. This might be useful to ensure a field is a numeric type:

```go
type(fields.bits) in [double, int, uint]
type(fields.cluster) == string
```

The first line ensures that the bits field is of a numeric type, while the
second ensures the cluster field is a string.

## Performance impact

Users should keep in mind that CEL usage comes at a cost. CEL is an interpreted
language and uses overhead when implemented. If you only filter based on a
specific tag or metric name, continue to use the `namepass/namedrop` and
`tagpass/tagdrop` configuration options to achieve the best performance.
However, in most cases, these CEL filters should be faster than using the
Starlark processor to do the same task.

## Get started with metric filtering and Telegraf

With the addition of the Common Expression Language for metric filtering in
v1.27, it is now even easier for users to customize their metrics. Download
[Telegraf][telegraf] and give the new `metricpass` option a try today!
