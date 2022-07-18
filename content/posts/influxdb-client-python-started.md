---
title: "Getting started with the InfluxDB Python Client Library"
date: 2022-07-17
tags: ["influxdata"]
draft: true
aliases:
  - /post/influxdb-client-library-python-getting-started/
---

TODO: intro

* get the library
* API structure
* creating a client
* writing
* data

## Getting Started

The InfluxDB Python client library supports InfluxDB 2.x, InfluxDB Cloud,
as well as InfluxDB 1.8 and newer versions. It is built and tested to support
Python 3.6 and newer.

Note that the support of InfluxDB 1.8 is limited to a subset of APIs and
requires a few differences creating the client connection. These are called
out further in this post.

### Download

The InfluxDB Python client library is available directly from [PyPI][1] for
easy installs directly with pip or as a dependency in a project:

```bash
pip install influxdb-client
```

[1]: https://pypi.org/project/influxdb-client/

### API & Documentation

The client library API and documentation is available on [Read the Docs][2].

[2]: https://influxdb-client.readthedocs.io/en/stable/

### Package Extras

The library is kept small, however, there are three package extras available
that users can use to pull in additional dependencies:

* `influxdb-client[ciso]`: makes use of the [ciso8601][3] date time parser. It
  utilizes C-bindings, which result in faster handling of date time objects at
  the cost of requiring the use of C-bindings.
* `influxdb-client[async]`: as the name implies, this allows for the use of
  asynchronous requests with the client library if the user's tools make use of
  the async and await Python commands.
* `influxdb-client[extras]`: adds special support to make use of [Pandas][4]
  [data frames][5]. The Pandas library is a commonly used data analysis tool.
  These additional dependencies are large and not always needed, therefore it
  was included as a separate extra package.

[3]: https://github.com/closeio/ciso8601
[4]: https://pandas.pydata.org/
[5]: https://pandas.pydata.org/pandas-docs/stable/user_guide/dsintro.html#dataframe

### Source

If a user wants to build or use the library from the source it is available on
[GitHub][6]:

```bash
git clone https://github.com/influxdata/influxdb-client-python
```

[6]: https://github.com/influxdata/influxdb-client-python

## API

At a high-level the API consists of a client, which then provides access to
various APIs exposed by InfluxDB for a specific instance.

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
* [LabelsApi][16]: Add visual metadata to dashboards, tasks, and other items in
  the InfluxDB UI

[14]: https://influxdb-client.readthedocs.io/en/stable/api.html#tasksapi
[15]: https://influxdb-client.readthedocs.io/en/stable/api.html#invokablescriptsapi
[16]: https://influxdb-client.readthedocs.io/en/stable/api.html#labelsapi

Finally, users can directly administer their instance via the final set of
APIs:

* [BucketsApi][17]: Create, manage, and delete buckets
* [OrganizationApi][18]: Create, manage, and delete organizations
* [UsersApi][19]: Create, manage, and delete users

[17]: https://influxdb-client.readthedocs.io/en/stable/api.html#bucketsapi
[18]: https://influxdb-client.readthedocs.io/en/stable/api.html#organizationsapi
[19]: https://influxdb-client.readthedocs.io/en/stable/api.html#usersapi

## InfluxDBClient

To use the client library at a minimum, users need to specify connection
information and create a client to gain access to the various APIs.

The connection information specifies the following information:

1) **URL**: The URL of the InfluxDB instance (e.g.
  `http://192.168.100.10:8086`) with the hostname or IP address and port. Also
  note that if certificates are setup, then the user will need to also use
  `https://`.
2) **Access Token**: the access token. If using InfluxDB 1.8, username and
  passwords are used instead of tokens. Set the token parameter using the
  format `username:password`.
3) **Org**: the org the token has access to. In InfluxDB 1.8, there is no
  concept of organization. The org parameter is ignored and can be left empty.

This information can be specified via file, the environment, or directly in
code.

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
INFLUXDB_V2_URL="http://localhost:8086"
INFLUXDB_V2_ORG="my-org"
INFLUXDB_V2_TOKEN="my-token"
```

See the docs for a full list of [recognized environment variables][22]
including setting default tags for new data.

Then in code the user can create a client as follows:

```python
from influxdb_client import InfluxDBClient

with InfluxDBClient.from_env_properties() as client:
    # use the client to access the necessary APIs
    # for example, write data using the write_api
    with client.write_api() as writer:
        writer.write(bucket="testing", record="sensor temp=23.3")
```

[22]: https://influxdb-client.readthedocs.io/en/stable/api.html#influxdb_client.InfluxDBClient.from_env_properties

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

The docs list out the additional [possible parameters][23] when creating the
client.

[23]: https://influxdb-client.readthedocs.io/en/stable/api.html#influxdb_client.InfluxDBClient

## WriteApi

Once a client is created users can start to make use of the various APIs. The
following will demonstrate the write query API to send data to InfluxDB. This
is accomplished with only a few lines of code:

```python
from influxdb_client import InfluxDBClient

with InfluxDBClient.from_config_file("config.toml") as client:
    with client.write_api() as writer:
        write_api.write(bucket="testing", record="sensor temp=23.3")
```

TODO: check this paragraph

By default, the client will attempt to send data in batches of 1,000 every
second. If an error is hit the client retries after five seconds and uses
exponential back-off for additional errors up to 125 seconds between retries.
Retries are attempted five times or up to 180 seconds of waiting.

Users are free to modify any of these settings by setting the
[write_options][30] value when creating a write_api object. The time-based
options are in milliseconds.

```python
from influxdb_client import InfluxDBClient

options = WriteOptions(
    batch_size=500,
    flush_interval=10_000,
    jitter_interval=2_000,
    retry_interval=5_000,
    max_retries=5,
    max_retry_delay=30_000,
    exponential_base=2
)

with InfluxDBClient.from_config_file("config.toml") as client:
    with client.write_api(write_options=options) as writer:
        write_api.write(bucket="testing", record="sensor temp=23.3")
```

[30]: https://influxdb-client.readthedocs.io/en/stable/usage.html?highlight=max_retry_delay#batching

## Preparing Data

InfluxDB uses [line protocol format][40], which is made up for a measurement
name and fields, as well as optional tags and timestamps. The client libraries
allow for specifying data in several different ways and users are free to
use which ever option works best for the data format getting imported!

[40]: https://docs.influxdata.com/influxdb/cloud/reference/syntax/line-protocol/

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

The client library comes with a [`Point`][41] class that allows users to easily
build measurements.

```python
from influxdb_client import Point

records = [
    Point("cpu").tag("core", "0").field("temp", 25.3).time(1657729063),
    Point("cpu").tag("core", "0").field("temp", 25.4).time(1657729078),
    Point("cpu").tag("core", "0").field("temp", 25.2).time(1657729093),
]
```

[41]: https://influxdb-client.readthedocs.io/en/stable/api.html#influxdb_client.client.write.point.Point

### Data Class

Users who take advantage of Python's [Data Classes][42] and specify which
attributes to use for the tags, fields, and timestamp when passing data. Data
classes were added in [PEP 557][43] in Python 3.7.

```python
from influxdb_client import InfluxDBClient

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

with InfluxDBClient.from_config_file("config.toml") as client:
    with client.write_api() as writer:
        write_api.write(
            bucket="testing",
            record=records,
            record_measurement_name="cpu",
            record_tag_keys=["core"],
            record_field_keys=["temp"],
            record_time_key="timestamp",
        )
```

[42]: https://docs.python.org/3/library/dataclasses.html
[43]: https://peps.python.org/pep-0557/

### Named Tuple

[Named Tuples][44] assign meaning to each position in a tuple and allow for
more readable, self-documenting code. Users can specify which tuple field name
should be used as tags, fields, and timestamp.

```python
from collections import namedtuple

from influxdb_client import InfluxDBClient

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

with InfluxDBClient.from_config_file("config.toml") as client:
    with client.write_api() as writer:
        write_api.write(
            bucket="testing",
            record=records,
            record_measurement_key="cpu",
            record_tag_keys=["core"],
            record_field_keys=["temp"]
            record_time_key="timestamp",
        )
```

[44]: https://docs.python.org/library/collections.html#collections.namedtuple

### Panda's Data Frame

Finally, users can pass [Panda’s Data frames][44] directly in when the
`influxdb-client-python[extras]` extras package is installed. Users can
specify the data frame's columns as tags, fields, and timestamp.

```python
import pandas as pd

from influxdb_client import InfluxDBClient

records = pd.DataFrame(
    data=[
        ["0", 25.3, 1657729063],
        ["0", 25.4, 1657729078],
        ["0", 25.2, 1657729093],
    ],
    columns=["core", "temp", "timestamp"]
)

with InfluxDBClient.from_config_file("config.toml") as client:
    with client.write_api() as writer:
        write_api.write(
            bucket="testing",
            record=records,
            record_measurement_key="cpu",
            record_tag_keys=["core"],
            record_field_keys=["temp"]
            record_time_key="timestamp",
        )
```

Note there are many, many ways to create Panda's DataFrames and this is only
one example. Consult the Panda's [DataFrame docs][45] for more examples.

[44]: https://pandas.pydata.org/pandas-docs/stable/user_guide/dsintro.html#dataframe
[45]: https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.html

## Use the Python Client Library Today

TODO
