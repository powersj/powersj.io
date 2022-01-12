---
title: "Telegraf Plugin Spotlight: Exec & Execd"
date: 2021-12-02
tags: ["telegraf"]
draft: false
aliases:
  - /post/telegraf-plugin-spotlight-exec-execd/
---

***This is a copy of a [blog post](https://www.influxdata.com/blog/plugin-spotlight-exec-execd/)
I wrote originally posted on [InfluxData.com](https://www.influxdata.com/)***

[Telegraf](https://www.influxdata.com/time-series-platform/telegraf/) comes
included with over 200+ input
[plugins](https://www.influxdata.com/products/integrations/) that collect
metrics and events from a comprehensive list of sources. While these plugins
cover a large number of use cases, Telegraf provides another mechanism to give
users the power to meet nearly any use case: the
[Exec](https://docs.influxdata.com/telegraf/v1.20/plugins/#exec) and
[Execd](https://docs.influxdata.com/telegraf/v1.20/plugins/#execd) input
plugins. These plugins allow users to collect metrics and events from custom
commands and sources determined by the user.

![telegraf exec and execd](/img/telegraf/telegraf-exec-execd.png#center)

## The Exec Plugin

The `exec` input plugin allows users to run arbitrary commands to collect data
and metrics at each collection interval. The plugin requires that each command
returns output data in any accepted
[Input Data Formats](https://github.com/influxdata/telegraf/blob/master/docs/DATA_FORMATS_INPUT.md).

For example, consider some of these possible use cases:

* Interacting with proprietary or in-development systems
* Collecting custom output from a highly unique use case
* Executing a program directly to generate and collect data

The plugin’s configuration is straightforward in requiring a list of commands
to run and the data format of the output:

```toml
[[inputs.exec]]
  data_format = "json"
  commands = [
    "/home/ubuntu/script.sh",
    "/usr/bin/cmd --json --option=value"
  ]
```

Note that the commands are all run in parallel at every collection interval,
and each entry in the command array must produce valid output. The commands
must exist in the PATH of the user running the telegraf process. Finally, if
the user needs to do any setup or configuration, that should all occur in the
command the user specifies.

Users can use multiple exec stanzas and the name_suffix option to differentiate
them. For example, the suffix value of "_example" is appended to the metric
name, changing "exec" to "exec_example".

```toml
[[inputs.exec]]
  name_suffix = "_script1"
  data_format = "influx"
  commands = ["/usr/bin/script1.sh --json --option=value"]

[[inputs.exec]]
  name_suffix = "_script2"
  data_format = "json"
  commands = ["/usr/bin/script2.sh --json --option=value"]
```

## The Execd Plugin

The `execd` input plugin allows users to run an external command as a
long-running daemon. The plugin will process data as it comes in or will send a
signal to receive data. The plugin also requires that each command returns
output data in any accepted [Input Data Formats](https://github.com/influxdata/telegraf/blob/master/docs/DATA_FORMATS_INPUT.md).

`execd` is excellent for taking in streaming, event-based data. The specified
`execd` command is run once instead of constantly executing the command at
every collection interval like `exec`. Once running, Telegraf expects the
command to pass data to STDOUT.

Below is an example configuration:

```toml
[[inputs.execd]]
  command = ["/usr/bin/script.sh"]
  data_format = "json"
```

### Execd gathering

The optional signal setting can instruct Telegraf to pass a newline on STDIN,
or some other signal, to the process to gather new data. The signal setting is
helpful in scenarios where the user wants to have Telegraf notify the command
that it is time to run the collection.

For example, the following Go code will listen for a newline on STDIN, and when
it is received, print the counter:

```go
package main

import (
    "bufio"
    "fmt"
    "os"
)

func main() {
    counter := 0
    reader := bufio.NewReader(os.Stdin)

    for {
        reader.ReadString('\n')

        fmt.Printf("go_example count=%d\n", counter)
        counter++
    }
}
```

A user could modify this code to run a command to gather specific data instead
of a simple print.

## Get started with Exec and Execd plugins

With the `exec` and `execd` plugins, users can collect data and metrics from
nearly any source. These plugins give users an immense amount of flexibility
and freedom to start collecting data. Combined with a free InfluxDB Cloud
account, [download Telegraf](https://portal.influxdata.com/downloads/), check
out the complete list of [input plugins](https://docs.influxdata.com/telegraf/latest/plugins/#input-plugins),
and start using Telegraf to collect metrics!
