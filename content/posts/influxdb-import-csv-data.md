---
title: "Import CSV Data into InfluxDB Using the Influx CLI and Python and Java Client Libraries"
date: 2022-10-25
tags: ["influxdata"]
draft: false
aliases:
  - /post/influxdb-import-csv-data/
---

***This is a copy of a [blog post][1] I wrote originally posted on [InfluxData.com][2]***

[1]: https://www.influxdata.com/blog/import-csv-data-influxdb-using-influx-cli-python-java-client-libraries/
[2]: https://www.influxdata.com/

With billions of devices and applications producing time series data every
nanosecond, InfluxDB is the leading way to store and analyze this data. With
the enormous variety of data sources, InfluxDB provides multiple ways for users
to get data into InfluxDB. One of the most common data formats of this data is
CSV, comma-separated values.

This blog post demonstrates how to take CSV data, translate it into line
protocol, and send it to InfluxDB using the InfluxDB CLI and InfluxDB Client
libraries.

## What are CSV and Line Protocol?

CSV is data delimited by a comma to separate values. Each row is a different
record, where the record consists of one or more fields. CSV data is
historically used for exporting data or recording events over time, which makes
it a great fit for a time series database like InfluxDB.

Here is a basic example of CSV data. It starts with a header that provides the
names of each column, followed by each record in a separate row:

```s
name,building,temperature,humidity,time
iot-devices,5a,72.3,34.1,2022-10-01T12:01:00Z
iot-devices,5a,72.1,33.8,2022-10-02T12:01:00Z
iot-devices,5a,72.2,33.7,2022-10-03T12:01:00Z
```

To get this data into InfluxDB, the following tools show how to translate these
rows into line protocol. Line protocol consists of the following items:

* Measurement name: the name data to store and later query
* Fields: The actual data that will be queried
* Tags: optional string fields that are used to index and help filter data
* Timestamp: optional, but very common in CSV data to specify when the data
  record was collected or produced

Using the CSV example above, the goal state is to translate the data into
something like the following line protocol:

```s
iot-devices,building=5a temperature=72.3,humidity=34.1 1664647260000000000
iot-devices,building=5a temperature=72.1,humidity=33.8 1664733660000000000
iot-devices,building=5a temperature=72.2,humidity=33.7 1664820060000000000
```

In the above, the `iot-devices` are the measurement name, and the building is a
tag. The temperature and humidity values are our fields. Finally, the timestamp
is saved as a nanosecond precision UNIX timestamp.

## Influx CLI

The Influx CLI tool provides commands to manage and interact with InfluxDB.
With this tool, users can set up, configure, and interact with many of the
capabilities of InfluxDB. From setting up new buckets and orgs to querying
data, to even pushing data, the CLI can do it all.

One of the subcommands users can use is the `write` command. Write allows users
to inject data directly into InfluxDB from annotated CSV.

### CSV annotations

Annotations, either in the CSV file itself or provided as CLI options, are
properties of the columns in the CSV file. They describe how to translate each
column into either a measurement name, tag, field, or timestamp.

The following demonstrates adding annotations to our example data to a file:

```csv
#datatype measurement,tag,double,double,dateTime:RFC3339
name,building,temperature,humidity,time
iot-devices,5a,72.3,34.1,2022-10-01T12:01:00Z
iot-devices,5a,72.1,33.8,2022-10-02T12:01:00Z
iot-devices,5a,72.2,33.7,2022-10-03T12:01:00Z
```

The data types in this example are specified as follows:

* `measurement`: states which column to use as the measurement name. If no column
  exists, this can also be specified as a header via the CLI.
* `tag`: specifies which column or columns are to be treated as string tag data.
  These are optional, but help with querying and indexing data in InfluxDB.
* `double`: is used on two columns to specify that they contain double data types.
* `dateTime`: specifies that the final column contains the timestamp of the
  record and goes further to state that the format used is RFC3339.

Users can also specify [additional data types][20] for fields:

* `double`
* `long`
* `unsignedLong`
* `boolean`
* `string`
* `ignored`: used if a column is not useful or required, and this will not include the column in the final data

Finally, for [timestamps][21], there are built-in parsing capabilities for:

* RFC3339 (e.g. `2020-01-01T00:00:00Z`)
* RFC3339Nano (e.g. `2020-01-01T00:00:00.000000000Z`)
* Unix timestamps (e.g. `1577836800000000000`)

If the timestamp is not in one of these formats, then users need to specify the
format of the timestamp themselves (e.g. `dateTime:2006-01-02`) as part of the
annotation using [Go reference time][22].

[20]: https://docs.influxdata.com/influxdb/cloud/reference/syntax/annotated-csv/extended/#datatype
[21]: https://docs.influxdata.com/influxdb/cloud/reference/syntax/annotated-csv/extended/#datetime
[22]: https://pkg.go.dev/time#pkg-constants

### CLI examples

Once annotations exist, it is time to send the data to InfluxDB using the CLI.
Below is an example of sending the data contained in a file:

```bash
influx write --bucket bucketName --format=csv --file /path/to/data.csv
```

If the CSV itself does not have the annotations, then a user can add them as
part of the CLI command:

```bash
influx write --bucket bucketName --format=csv --file /path/to/data.csv \
    --header "#datatype measurement,tag,double,double,dateTime:RFC3339"
```

Finally, if a CSV file does not have a relevant column for the measurement
name, that too can be included as a header:

```bash
influx write --bucket bucketName --format=csv --file /path/to/data.csv \
    --header "#constant measurement,iot-devices"
    --header "#datatype tag,double,double,dateTime:RFC3339"
```

To get started with the Influx CLI tool, visit the [docs site][23] where users
can find steps to install and get started with it. Check out the
[Write CSV data to InfluxDB][24] docs for more details and examples. This
includes examples with skipper header rows, different encodings, and error
handling. Additionally, see this [previous blog post][25] to learn more about
annotated CSV and how you can write the data directly with [Flux queries][26].

The Influx CLI provides a simple and fast way to get started, but what if the user’s files are much larger, not annotated, or need to have some preprocessing done to them before pushing to InfluxDB? In these scenarios, users should look to the InfluxDB Client Libraries.

[23]: https://docs.influxdata.com/influxdb/cloud/tools/influx-cli/
[24]: https://docs.influxdata.com/influxdb/cloud/write-data/developer-tools/csv/
[25]: https://www.influxdata.com/blog/tldr-tech-tips-how-to-interpret-an-annotated-csv/
[26]: https://www.influxdata.com/products/flux/

## InfluxDB Client Libraries

The [InfluxDB Client Libraries][30] provide language-specific packages to
interact with the InfluxDB v2 API quickly. This allows users to use a
programming language of their choice to create, process, and package data
quickly and easily and then send it to InfluxDB. The libraries are available
in many languages, including [Python][31], [JavaScript][32], [Go][33],
[C#][34], [Java][35], and many others.

The following provides two examples of parsing CSV data with Python and Java and then sending that data to InfluxDB.

[30]: https://www.influxdata.com/products/data-collection/influxdb-client-libraries/
[31]: https://github.com/influxdata/influxdb-client-python
[32]: https://github.com/influxdata/influxdb-client-js
[33]: https://github.com/influxdata/influxdb-client-go
[34]: https://github.com/influxdata/influxdb-client-csharp
[35]: https://github.com/influxdata/influxdb-client-java

### Python + Pandas

The [Python][36] programming language has enabled many to learn and start
programming easily. [Pandas][37], a Python data analysis library, is a fast and
powerful tool for data analysis and manipulation. Together the two make for a
powerful combination to easily process data to send to InfluxDB with the
InfluxDB client library.

If a user has a very large CSV file or files they want to push to InfluxDB,
Pandas provides an easy way to read a CSV file with headers quickly. Combined
with the built-in functionality of the InfluxDB client libraries to write
[Pandas DataFrames][38], a user can read a CSV in chunks and then send those
chunks into InfluxDB.

In the following example, a user is reading a CSV containing thousands of rows
containing VIX stock data:

[36]: https://www.python.org/
[37]: https://pandas.pydata.org/
[38]: https://youtu.be/cMkQXLCbFQY

```s
symbol,open,high,low,close,timestamp
vix,13.290000,13.910000,13.290000,13.570000,135935640000000000
vix,13.870000,13.880000,13.040000,13.310000,135944280000000000
vix,13.640000,14.330000,13.600000,14.320000,135952920000000000
```

To avoid reading the entire file into memory, the user can take advantage of
Pandas’ `read_csv` function, which will read the column names based on the CSV
header and chunk the file into 1,000-row chunks. Finally, use the InfluxDB
client library to send those groups of 1,000 rows to InfluxDB after specifying
the measurement, tag, and timestamp columns:

```python
from influxdb_client import InfluxDBClient, WriteOptions
import pandas as pd

with InfluxDBClient.from_env_properties() as client:
    for df in pd.read_csv("vix.csv", chunksize=1_000):
        with client.write_api() as write_api:
            try:
                write_api.write(
                    record=df,
                    bucket="my-bucket",
                    data_frame_measurement_name="stocks",
                    data_frame_tag_columns=["symbol"],
                    data_frame_timestamp_column="date",
                )
            except InfluxDBError as e:
                print(e)
```

### Java

The Java programming language sees use from a wide range of sources from
Android devices to enterprise applications. Java users can look to
[opencsv][40] to get started quickly with CSV data parsing.

This example makes use of a plain old Java object (aka POJO) along with
annotations to tell opencsv which CSV columns belong to what object variable
and the InfluxDB client library what the measurement name should be for the
class as well as what variables should become tags, fields, or timestamps.

[40]: https://opencsv.sourceforge.net/

```java
@Measurement(name = "stock")
public class StockData {
    @Column(tag = true)
    @CsvBindByName(column = "symbol")
    private String symbol;

    @Column
    @CsvBindByName(column = "open")
    private String open;

    @Column
    @CsvBindByName(column = "high")
    private String high;

    @Column
    @CsvBindByName(column = "low")
    private String low;

    @Column
    @CsvBindByName(column = "close")
    private String close;

    @Column(timestamp = true)
    @CsvBindByName(column = "timestamp")
    private String timestamp;
}
```

Then a user can iterate through a CSV file and create a `StockData` object for
each line. This variable can then be manipulated, if required, before sending
it to InfluxDB:

```java
InfluxDBClient influxDBClient = InfluxDBClientFactory.create();
WriteApi writeApi = influxDBClient.getWriteApi();

FileReader reader = new FileReader("vix.csv");
CsvToBean"StockData" csvToBean = new CsvToBeanBuilder(reader)
	.withType(StockData.class)
	.build();

Iterator"StockData" stockIterator = csvToBean.iterator();
while (stockIterator.hasNext()) {
	StockData data = stockIterator.next();
	writeApi.writeMeasurement(WritePrecision.S, data);
}

influxDBClient.close();
```

## Check out the InfluxDB CLI & Client Libraries today

This post has shown how quick, easy, and flexible the InfluxDB client libraries
are to use. While the above only demonstrates CSV data, it starts to
demonstrate the great power users can have when sending data to InfluxDB.
Combined with the other APIs, users have even more options and potential.

Consider where you might be able to use [InfluxDB][50], [Influx CLI][51], and
the [client libraries][52], and give them a shot today!

[50]: https://www.influxdata.com/
[51]: https://docs.influxdata.com/influxdb/cloud/tools/influx-cli/
[52]: https://docs.influxdata.com/influxdb/cloud/api-guide/client-libraries/
