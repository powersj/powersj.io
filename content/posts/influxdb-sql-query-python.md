---
title: "InfluxDB SQL Queries with Python "
date: 2023-02-21
tags: ["influxdata"]
draft: false
aliases:
  - /post/influxdb-sql-query-python/
---

***This is a copy of a [blog post][1] I wrote originally posted on [InfluxData.com][2]***

[1]: https://www.influxdata.com/blog/influxdb-sql-queries-python/
[2]: https://www.influxdata.com/

Recently InfluxData announced [SQL support in InfluxDB Cloud][3], powered by
IOx. Users can now use familiar SQL queries to explore and analyze their time
series data. The SQL support was introduced along with the usage of
[Apache Arrow][4].

[3]: https://www.influxdata.com/products/sql/
[4]: https://arrow.apache.org/

Apache Arrow is an open source project used as the foundation of InfluxDB’s
SQL support. Arrow provides the data representation, storage format, query
processing, and network transport layers. [Apache Flight SQL][5] provides a
method for interacting with Arrow via SQL.

[5]: https://arrow.apache.org/blog/2022/02/16/introducing-arrow-flight-sql/

The [Flight SQL DB API][6] library provides a seamless user experience for
users interacting with Apache Flight SQL in Python. This library can be used
directly with InfluxDB with SQL support.

[6]: https://github.com/influxdata/flightsql-dbapi

The following will demonstrate an end-to-end example of using the library with
InfluxDB Cloud, powered by IOx. Users who need to execute other operations,
like inserting data, querying with Flux, or any other API requests, can
continue to use the existing [influxdb-client-python client library][7].

[7]: https://github.com/influxdata/influxdb-client-python

## Install the library

The library is published on [PyPI][8] in order to make it easy to install:

```bash
pip install flightsql-dbapi
```

To use the library, users need to import the `FlightSQLClient` in their code:

```bash
from flightsql import FlightSQLClient
```

[8]: https://pypi.org/project/flightsql-dbapi/

## Connecting to InfluxDB Cloud

To create a client for interacting with InfluxDB, users need to provide three
pieces of information:

* **host**: The hostname of the InfluxDB Cloud instance — note that this does
  not require a protocol (e.g. “https://”) or a port (e.g. 8086). The
  underlying library builds the full connection string.
* **token**: This is the InfluxDB token string with access to the bucket.
* **bucket**: In the client metadata, users need to provide what InfluxDB
  bucket to use with the connection; each connection then belongs to a specific
  bucket.

Below is an example of this connection process, where a user connects to
InfluxDB Cloud and uses a token from the environment called “INFLUX_TOKEN” to
connect to the “telegraf-monitoring” bucket:

```python
client = FlightSQLClient(
    host="us-east-1-1.aws.cloud2.influxdata.com",
    token=os.environ["INFLUX_TOKEN"],
    metadata={"bucket-name": "telegraf-monitoring"},
)
```

From here users can use the returned client to interact with InfluxDB’s SQL
support. For example, a user could execute queries on, or query information
about the bucket’s tables and schema.

## Executing a query

Passing a query to the client is a straightforward process of passing the SQL
query string to the `execute()` function. However, the following step is unique
to Flight SQL, which requires gathering a ticket from an endpoint:

```python
info = client.execute("select * from cpu limit 10")
reader = client.do_get(info.endpoints[0].ticket)
```

In Apache Flight SQL, once a query is passed to the server, the server returns
a FlightInfo object. The object contains a list of endpoints describing
locations containing the query result. In the case of InfluxDB Cloud, there
will only be a single endpoint. The client can then gather the query result
from the information provided by the single endpoint’s ticket.

## Query result handling

The response from the client is of the type [FlightStreamReader][9]. This
allows the user to stream the data to avoid filling up memory and to be more
efficient:

```python
for batch in reader:
    print(batch)
```

If the user only has a limited number of results from the query, they can use
the `read_all()` function to collect all data chunks into a Table:

```python
data = reader.read_all()
```

The return value from this is a [PyArrow Table][10]. These tables are groups of
arrays representing columns of data in tabular form. The table provides a huge
number of performant operations and abilities to convert to other data types.

For example, a user can convert the table directly into a
[Pandas DataFrame][11]. This allows users to quickly manipulate, transform, and
analyze their data using the powerful Pandas library:

```python
reader.read_all().to_pandas()
```

Users of the [Polars][12] library can also take advantage of Arrow support
directly. A user can create a [Polars DataFrame][13] directly from the
resulting Arrow Table:

```python
polars.from_table(reader.read_all())
```

[9]: https://arrow.apache.org/docs/python/generated/pyarrow.flight.FlightStreamReader.html
[10]: https://arrow.apache.org/docs/python/generated/pyarrow.Table.html
[11]: https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.html
[12]: https://github.com/pola-rs/polars
[13]: https://pola-rs.github.io/polars/py-polars/html/reference/api/polars.from_arrow.html#polars-from-arrow

## Schemas and tables

When working with SQL it is helpful to know what schema or tables are
available. To find that information when working with InfluxDB Cloud, users can
use the following scripts to gather the tables:

```python
info = client.tables()
tables = client.do_get(info.endpoints[0].ticket).read_all()
```

Or the following for the full schema:

```python
info = client.get_db_schemas()
schema = client.do_get(info.endpoints[0].ticket).read_all()
```

As the table and schema information is relatively small, using `read_all()`
here gets the user the data immediately.

## Try out SQL with InfluxDB and Python today

This post demonstrated how users could take advantage of the Python Flight SQL
library to connect and retrieve data from InfluxDB Cloud, powered by IOx. Users
can now take advantage of familiar SQL queries with the leading time-series
database and report out using Python.

Consider where you can use [InfluxDB Cloud][14] with SQL support and the
[Python Flight SQL library][15] and give it a shot today!

[14]: https://www.influxdata.com/influxcloud-trial
[15]: https://github.com/influxdata/flightsql-dbapi
