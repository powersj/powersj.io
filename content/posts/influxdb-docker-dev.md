---
title: "InfluxDB in Docker for Development"
date: 2022-07-14
tags: ["influxdata"]
draft: false
aliases:
  - /post/influxdb-docker-development/
---

The Telegraf team at InfluxData has recently started looking at some of the
[InfluxDB Client libraries][0]. These libraries provide language-specific
packages to integrate with the InfluxDB API. These libraries are available for
wide range of languages, like [Python][10], [Go][11], [C#][12], [Java][13],
[JavaScript][14], and more.

In order to use these libraries I wanted a fast way to launch a known working
InfluxDB instance locally to try out these libraries.

[0]: https://docs.influxdata.com/influxdb/cloud/api-guide/client-libraries/
[10]: https://github.com/influxdata/influxdb-client-python
[11]: https://github.com/influxdata/influxdb-client-go
[12]: https://github.com/influxdata/influxdb-client-csharp
[13]: https://github.com/influxdata/influxdb-client-java
[14]: https://github.com/influxdata/influxdb-client-js

## InfluxDB 2.x

The following creates a running InfluxDB 2.x instance with a known set of
credentials ready for connecting and working with it:

```s
docker run --tty --interactive --rm --net host \
    --env DOCKER_INFLUXDB_INIT_MODE="setup" \
    --env DOCKER_INFLUXDB_INIT_ORG="my-org" \
    --env DOCKER_INFLUXDB_INIT_BUCKET="my-bucket" \
    --env DOCKER_INFLUXDB_INIT_USERNAME="my-user" \
    --env DOCKER_INFLUXDB_INIT_PASSWORD="my-password" \
    --env DOCKER_INFLUXDB_INIT_ADMIN_TOKEN="my-token" \
    --name influxdb-2.x \
    influxdb:latest
```

This launches the latest [InfluxDB official DockerHub image][1] with a
pre-configured user, org, and bucket. This will use the host network to
expose the database API and UI over the default port of 8086. On stop, the
container is deleted.

Checkout the [official InfluxDB Docker image docs][2] for more usage
information and see [entrypoint.sh][3] for more environmental set up options.

[1]: https://hub.docker.com/_/influxdb/
[2]: https://github.com/docker-library/docs/blob/master/influxdb/README.md#influxdb
[3]: https://github.com/influxdata/influxdata-docker/blob/master/influxdb/

### Configuration with InfluxDB 2.x

Any InfluxDB configuration setting can be specified as an environment
variable. The variables must be named using the format
`INFLUXD_${SNAKE_CASE_NAME}`. The SNAKE_CASE_NAME for an option will be the
option's name with all dashes `-` replaced by underscores `_` and in all caps.
See the [InfluxDB docs][4] for the full list of configuration settings.

In a more complicated configuration, a user could also mount a configuration
file directly to the container instead of specifying a long list of environment
variables. This is done by adding a volume to the container to the launch
command:

```s
-v $PWD/influxdb.conf:/etc/influxdb/influxdb.conf:ro
```

[4]: https://docs.influxdata.com/influxdb/latest/reference/config-options/

### Initialization Scripts

Users can also mount and then running arbitrary scripts to help initialize
InfluxDB. This is a great way to seed the database with some arbitrary data
or do some additional database or user configuration.

These scripts need to use the `.sh` extension and need to be mounted in
`/docker-entrypoint-initdb.d` directory. They are executed in lexical sort
order by name.

## InfluxDB 1.8

Turning to InfluxDB 1.8, the following creates a running InfluxDB 1.8 instance
again with a known set of credentials ready for connecting and interacting with
it:

```s
docker run --tty --interactive --rm --net host \
    --env INFLUXDB_HTTP_AUTH_ENABLED="true" \
    --env INFLUXDB_HTTP_FLUX_ENABLED="true" \
    --env INFLUXDB_DB="testing" \
    --env INFLUXDB_ADMIN_USER="admin" \
    --env INFLUXDB_ADMIN_PASSWORD="my-password" \
    --name influxdb-1.8 \
    influxdb:1.8
```

The above launches InfluxDB 1.8 with an admin user and a testing database. It
also uses the systems's host network to expose the database API over the
default port of 8086. On stop, the container is deleted. Unlike InfluxDB 2.x,
there is no UI for InfluxDB 1.8. This also enables the flux query support.

For the full list of options and possibilities see the official
[InfluxDB 1.8 Docker image docs][5] for more image usage information and
check out the [init-influxdb.sh][6] for more environmental set up options.

[5]: https://github.com/docker-library/docs/blob/master/influxdb/README.md#using-this-image---influxdb-1x
[6]: https://github.com/influxdata/influxdata-docker/tree/master/influxdb/1.8

### Users

With InfluxDB 1.8, users were created with a traditional username and password
and either had admin, write, or read access. By default, this creates an admin
user who has access to everything in the database.

There are three additional permission levels available that a user could use:

- **user**: full privileges to the created database

```bash
--env INFLUXDB_USER=""
--env INFLUXDB_USER_PASSWORD=""
```

- **write**: only write access to the created database

```bash
--env INFLUXDB_WRITE_USER=""
--env INFLUXDB_WRITE_USER_PASSWORD=""
```

- **read**: only read access to the created database

```bash
--env INFLUXDB_READ_USER=""
--env INFLUXDB_READ_USER_PASSWORD=""
```

### Configuration with InfluxDB 1.8

Any InfluxDB configuration setting can be specified as an environment
variable. The format is `INFLUXDB_$SECTION_$NAME`. All dashes `-` are replaced
with underscores `_`. If the variable is not in a section, then omit that
part.

See the [InfluxDB docs][7] for the full list of configuration settings.

If more complicated, a user could also mount a configuration file and then
append the configuration location to the launch command:

```bash
-v $PWD/influxdb.conf:/etc/influxdb/influxdb.conf:ro \
influxdb:1.8 -config /etc/influxdb/influxdb.conf
```

[7]: https://docs.influxdata.com/influxdb/v1.8/administration/config/
