---
title: "Getting Started with Telegraf"
date: 2021-10-21
tags: ["telegraf"]
draft: false
aliases:
  - /post/telegraf-getting-started/
---

***This is a copy of a [blog post](https://www.influxdata.com/blog/getting-started-with-telegraf/)
I wrote originally posted on [InfluxData.com](https://www.influxdata.com/)***

![telegraf tiger](/img/telegraf/telegraf-tiger.png#center)

[Telegraf](https://www.influxdata.com/time-series-platform/telegraf/) is a
plugin-driven agent for collecting, processing, aggregating and writing metrics
and events. Telegraf ships as a single binary with no external dependencies
that runs with a minimal footprint and a
[plugin system](https://www.influxdata.com/products/integrations/) that
supports many popular services.

Telegraf is used to collect metrics from the system it runs on, applications,
remote IoT devices and many other inputs. Telegraf can also capture data from
event-driven operations. Once processed, Telegraf can send the metrics and
events to various data stores, services and message queues.

## Plugins

Telegraf comes included with
[over 300 plugins ready to use](https://www.influxdata.com/resources/tools-integrations-with-influxdb/).
Users enable and configure whatever plugins their specific use case requires.

Below is an introduction to the inputs where Telegraf can collect metrics from
and outputs where Telegraf can send metrics to:

### Inputs

Input plugins are available for over 200 different inputs. Below are examples
of a few categories of plugins that are available:

* **Applications**: Interact with Apache Kafka, MongoDB, MySQL, PostgreSQL,
  Apache Web Server, NGINX, postfix and many others.
* **Cloud**: Connect with Amazon CloudWatch, Amazon ECS, Azure Storage Queue,
  Google Cloud PubSub, Salesforce, VMware vSphere and others.
* **Containers**: Inspect Kubernetes clusters, Docker, etc.
* **Hardware**: Collect information about a system’s CPU, memory, network, and
  disk utilization. Redfish and IPMI allow for collecting metrics from hardware
  directly as well.
* **IoT**: Gather from generic sensors, IPMI, KNX, MQTT, and other IoT sensor
  projects.
* **Universal**: The file, tail, listener, poller, exec, and execd plugins
  provide generic mechanisms for collecting metrics that an included plugin
  might not cover.

For a complete list of all available input plugins, check out the
[input plugins](https://docs.influxdata.com/telegraf/v1.20/plugins/#input-plugins)
list on the documentation site.

### Outputs

Output plugins define where Telegraf will deliver the collected metrics.

One such output is [InfluxDB](https://www.influxdata.com/products/influxdb/),
an open-source time series database, which is
well-suited for operations monitoring, application metrics, IoT sensor data,
and real-time analytics. InfluxDB provides a place to store collected metrics
and the ability to graph and alert on metrics. InfluxDB is offered as a
[cloud service](https://www.influxdata.com/products/influxdb-cloud/) and as a
[download](https://portal.influxdata.com/downloads/) for running locally. As
such, InfluxDB is a perfect output for collecting metrics collected from
Telegraf.

Other example outputs include sending metrics to Apache Kafka, Amazon
CloudWatch, Datadog, a file, or via AMPQ, and many more. For a complete list of
more than 50 available output plugins, check out the
[output plugins](https://docs.influxdata.com/telegraf/latest/plugins/#output-plugins)
list on the documentation site.

### Processors & aggregators

Telegraf also has the concept of processors and aggregators. These plugins
allow for processing and grouping data up after collecting it and before
sending it to an output. This can be helpful if a user wishes to collect an
average value, add a specific tag to data, or filter certain data.

## Download

Telegraf is available for download on a wide range of operating systems and
architectures. Telegraf comes as a single binary with no external dependencies,
making it incredibly easy to deploy everywhere.

Archives containing the built binary are readily available for Microsoft
Windows, Linux, OS X, FreeBSD, and various system architectures. Users can
integrate Telegraf into IoT devices like Raspberry Pis, routers, and sensors to
giant IBM Power and s390x mainframes and on servers, PCs, or cloud instances.

| Operating System         | Architecture Support     |
|--------------------------|--------------------------|
| Linux | amd64, arm64, armv5, armv6+, i386, mips, mipsle, ppc64le, s390x |
| Microsoft Windows | amd64, i386 |
| Mac OS | amd64 |
| FreeBSD | amd64, i386, armv7 |

There are also RPM and DEB packages available for a subset of Linux downloads.

All downloads for Telegraf are available on the
[releases page](https://github.com/influxdata/telegraf/releases). There is also
an official telegraf [DockerHub image](https://hub.docker.com/_/telegraf/)
available for container deployments.

## Config File

With Telegraf in hand, the next step is to provide a configuration file for
Telegraf which outlines what plugins are enabled and how to configure them. The
configuration file is a [TOML](https://toml.io/en/) formatted file.

Here is a very simple configuration file that enables the collection of various
system metrics and outputs the metrics using the file output:

```toml
[[inputs.cpu]]
[[inputs.disk]]
  ignore_fs = ["tmpfs", "devtmpfs", "devfs", "iso9660", "overlay", "aufs", "squashfs"]
[[inputs.mem]]
[[inputs.net]]

[[outputs.file]]
```

This example enables the CPU, disk, memory, and network inputs and the file
output.

### Generating a configuration file

The config subcommand can produce a telegraf configuration file with all
possible plugins and configuration options commented out to help users get
going quickly:

```shell
telegraf config > telegraf.conf
```

The user can then use this file to see all the possible plugins and
configuration options. Then the user can uncomment whatever inputs and outputs
are required.

For detailed information on the configuration file as well as using environment
variables, see the
[configuration](https://docs.influxdata.com/telegraf/latest/administration/configuration/)
docs page.

## Using Telegraf

Here is a brief example of collecting metrics about the local system and
sending those outputs to a file. This example will use the CPU, memory, disk,
and network inputs and output to a file.

### Configuration

First, generate a configuration file with only the specific inputs and outputs
required. The config subcommand can take filters to reduce the size and only
output the required sections. The following will produce a config file with
only the four inputs and one output that this example uses:

```shell
telegraf --input-filter cpu:mem:disk:net --output-filter file \
    --aggregator-filter : --processor-filter : \
    config > system-metrics.toml
```

Users can separate multiple plugins with a colon (e.g. `cpu:memory:disk`) and
use a single colon (e.g. :) if no plugins of a specific type are needed to omit
that section.

At this point, if a particular plugin requires additional configuration like
credentials, hostnames, or other modifications, the user could edit the file to
add those settings.

### Execution

To run telegraf, point it at the configuration file and run:

```shell
$ telegraf --config system-metrics.conf
2021-09-14T16:58:25Z I! Starting Telegraf 1.20.0
2021-09-14T16:58:25Z I! Loaded inputs: cpu disk mem net
2021-09-14T16:58:25Z I! Loaded aggregators:
2021-09-14T16:58:25Z I! Loaded processors:
2021-09-14T16:58:25Z I! Loaded outputs: file
2021-09-14T16:58:25Z I! Tags enabled: host=nexus
2021-09-14T16:58:25Z I! [agent] Config: Interval:10s, Quiet:false, Hostname:"nexus", Flush Interval:10s
disk,device=sda2,fstype=ext4,host=nexus,mode=rw,path=/ inodes_used=117039i,total=244529823744i,free=224543232000i,used=7494070272i,used_percent=3.2296834166841246,inodes_total=15237120i,inodes_free=15120081i 1631638710000000000
disk,device=sda1,fstype=vfat,host=nexus,mode=rw,path=/boot/efi inodes_used=0i,total=535805952i,free=530321408i,used=5484544i,used_percent=1.0236063969666391,inodes_total=0i,inodes_free=0i 1631638710000000000
net,host=nexus,interface=enp0s25 err_out=0i,drop_in=35774i,drop_out=0i,bytes_sent=36403085i,bytes_recv=27820439i,packets_sent=122460i,packets_recv=105161i,err_in=0i 1631638710000000000
mem,host=nexus active=505004032i,high_free=0i,shared=1593344i,high_total=0i,inactive=288256000i,mapped=142225408i,low_total=0i,swap_total=4294963200i,used=215592960i,available_percent=94.0998533929871,committed_as=711008256i,swap_free=4294963200i,vmalloc_chunk=0i,write_back_tmp=0i,commit_limit=8400543744i,low_free=0i,sreclaimable=61390848i,page_tables=2625536i,vmalloc_total=35184372087808i,vmalloc_used=14512128i,cached=707207168i,free=7237840896i,huge_pages_total=0i,huge_pages_free=0i,huge_page_size=2097152i,slab=126316544i,swap_cached=0i,used_percent=2.625607391507568,buffered=50524160i,dirty=49152i,write_back=0i,total=8211165184i,available=7726694400i,sunreclaim=64925696i 1631638710000000000
net,host=nexus,interface=all icmp_outredirects=0i,icmpmsg_intype9=159i,udp_sndbuferrors=0i,udp_noports=0i,udplite_noports=0i,udplite_inerrors=0i,icmp_incsumerrors=0i,icmp_outerrors=0i,udplite_indatagrams=0i,tcp_estabresets=1i,tcp_outsegs=116186i,icmp_indestunreachs=2i,icmp_outtimestampreps=0i,tcp_insegs=51398i,tcp_currestab=2i,udp_indatagrams=70i,ip_outdiscards=0i,ip_forwarding=2i,icmp_outechoreps=0i,icmp_outtimeexcds=0i,udp_incsumerrors=0i,ip_indelivers=52105i,icmp_outechos=0i,icmp_intimestamps=0i,tcp_inerrs=0i,icmp_outparmprobs=0i,tcp_rtomin=200i,tcp_incsumerrors=0i,udp_inerrors=0i,udplite_outdatagrams=0i,udplite_rcvbuferrors=0i,ip_fragfails=0i,icmp_inaddrmasks=0i,ip_reasmreqds=0i,tcp_activeopens=134i,ip_reasmoks=0i,icmp_intimestampreps=0i,tcp_outrsts=10i,ip_reasmfails=0i,ip_inhdrerrors=0i,tcp_rtoalgorithm=1i,icmp_inechoreps=0i,icmp_outmsgs=2i,ip_outrequests=114218i,icmp_outdestunreachs=2i,tcp_attemptfails=2i,tcp_retranssegs=8i,ip_forwdatagrams=0i,ip_inunknownprotos=0i,icmp_outaddrmasks=0i,icmp_inechos=0i,icmp_outsrcquenchs=0i,udp_ignoredmulti=476i,udp_outdatagrams=71i,udplite_sndbuferrors=0i,ip_outnoroutes=4i,icmp_insrcquenchs=0i,udplite_ignoredmulti=0i,ip_indiscards=0i,icmp_inmsgs=161i,icmpmsg_outtype3=2i,ip_inreceives=52105i,ip_reasmtimeout=0i,udp_rcvbuferrors=0i,ip_defaultttl=64i,icmp_inparmprobs=0i,udplite_incsumerrors=0i,icmp_intimeexcds=0i,icmp_inaddrmaskreps=0i,ip_inaddrerrors=0i,icmp_inerrors=159i,icmp_inredirects=0i,icmp_outtimestamps=0i,icmpmsg_intype3=2i,tcp_maxconn=-1i,ip_fragoks=0i,ip_fragcreates=0i,tcp_rtomax=120000i,icmp_outaddrmaskreps=0i,tcp_passiveopens=4i 1631638710000000000
```

Starting at the top, the version of Telegraf is running, and all the loaded
plugins are printed out. Users first see a list of the loaded inputs and
outputs specified by the configuration file.

Next are the tags and agent-specific configuration values.

The final lines are the metrics themselves. With the
[File Output Plugin](https://github.com/influxdata/telegraf/tree/master/plugins/outputs/file),
as metrics are collected, the output of those metrics is printed to stdout in
the InfluxDB Line Protocol and `/tmp/metrics.out`, both of which are
configurable to other output types or locations.

## InfluxDB Line Protocol

The output of metrics in the above case is in a format called
[line protocol](https://docs.influxdata.com/influxdb/cloud/reference/syntax/line-protocol/).
The line protocol is the protocol used by InfluxDB and shows how Telegraf
collects and parses the data, so it is ready for use by one of many outputs.

The format includes a metric name, tag set, fieldset, and timestamp separated
by newlines. Below is a breakdown of the various items:

* **measurement**: required, name of the metric itself
* **tags**: optional, key-value pairs that contain string metadata about the
  metric. InfluxDB will index these values.
* **fields**: at least one is required and contains key-value pairs. These are
  the actual metric data.
* **timestamp**: optional Unix timestamp for the data point. If the line does
  not include a timestamp, then the current system time is typically used.

Below is a regex of the line protocol:

```text
measurement(,tag_key=tag_val)* field_key=field_val(,field_key_n=field_value_n)* (nanoseconds-timestamp)?
```

## Try Telegraf today

Go check out the complete list of
[input](https://docs.influxdata.com/telegraf/latest/plugins/#input-plugins)
and
[output](https://docs.influxdata.com/telegraf/latest/plugins/#output-plugins)
plugins for collecting and storing metrics,
[download Telegraf](https://portal.influxdata.com/downloads/)
, and let Telegraf help you collect metrics!
