---
title: "Telegraf Debug with RabbitMQ"
date: 2023-11-14
tags: ["telegraf"]
draft: false
aliases:
  - /post/telegraf-debug-rabbitmq/
---

The following are my notes for working with RabbitMQ and Telegraf.

## RabbitMQ

I use the following configuration files to auto-generate an exchange on start.
The first is the main configuration file, `rabbitmq.conf`, which points at the
definitions file to generate exchanges:

```ini
management.load_definitions = /etc/rabbitmq/definitions.json
```

And `definitions.json` contains:

```json
{
    "exchanges": [
        {
            "name": "telegraf",
            "vhost": "/",
            "type": "direct",
            "durable": true,
            "auto_delete": false,
            "internal": false,
            "arguments": {}
        }
    ],
    "permissions":[
        {
            "user":"guest",
            "vhost":"/",
            "configure":".*",
            "read":".*",
            "write":".*"}
    ],
    "users": [
        {
            "name": "guest",
            "password_hash": "9/1i+jKFRpbTRV1PtRnzFFYibT3cEpP92JeZ8YKGtflf4e/u",
            "tags": ["administrator"]
        }
    ],
    "vhosts":[
        {"name":"/"}
    ]
}
```

This sets up a basic instance with a user guest with password guest who has
full permissions.

I use the official RabbitMQ image with the management tag. This tag provides
me with a docker container that also comes with a browser-based UI:

```s
docker run --rm -it -p 15672:15672 -p 5672:5672 \
    -v $PWD/rabbitmq.conf:/etc/rabbitmq/rabbitmq.conf \
    -v $PWD/definitions.json:/etc/rabbitmq/definitions.json \
    rabbitmq:management
```

The web UI is available at `http://127.0.0.1:15672/`

## Data

With the exchange set up I can curl a message with a specific payload:

```s
curl -u guest:guest -i -X POST \
    http://localhost:15672/api/exchanges/%2F/telegraf/publish \
    -d '{ "vhost": "/", "properties": {}, "routing_key": "", "payload_encoding":"string", "payload": "metric value=41"}'
```

## Telegraf

Below is the Telegraf config, note the different port then the one used above:

```toml
[[inputs.amqp_consumer]]
  brokers = ["amqp://127.0.0.1:5672/"]
  username = "guest"
  password = "guest"

  exchange = "telegraf"
  queue = "sensorsmq"
  queue_durability = "durable"
  binding_key = "#"
  prefetch_count = 1000
  max_undelivered_messages = 2

  data_format = "influx"
```
