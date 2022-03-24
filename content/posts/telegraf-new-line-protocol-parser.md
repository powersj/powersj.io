---
title: "Telegraf's New Fast and Efficient Line Protocol Parser"
date: 2022-03-23
tags: ["telegraf"]
draft: false
aliases:
  - /post/new-line-protocol-parser/
---

***This is a copy of a [blog post](https://www.influxdata.com/blog/new-line-protocol-parser/)
I wrote originally posted on [InfluxData.com](https://www.influxdata.com/)***

![github PR build artifacts](/img/telegraf/telegraf-line-protocol-parser-config.png#center)

As part of the new v1.22.0 Telegraf release, [Telegraf](https://www.influxdata.com/time-series-platform/telegraf/)
is happy to announce the availability of a faster, more memory-efficient
implementation of the Line Protocol Parser. Users who make heavy use of line
protocol and are parsing huge amounts of data will greatly benefit. This new
parser is already in production across InfluxDB Cloud as well.

While this new parser is not the default setting, users can enable the new
parser with a single configuration option to take advantage of these
improvements:

## Influx Parser format

To enable the use of the new parser while using the influx data format, set the
parser type to "upstream":

```toml
data_format = "influx"
influx_parser_type = "upstream"
```

The "upstream" value will enable the use of the new faster more memory
efficient parser, while "internal" (which is the default setting) will continue
to use the existing parser. This setting allows users to opt-in to the new
parser and allows us to collect more confidence in ensuring the stability of
existing configurations.

If the option is omitted it will use the default, which is currently
"internal". In a future release, Telegraf will switch the default parser to use
the new parser.

Here is a full example, while using the file input plugin:

```toml
[[inputs.file]]
    files = ["/tmp/metrics.out"]

    data_format = "influx"
    influx_parser_type = "upstream"
```

## InfluxDB Listener

Users of the [influxdb_listener](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/influxdb_listener)
or [influxdbv2_listener](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/influxdb_v2_listener)
plugins can also take advantage of the new parser by setting the parser_type
option to "upstream":

```toml
[[inputs.influxdb_listener]]
    service_address = ":8186"
    parser_type = "upstream"
```

If the option is omitted, it will default to "internal". In a future release,
this value will also switch to using the new parser.

## Try it out

Whether you have one of these exciting new architectures or not, head over to
the [GitHub release page](https://github.com/influxdata/telegraf/releases) for
Telegraf, and let Telegraf help you collect metrics today!
