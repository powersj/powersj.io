---
title: "Telegraf Debug with MQTT"
date: 2023-11-15
tags: ["telegraf"]
draft: false
aliases:
  - /post/telegraf-debug-mqtt/
---

The following are my notes for working with MQTT and Telegraf.

## MQTT

I use the following configuration file:

```properties
listener 1883
allow_anonymous true
persistence true
persistence_location /mosquitto/data/
log_type all
```

Mount the configuration file in docker and run:

```s
docker run --rm -it -p 1883:1883 -p 9001:9001 \
    -v $PWD/mosquitto.conf:/mosquitto/config/mosquitto.conf \
    eclipse-mosquitto
```

## Data

I can use curl to send messages:

```s
curl -d 'metric value=42' mqtt://127.0.0.1:1883/telegraf/test
curl -d 'metric value=43' mqtt://127.0.0.1:1883/telegraf/test
```

However, this does not let me set the QOS of the message. For that I have used
the `mosquitto_pub` command, with the `-q` flag:

```s
mosquitto_pub -h localhost -p 1883 -t telegraf -q 2 -m "metric value=43"
```

## Telegraf

The following config would allow for a persistent session and QOS level of 2:

```toml
[[inputs.mqtt_consumer]]
  servers = ["tcp://127.0.0.1:1883"]
  topics = ["telegraf/#"]

  qos = 2
  client_id = "telegraf"
  persistent_session = true

  data_format = "influx"
```
