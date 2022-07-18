---
title: "Getting started with the InfluxDB Python Client Library"
date: 2022-07-17
tags: ["influxdata"]
draft: false
aliases:
  - /post/influxdb-client-library-python-getting-started/
---

TODO: intro

* get the library
* API structure
* creating a client
* data
* writing

## Getting Started

The InfluxDB Python client library supports InfluxDB 2.x and newer as well as
InfluxDB 1.8 and newer. It is built and tested to support Python 3.6 and newer.

### Download

The InfluxDB Python client library is available directly from [PyPI][1] for
easy installs with pip or as a dependency in a project:

```bash
pip install influxdb-client
```

This installs the library with the basic set of dependencies.

### API & Documentation

The client library API and documentation is available on [Read the Docs][3].

[3]: https://influxdb-client.readthedocs.io/en/stable/

### Package Extras

There are three package extras available as well that will pull in additional
dependencies:

* `influxdb-client[ciso]`: includes a date package that utilizes
  C-bindings. The benefit of this package is faster handling of dates at the
  cost of requiring the use of C-bindings.
* `influxdb-client[async]`: as the name implies, this allows for the use of
  asynchronous requests with the client library if the user's tools make use of
  the async and await Python commands.
* `influxdb-client[extras]`: adds special support for pandas and data frames.
  These additional dependencies are large and not always needed, therefore it
  was included as a separate extra package.

### Source

If a user wants to build or use the library from the source it is available on
[Github][2]:

```bash
git clone https://github.com/influxdata/influxdb-client-python
```

[1]: https://pypi.org/project/influxdb-client/
[2]: https://github.com/influxdata/influxdb-client-python

## API

At a high-level the API consists of a client and which then provides access
to various APIs exposed by InfluxDB.

The [InfluxDBClient][10] is used to handle authentication parameters and
connect to InfluxDB. There are a number of different ways to specify the
parameters, which the following section will demonstrate.

[10]: https://influxdb-client.readthedocs.io/en/stable/api.html#influxdbclient

Once connected there are three APIs which handle basic interactions with
InfluxDB:

* [WriteApi][11]: write time series data to InfluxDB
* [QueryApi][12]: query InfluxDB using Flux, InfluxDB's functional data
  scripting language
* [DeleteApi][13]: delete time series data in InfluxDB

[11]: https://influxdb-client.readthedocs.io/en/stable/api.html#writeapi
[12]: https://influxdb-client.readthedocs.io/en/stable/api.html#queryapi
[13]: https://influxdb-client.readthedocs.io/en/stable/api.html#deleteapi

Users can also use the client library to create tasks, invocable scripts, and
labels:

* [TasksApi][14]: Use tasks (scheduled Flux queries) to input a data stream and
  then analyze, modify, and act on the data accordingly
* [InvokableScriptsApi][15]: Create custom InfluxDB API endpoints that
  query, process, and shape data.
* [LablesApi][16]: Add visual metadata to dashboards, tasks, and other items in
  the InfluxDB UI

[14]: https://influxdb-client.readthedocs.io/en/stable/api.html#tasksapi
[15]: https://influxdb-client.readthedocs.io/en/stable/api.html#invokablescriptsapi
[16]: https://influxdb-client.readthedocs.io/en/stable/api.html#labelsapi

Finally, users can directly administer their instance via the final set of
APIs:

* [BucketsApi][17]: Create, manage, and delete buckets
* [OrganizaitonApi][18]: Create, manage, and delete organizations
* [UsersApi][19]: Create, manage, and delete users

[17]: https://influxdb-client.readthedocs.io/en/stable/api.html#bucketsapi
[18]: https://influxdb-client.readthedocs.io/en/stable/api.html#organizationsapi
[19]: https://influxdb-client.readthedocs.io/en/stable/api.html#usersapi

## InfluxDBClient

To use the client library at a minimum, users need to specify connection
information and import and create the client to gain access to the various
APIs.

The connection information specifies the following information:

1) **URL**: The URL of the InfluxDB instance (e.g. `http://192.168.100.10:8086`) with
  the hostname or IP address and port. Also note that if certificates are
  setup, then the user will need to also use `https://`.
2) **Access Token**: the access token TODO what is this in 2.0?
3) **Org**: the org the token has access to

This information can be specified via file, the environment, or directly in
code:

### Via Configuration File

Rather than hard-coding a token in code, users can specify the token with a
configuration file and limit what users have access to the configuration file.

The file can use an `toml` format or `ini` format. Examples of both are below:

```toml
# TOML-based config
[influx2]
    url = "http://localhost:8086"
    org = "my-org"
    token = "my-token"
```

```ini
; ini-based config
[influx2]
url = http://localhost:8086
org = my-org
token = my-token
```

Users can also specify additional configuration details like timeout and proxy
settings as well as global tags to apply to data. Check out the full list of
[configuration settings][21] including setting default tags for new data.

Then in code the user can load the file and create a client as follows:

```python
from influxdb_client import InfluxDBClient

with InfluxDBClient.from_config_file("config.toml") as client:
    # use the client to access the necessary APIs
    # for example, write data using the write_api
    with client.write_api() as writer:
        writer.write(bucket="testing", record="sensor temp=23.3")
```

[21]: https://influxdb-client.readthedocs.io/en/stable/api.html#influxdb_client.InfluxDBClient.from_config_file

### Via Environment Variables

Users can export or set any of the following environment variables:

```s
INFLUXDB_V2_URL
INFLUXDB_V2_ORG
INFLUXDB_V2_TOKEN
INFLUXDB_V2_TIMEOUT
INFLUXDB_V2_VERIFY_SSL
INFLUXDB_V2_SSL_CA_CERT
INFLUXDB_V2_CONNECTION_POOL_MAXSIZE
INFLUXDB_V2_AUTH_BASIC
INFLUXDB_V2_PROFILERS
```

Users can also set default tags to all data creating environment variables
using the prefix `INFLUXDB_V2_TAG_<name>`. For example to set a tag called
"ID", users can set `INFLUXDB_V2_TAG_ID=<id>`.

Then in code the user can create a client as follows:

```python
from influxdb_client import InfluxDBClient

with InfluxDBClient.from_env_properties() as client:
    # use the client to access the necessary APIs
    # for example, write data using the write_api
    with client.write_api() as writer:
        writer.write(bucket="testing", record="sensor temp=23.3")
```

### Via Code

The client library users can also provide the necessary information in code.
This method is discouraged as it results in a hard-coded token that exists in
code. While it is an easy way to get going, having credentials in a
configuration file is the preferred option.

```python
from influxdb_client import InfluxDBClient

url = "http://localhost:8086"
token = "my-token"
org = "my-org"

with InfluxDBClient(url, token) as client:
    # use the client to access the necessary APIs
    # for example, write data using the write_api
    with client.write_api() as writer:
        writer.write(bucket="testing", org=org, record="sensor temp=23.3")
```

Note the configs from a file and environment variables specified an
organization. That organization is used as the default for the query, write,
and delete APIs. A user can always specify a different organization to override
a set value.

## WriteApi

Users can create a client and write the data API with only three lines of code:

```python
from influxdb_client import InfluxDBClient

with InfluxDBClient.from_config_file("config.toml") as client:
    with client.write_api() as writer:
        write_api.write(bucket="testing", record="sensor temp=23.3")
```

By default, the client will attempt to send data in batches of 1,000 every
second. If an error is hit the client retries after five seconds and uses
exponential backoff for additional errors up to 125 seconds between retries.
Retries are attempted five times or up to 180 seconds of waiting.

Users are free to modify any of these settings by setting the write_options
value when creating a write_api object. The time-based options are in
milliseconds.

```python
with client.write_api(
    write_options=WriteOptions(
        batch_size=500,
        flush_interval=10_000,
        jitter_interval=2_000,
        retry_interval=5_000,
        max_retries=5,
        max_retry_delay=30_000,
        exponential_base=2
    )
) as write_client:
```

## Preparing Data

InfluxDB uses [line protocol format][31], which is made up for a measurement
name and fields, as well as optional tags and timestamps. The client libraries
allow for specifying data in several different ways and users are free to
use which ever option works best for the data format getting imported!

[31]: https://docs.influxdata.com/influxdb/cloud/reference/syntax/line-protocol/

### String

The first option is a string containing line protocol format. This demonstrates
one option if a user is reading influx line protocol directly from a file or
wants to build data strings when using the data with Python.

```python
records = """cpu,core=0 temp=25.3 1657729063\n
cpu,core=0 temp=25.4 1657729078\n
cpu,core=0 temp=25.2 1657729093\n
"""
```

### Dictionary

The second option uses a dictionary that specifies the various parts of line
protocol format. This option might be best for users who are parsing a file and
building their data points at the same time.

```python
records = [
    {
        "measurement": "cpu",
        "tags": {"core": "0"},
        "fields": {"temp": 25.3},
        "time": 1657729063
    },
    {
        "measurement": "cpu",
        "tags": {"core": "0"},
        "fields": {"temp": 25.4},
        "time": 1657729078
    },
    {
        "measurement": "cpu",
        "tags": {"core": "0"},
        "fields": {"temp": 25.2},
        "time": 1657729093
    },
]
```

### Point Helper Class

The client library comes with a [`Point`][32] class that allows users to easily
build measurements.

```python
from influxdb_client import Point

records = [
    Point("cpu").tag("core", "0").field("temp", 25.3).time(1657729063),
    Point("cpu").tag("core", "0").field("temp", 25.4).time(1657729078),
    Point("cpu").tag("core", "0").field("temp", 25.2).time(1657729093),
]
```

[32]: https://influxdb-client.readthedocs.io/en/stable/api.html#influxdb_client.client.write.point.Point

### Data Class

```python
@dataclass
class CPU:
    core: str
    temp: float
    timestamp: int

records = [
  CPU("0", 25.3, 1657729063),
  CPU("0", 25.4, 1657729078),
  CPU("0", 25.2, 1657729093),
]

    write_api.write(
      bucket="testing",
      record=records,
      record_measurement_name="cpu",
      record_tag_keys=["core"],
      record_field_keys=["temp"],
      record_time_key="timestamp",
    )

```

### Named Tuple

```python
from collections import namedtuple

class CPU:
    def __init__(self, core, temp, timestamp):
        self.core = core
        self.temp = temp
        self.timestamp = timestamp

record = namedtuple("CPU", [core, temp, timestamp])

records = [
  record("0", 25.3, 1657729063),
  record("0", 25.4, 1657729078),
  record("0", 25.2, 1657729093),
]

    write_api.write(
      bucket="testing",
      record=records,
      record_measurement_key="cpu",
      record_tag_keys=["core"],
      record_field_keys=["temp"]
      record_time_key="timestamp",
    )
```

### Panda's Data Frame

Finally, users can use Panda’s Data frames.

```python
import pandas as pd


records = pd.DataFrame(
  data=[
    ["0", 25.3, 1657729063],
    ["0", 25.4, 1657729078],
    ["0", 25.2, 1657729093],
  ],
  columns=["core", "temp", "timestmap"]
)

    write_api.write(
      bucket="testing",
      record=records,
      record_measurement_key="cpu",
      record_tag_keys=["core"],
      record_field_keys=["temp"]
      record_time_key="timestamp",
    )
```

Mote there are many, many ways to create Panda's DataFrames and this is only
one example. Consult the Panda's docs for more examples.

## Use the Python Client Library Today!

TODO
