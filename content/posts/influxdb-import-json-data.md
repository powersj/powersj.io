---
title: "Import JSON data into InfluxDB using the Python, Go, and JavaScript Client Libraries"
date: 2022-11-23
tags: ["influxdata"]
draft: false
aliases:
  - /post/influxdb-import-json-data/
---

***This is a copy of a [blog post][1] I wrote originally posted on [InfluxData.com][2]***

[1]: https://www.influxdata.com/blog/import-json-data-influxdb-using-python-go-javascript-client-libraries/
[2]: https://www.influxdata.com/

Devices, developers, applications, and services produce and utilize enormous
amounts of JSON data every day. A portion of this data consists of time-stamped
events or metrics that are a perfect match for storing and analyzing in
InfluxDB. To help developers build the applications of the future, InfluxDB
provides several ways to get JSON data into InfluxDB easily.

This blog post demonstrates how to take JSON data, translate it into line
protocol, and send it to InfluxDB using the InfluxDB Client libraries.

## What are JSON and line protocol?

JSON, or JavaScript Object Notation, is a text-based data format made up of attribute-value pairs and arrays and is readable by humans and machines. The
format grew out of the need for stateless server-to-browser communication.
Commonly associated with REST services, like APIs found on the web, today it is
widely used in many scenarios to send and receive data.

Below is an example of a fictional JSON data point from a weather sensor
containing a variety of sensor readings:

```json
{
    "location": {
        "lat": "43.56704 N",
        "lon": "116.24053 W",
        "elev": 2822
    },
    "name": "KBOI",
    "sensors": {
        "temperature": 48,
        "dew_point": 34,
        "humidity": 61,
        "wind": 9,
        "direction": "NW",
        "pressure": 30.23
    },
    "updated": "25 Oct 12:05 PM MDT"
}
```

To get this data into InfluxDB, the following tools show how to translate these
rows into line protocol. [Line protocol][3] consists of the following items:

[3]: https://docs.influxdata.com/influxdb/cloud/reference/syntax/line-protocol/

* Measurement name: the name data to store and later query
* Fields: The actual data that will be queried
* Tags: optional string fields that are used to index and help filter data
* Timestamp: optional; if not provided, the current timestamp is used

Using the JSON example above, the goal state is to translate the data into the
following line format:

```s
weather,station=KBOI dew_point=34i,direction="NW",humidity=61i,pressure=30.23,temperature=48i,wind=9i 1666721100000000000
```

## Client Libraries

The [InfluxDB Client libraries][10] are language-specific packages that integrate
with the InfluxDB v2 API. These libraries give developers a powerful method of
sending, querying, and managing InfluxDB. [Check out this TL;DR][11] for an
excellent overview of the client libraries. The libraries are available in many
languages, including [Python][12], [JavaScript][13], [Go][14], [C#][15],
[Java][16], and others.

[10]: https://www.influxdata.com/products/data-collection/influxdb-client-libraries/
[11]: https://www.influxdata.com/blog/tldr-influxdb-client-libraries/
[12]: https://github.com/influxdata/influxdb-client-python
[13]: https://github.com/influxdata/influxdb-client-js
[14]: https://github.com/influxdata/influxdb-client-go
[15]: https://github.com/influxdata/influxdb-client-csharp
[16]: https://github.com/influxdata/influxdb-client-java

The client libraries provide developers with the tools they need to quickly
send read and transformed data into InfluxDB. This way developers can work in
the specific language they are most comfortable with or with what the problem
space requires. And at the same time have a direct method to inject data into
InfluxDB.

The rest of this post demonstrates how to read the JSON data from the example
above using the Python, Go, and JavaScript client libraries.

## Python

The [Python][20] language and ecosystem have demonstrated a phenomenal way to
parse and clean data. Users build Python-based tooling to manipulate data in
many different use cases, from IoT devices to enterprise applications. The
simple syntax and powerful libraries make it a great first option for getting
data into InfluxDB. We have a video series introducing the Python client
library [here][21].

The following example demonstrates reading the weather JSON data as a file into
a Python dictionary, generating a data point, and sending that data point to
InfluxDB:

[20]: https://www.python.org/
[21]: https://www.influxdata.com/blog/tldr-python-client-library

```python
#!/usr/bin/env python3
"""Example to read JSON data and send to InfluxDB."""

from dateutil import parser
import json

from influxdb_client import InfluxDBClient, Point, WriteOptions
from influxdb_client.client.write_api import SYNCHRONOUS

point = Point("weather")
with open("../data/weather.json", "r") as json_file:
    data = json.load(json_file)

    point.tag("station", data["name"])
    point.time(parser.parse(data["updated"]))
    for key, value in data["sensors"].items():
        point.field(key, value)

with InfluxDBClient.from_config_file("config.toml") as client:
    with client.write_api(write_options=SYNCHRONOUS) as writer:
        try:
            writer.write(bucket="my-bucket", record=[point])
        except InfluxDBError as e:
            print(e)
```

This example uses the `Point` helper. This helper allows developers to quickly
and easily generate data in line protocol with the provided helper functions.
This creates the weather data point, then sets a single tag based on the
station name, uses the data’s timestamp as the timestamp, and then takes all
the sensor readings and makes them fields.

Using the Point helper is one of many ways to write data. Developers could have
data to send in the form of a Python Dictionary that specifies the metric name,
tags, fields, and timestamp or generates a simple string. For more examples of
these, check out the [Deep Dive into the WriteAPI][22] blog post.

[22]: https://www.influxdata.com/blog/influxdb-python-client-library-deep-dive-writeapi/

## Go

[Go][30] established itself as a high-performance, readable, and efficient
language. While it gained initial popularity from server-side, backend
development, Go is used across CLI applications, IoT devices, and scientific
applications.

In this example, a `Weather` struct is created to unmarshal the Weather station
data easily. Then, use the `NewPoint` helper to create the data point and,
finally, send it to InfluxDB.

[30]: https://go.dev/

```go
package main

import (
	"encoding/json"
	"os"
	"time"

	influxdb2 "github.com/influxdata/influxdb-client-go/v2"
)

type Weather struct {
	Name      string         `json:"name"`
	Timestamp string         `json:"updated"`
	Location  Location       `json:"location"`
	Sensors   map[string]any `json:"sensors"`
}

type Location struct {
	Lat  string `json:"lat"`
	Lon  string `json:"lon"`
	Elev int    `json:"elev"`
}

type Sensor struct {
	Temperature int     `json:"temperature"`
	DewPoint    int     `json:"dew_point"`
	Humidity     int    `json:"humidity"`
	Wind        int     `json:"wind"`
	Direction   string  `json:"direction"`
	Pressure    float64 `json:"pressure"`
}

func main() {
	bytes, err := os.ReadFile("../../data/weather.json")
	if err != nil {
		panic(err)
	}

	data := Weather{}
	if err := json.Unmarshal(bytes, &data); err != nil {
		panic(err)
	}

	timestamp, err := time.Parse(
            "2006 02 Jan 03:04 PM -0700",
            data.Timestamp
      )
	if err != nil {
		panic(err)
	}

	p := influxdb2.NewPoint(
		"weather",
		map[string]string{
			"station": data.Name,
		},
		data.Sensors,
		timestamp,
	)

	client := influxdb2.NewClient("http://localhost:8086/", "my-token")
	writer := client.WriteAPI("my-org", "my-bucket")
	writer.WritePoint(p)
	client.Close()
}
```

This example reads the JSON file but then unmarshals the data and parses the
timestamp. This occurs using the internal parse method along with the format
using the Go standard time to explain the format.

The `NewPoint` helper, in this case, allows the user to quickly and easily
specify the various parts of line protocol sent to InfluxDB with the
`WritePoint()` function. Developers could also write a string of line protocol
using the `WriteRecord()` function.

## JavaScript/Node.js

JavaScript is a core technology of the web. With the release of [Node.js][40],
users can run JavaScript in places other than a browser. As a result, the use
of JavaScript grew significantly from primarily websites to include
server-side, mobile, and other user applications.

This example is a Node.js script that, similar to the other examples, reads in
a file, creates a Point, and sends it to InfluxDB. You could adapt this to meet
many other scenarios:

[40]: https://nodejs.org/en/

```js
#!/usr/bin/env node

import {readFileSync} from 'fs'

import {InfluxDB, Point, HttpError} from '@influxdata/influxdb-client'
import {url, token, org, bucket} from './env.mjs'

const data = JSON.parse(readFileSync('../data/weather.json', 'utf8'))

const point = new Point('weather')
    .tag('station', data.name)
    .intField('temperature', data.sensors.temperature)
    .intField('dew_point', data.sensors.dew_point)
    .intField('humidity', data.sensors.humidity)
    .intField('wind', data.sensors.wind)
    .stringField('direction', data.sensors.direction)
    .floatField('pressure', data.sensors.pressure)
    .timestamp(new Date(data.updated))

const writeApi = new InfluxDB({url, token}).getWriteApi(org, bucket, 'ns')
writeApi.writePoint(point)

try {
    await writeApi.close()
} catch (e) {
    if (e instanceof HttpError) {
        console.error(e.statusCode)
        console.error(e.statusMessage)
    }
}
```

Like Python, JavaScript uses the Point helper to generate a valid line protocol
data point. The user specifies the various tags, fields, and their respective
data types, and the timestamp before writing the data to InfluxDB.

## Get your JSON data into InfluxDB today

This post shows how quick, easy, and flexible the InfluxDB client libraries
are. While the above only demonstrates JSON data, it starts to illustrate the
great power developers have when sending data to InfluxDB. Combined with the
other APIs, developers have even more options and potential.

Consider where you might be able to use [InfluxDB][50] and the
[client libraries][51], and give them a shot today!

[50]: https://www.influxdata.com/
[51]: https://docs.influxdata.com/influxdb/cloud/api-guide/client-libraries/
