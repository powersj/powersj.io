---
title: "InfluxDB Python Client Library: A Deep Dive into the WriteAPI"
date: 2022-08-19
tags: ["influxdata"]
draft: false
aliases:
  - /post/influxdb-client-library-python-write-api-deep-dive/
---

[InfluxDB][1] is an open-source time series database. Built to handle enormous
volumes of time-stamped data produced from IoT devices to enterprise
applications. As data sources for InfluxDB can exist in many different
situations and scenarios, providing different ways to get data into InfluxDB is
essential.

The [InfluxDB Client libraries][2] are language-specific packages that
integrate with the InfluxDB v2 API. These libraries give users a powerful
method of sending, querying, and managing InfluxDB. Check out this [TL;DR][3]
for an excellent overview of the client libraries. The libraries are available
in many languages, including [Python][4], [JavaScript][5], [Go][6], [C#][7],
[Java][8], and many others.

This post will walk users through obtaining the Python client library and API
structure and demonstrate how to connect, write, and prepare data with Python!
Python has seen immense growth and adoption by developers due to its ease of
learning and use.

[1]: https://www.influxdata.com/
[2]: https://docs.influxdata.com/influxdb/cloud/api-guide/client-libraries/
[3]: https://www.influxdata.com/blog/tldr-influxdb-client-libraries/
[3]: https://www.influxdata.com/blog/tldr-influxdb-client-libraries/
[4]: https://docs.influxdata.com/influxdb/cloud/api-guide/client-libraries/python/
[5]: https://docs.influxdata.com/influxdb/cloud/api-guide/client-libraries/browserjs/
[6]: https://docs.influxdata.com/influxdb/cloud/api-guide/client-libraries/go/
[7]: https://github.com/influxdata/influxdb-client-csharp
[8]: https://github.com/influxdata/influxdb-client-java

## Getting Started

### Download

The InfluxDB Python client library is available directly from [PyPI][10] for
easy installs with pip or as a dependency in a project:

```bash
pip install influxdb-client
```

The InfluxDB Python client library supports InfluxDB Cloud, InfluxDB 2.x,
and InfluxDB 1.8. It is built and tested to support Python 3.6 and newer.

Note that the support of InfluxDB 1.8 is limited to a subset of APIs and
requires a few differences; these are called out further in this post.

[10]: https://pypi.org/project/influxdb-client/

### Package Extras

The client library is intentionally kept small in size and dependencies.
However, there are additional package extras available that users can use to
pull in other dependencies and enable some additional features:

* `influxdb-client[ciso]`: makes use of the [ciso8601][12] date time parser. It
  utilizes C-bindings, which result in faster handling of date time objects at
  the cost of requiring the use of C-bindings.
* `influxdb-client[async]`: as the name implies, this allows for the use and
  benefit of asynchronous requests with the client library if the user's tools
  use the async and await Python commands.
* `influxdb-client[extras]`: adds the ability to use [Pandas][13]
  [DataFrames][14]. The Pandas library is a commonly used data analysis tool.
  These additional dependencies are large in size and not always needed;
  therefore, it was included as a separate extra package.

[12]: https://github.com/closeio/ciso8601
[13]: https://pandas.pydata.org/
[14]: https://pandas.pydata.org/pandas-docs/stable/user_guide/dsintro.html#dataframe

### API & Documentation

The client library API and documentation are available on [Read the Docs][11].

[11]: https://influxdb-client.readthedocs.io/en/stable/

### Source

If a user wants to build or use the library from the source, it is available on
[GitHub][15]:

```bash
git clone https://github.com/influxdata/influxdb-client-python
```

[15]: https://github.com/influxdata/influxdb-client-python

## API overview

At a high level, the API consists of a client, providing access to various APIs
exposed by InfluxDB for a specific instance.

The [InfluxDBClient][20] is used to handle authentication parameters and
connect to InfluxDB. There are several different ways to specify the
parameters, which the following section will demonstrate.

[20]: https://influxdb-client.readthedocs.io/en/stable/api.html#influxdbclient

### InfluxDB fundamentals

Once connected, there are three APIs that handle fundamental interactions with
InfluxDB:

* [WriteApi][21]: write time series data to InfluxDB
* [QueryApi][22]: query InfluxDB using Flux, InfluxDB's functional data
  scripting language
* [DeleteApi][23]: delete time series data in InfluxDB

[21]: https://influxdb-client.readthedocs.io/en/stable/api.html#writeapi
[22]: https://influxdb-client.readthedocs.io/en/stable/api.html#queryapi
[23]: https://influxdb-client.readthedocs.io/en/stable/api.html#deleteapi

### Tasks & scripts

Users can also use the client library to create tasks, invocable scripts, and
labels:

* [TasksApi][24]: Use tasks (scheduled Flux queries) to input a data stream and
  then analyze, modify, and act on the data accordingly
* [InvokableScriptsApi][25]: Create custom InfluxDB API endpoints that
  query, process, and shape data. To learn more about how Invokable Scripts can
  empower a user, check out this [TL;DR][26] for more details!

[24]: https://influxdb-client.readthedocs.io/en/stable/api.html#tasksapi
[25]: https://influxdb-client.readthedocs.io/en/stable/api.html#invokablescriptsapi
[26]: https://www.influxdata.com/blog/tldr-influxdb-tech-tips-api-invokable-scripts-influxdb-cloud/

### InfluxDB administration
Finally, users can directly administer their instance via the final set of
APIs:

* [BucketsApi][27]: Create, manage, and delete buckets
* [OrganizationApi][28]: Create, manage, and delete organizations
* [UsersApi][29]: Create, manage, and delete users
* [LabelsApi][30]: Add visual metadata to dashboards, tasks, and other items in
  the InfluxDB UI

[27]: https://influxdb-client.readthedocs.io/en/stable/api.html#bucketsapi
[28]: https://influxdb-client.readthedocs.io/en/stable/api.html#organizationsapi
[29]: https://influxdb-client.readthedocs.io/en/stable/api.html#usersapi
[30]: https://influxdb-client.readthedocs.io/en/stable/api.html#labelsapi

Also check out the [InfluxData Meet the Developer videos][31] for more guided steps
to using these APIs!

[31]: https://www.youtube.com/playlist?list=PLYt2jfZorkDoqh4Y_Kzs_D_WfiafmOLQ-

## InfluxDBClient Setup

The user first needs to create a client to gain access to the various APIs. The
client requires connection information, which is comprised of the following:

1) **URL**: URL of the InfluxDB instance (e.g.,
  `http://192.168.100.10:8086`) with the hostname or IP address and port. Also,
  note that if secure HTTP is set up on the server, the user will need to use
  the `https://` protocol.
2) **Access Token**: the access token to authenticate to InfluxDB. If using
  InfluxDB 1.8, usernames and passwords are used instead of tokens. Set the
  token parameter using the format `username:password`.
3) **Org**: the org the token has access to. In InfluxDB 1.8, there is no
  concept of organization. The org parameter is ignored and can be left empty.

The above connection information can be specified via file, the environment, or
in code.

### Via Configuration File

Rather than hard-coding a token in code, users can specify the token with a
configuration file and limit what users have access to the configuration file.

The file can use a `toml` or `ini` format. Examples of both are below:

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

Users can also specify additional configuration details like timeout, proxy
settings, and global tags to apply to data. Check out the entire
[configuration settings list][32], including default tags for new data.

Then in code, the user can load the file and create a client as follows:

```python
from influxdb_client import InfluxDBClient

with InfluxDBClient.from_config_file("config.toml") as client:
    # use the client to access the necessary APIs
    # for example, write data using the write_api
    with client.write_api() as writer:
        writer.write(bucket="testing", record="sensor temp=23.3")
```

[32]: https://influxdb-client.readthedocs.io/en/stable/api.html#influxdb_client.InfluxDBClient.from_config_file

### Via Environment Variables

Users can export or set any of the following environment variables:

```bash
INFLUXDB_V2_URL="http://localhost:8086"
INFLUXDB_V2_ORG="my-org"
INFLUXDB_V2_TOKEN="my-token"
```

See the docs for a complete list of [recognized environment variables][33],
including setting default tags for new data.

Then in code, the user can create a client as follows:

```python
from influxdb_client import InfluxDBClient

with InfluxDBClient.from_env_properties() as client:
    # use the client to access the necessary APIs
    # for example, write data using the write_api
    with client.write_api() as writer:
        writer.write(bucket="testing", record="sensor temp=23.3")
```

[33]: https://influxdb-client.readthedocs.io/en/stable/api.html#influxdb_client.InfluxDBClient.from_env_properties

### Via Code

The client library users can also provide the necessary information in code.
This method is discouraged as it results in a hard-coded token that exists in
code. While it is easy to get going, having credentials in a configuration file
is the preferred option.

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

Note the configurations set using a file or environment variables specified an
organization. That organization is the default for the query, write, and delete
APIs. Users can also specify a different organization to override a set value
when making a query, writing, or deleting.

The docs list out the additional [possible parameters][34] when creating the
client.

[34]: https://influxdb-client.readthedocs.io/en/stable/api.html#influxdb_client.InfluxDBClient

## Write data with the WriteApi

Once a client is created, users then have access to use the various APIs. The
following will demonstrate the write query API to send data to InfluxDB.

### Batches

By default, the client will attempt to send data in batches of 1,000 every
second:

```python
from influxdb_client import InfluxDBClient

with InfluxDBClient.from_config_file("config.toml") as client:
    with client.write_api() as writer:
        writer.write(bucket="testing", record="sensor temp=23.3")
```

If an error is hit, the client retries after five seconds and uses exponential
back-off for additional errors up to 125 seconds between retries. Retries are
attempted five times or up to 180 seconds of waiting, whichever happens first.

Users are free to modify any of these settings by setting the
[write_options][40] value when creating a write_api object. The time-based
options are in milliseconds.

```python
from influxdb_client import InfluxDBClient, WriteOptions

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
        writer.write(bucket="testing", record="sensor temp=23.3")
```

[40]: https://influxdb-client.readthedocs.io/en/stable/usage.html?highlight=max_retry_delay#batching

### Synchronous

While this is not the default method for writing data, synchronous writes are
the suggested method of writing data. This method makes it easier to catch
errors and respond to them. Additionally, users can still break up their data
into batches either manually or using a library like Rx to get similar behavior
to the batch writes.

```python
from influxdb_client import InfluxDBClient
from influxdb_client.client.write_api import SYNCHRONOUS

with InfluxDBClient.from_config_file("config.toml") as client:
    with client.write_api(write_options=SYNCHRONOUS) as writer:
        writer.write(bucket="testing", record="sensor temp=23.3")
```

### Asynchronous

If a user does not want to block their application while data is sent to InfluxDB, then the asynchronous client and write APIs are available. Keep in mind that using the asynchronous requires the additional dependencies included with the `influxdb-client[async]` package extra and the special async client with access to a different API as well:

```python
import asyncio

from influxdb_client.client.influxdb_client_async import InfluxDBClientAsync


async def main():
    async with InfluxDBClientAsync(
        url="http://localhost:8086", token="my-token", org="my-org"
    ) as client:
        await client.write_api().write(bucket="my-bucket", record="sensor temp=23.3")


if __name__ == "__main__":
    asyncio.run(main())
```

## Different methods to prepare your data

InfluxDB uses [line protocol format][50], which is made up of a measurement
name and fields, as well as optional tags and timestamps. The client libraries
allow for specifying data in several different ways, and users can use
whichever option works best for the data format getting imported!

[50]: https://docs.influxdata.com/influxdb/cloud/reference/syntax/line-protocol/

### String

The first option is a string containing line protocol format. This demonstrates
one option if a user is reading influx line protocol directly from a file or
wants to build data strings when using the data with Python.

```python
records = """
cpu,core=0 temp=25.3 1657729063
cpu,core=0 temp=25.4 1657729078
cpu,core=0 temp=25.2 1657729093
"""
```

The new line character must separate each entry in line protocol. Entries that
end up on the same line without a `\n` between them will result in an error in
parsing the data.

### Dictionary

The second option uses a dictionary that specifies the various parts of the
line protocol format. This option might be best for users who are parsing a
file and building their data points at the same time.

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

The client library has a [`Point`][51] class that allows users to build
measurements easily. This class helps users format the data into the various
parts of line protocol, ensuring properly serialized data. The tag and field
are repeatable, allowing for adding many tags and fields at once.

```python
from influxdb_client import Point

records = [
    Point("cpu").tag("core", "0").field("temp", 25.3).time(1657729063),
    Point("cpu").tag("core", "0").field("temp", 25.4).time(1657729078),
    Point("cpu").tag("core", "0").field("temp", 25.2).time(1657729093),
]
```

[51]: https://influxdb-client.readthedocs.io/en/stable/api.html#influxdb_client.client.write.point.Point

### Pandas DataFrame

Finally, users can pass [Pandas DataFrames][55] directly in when the
`influxdb-client-python[extras]` extras package is installed. Users can pass a
data frame directly in and specify which columns to use as tags and the
measurement name.

```python
import pandas as pd

from influxdb_client import InfluxDBClient

records = pd.DataFrame(
    data=[
        ["0", 25.3, 1657729063],
        ["0", 25.4, 1657729078],
        ["0", 25.2, 1657729093],
    ],
    columns=["core", "temp", "timestamp"],
)

with InfluxDBClient.from_config_file("config.toml") as client:
    with client.write_api() as writer:
        writer.write(
            bucket="testing",
            record=records,
            data_frame_measurement_name="cpu",
            data_frame_tag_columns=["core"],
        )
```

Note there are many ways to create Pandas DataFrames, and this is only one
example. Consult Pandas [DataFrame docs][56] for more examples.

[55]: https://pandas.pydata.org/pandas-docs/stable/user_guide/dsintro.html#dataframe
[56]: https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.html

### Data Class

Users who take advantage of Python's [Data Classes][52] can pass them directly
in and then specify which attributes to use for the tags, fields, and
timestamp when passing data. Data classes were first made available in Python
3.7 via [PEP 557][53].

```python
from dataclasses import dataclass

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
        writer.write(
            bucket="testing",
            record=records,
            record_measurement_name="cpu",
            record_tag_keys=["core"],
            record_field_keys=["temp"],
            record_time_key="timestamp",
        )
```

[52]: https://docs.python.org/3/library/dataclasses.html
[53]: https://peps.python.org/pep-0557/

### Named Tuple

[Named Tuples][54] assign meaning to each position in a tuple allowing for
more readable, self-documenting code. Users can pass a named tuple directly in
and then specify which tuple field name should be used as tags, fields, and
timestamp.

```python
from collections import namedtuple

from influxdb_client import InfluxDBClient


class CPU:
    def __init__(self, core, temp, timestamp):
        self.core = core
        self.temp = temp
        self.timestamp = timestamp


record = namedtuple("CPU", ["core", "temp", "timestamp"])

records = [
    record("0", 25.3, 1657729063),
    record("0", 25.4, 1657729078),
    record("0", 25.2, 1657729093),
]

with InfluxDBClient.from_config_file("config.toml") as client:
    with client.write_api() as writer:
        writer.write(
            bucket="testing",
            record=records,
            record_measurement_name="cpu",
            record_tag_keys=["core"],
            record_field_keys=["temp"],
            record_time_key="timestamp",
        )
```

[54]: https://docs.python.org/library/collections.html#collections.namedtuple

## Check out the Python Client Library Today

This post has shown how quick, easy, and flexible the
[Python InfluxDB client][60] library is to use. While the above only
demonstrated the write API, it starts to demonstrate the great power users can
have when interacting with InfluxDB. Combined with the other APIs, users have
even more options and potential.

Consider where you might be able to use [InfluxDB][61] and the
[client libraries][62] and give them a shot today!

[60]: https://github.com/influxdata/influxdb-client-python
[61]: https://www.influxdata.com/
[62]: https://docs.influxdata.com/influxdb/cloud/api-guide/client-libraries/
