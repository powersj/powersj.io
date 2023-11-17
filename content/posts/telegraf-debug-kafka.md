---
title: "Telegraf Debug with Kafka"
date: 2023-11-16
tags: ["telegraf"]
draft: false
aliases:
  - /post/telegraf-debug-kafka/
---

The following are my notes for working with Kafka and Telegraf.

## Kafka service

Generally, I have used a docker compose file that launches both Zookeeper and
Kafka together. However, another way is to run kafka in kraft mode, meaning
without Zookeeper with KRaft support. This has become the preferred way to
deploy Kafka as well. To do this run:

```s
docker run --rm -it --name kafka -p 9092:9092 \
    -e KAFKA_NODE_ID=1 \
    -e KAFKA_PROCESS_ROLES='broker,controller' \
    -e KAFKA_CONTROLLER_QUORUM_VOTERS='1@:9093' \
    -e KAFKA_LISTENERS='PLAINTEXT://:9092,CONTROLLER://:9093' \
    -e KAFKA_ADVERTISED_LISTENERS='PLAINTEXT://localhost:9092' \
    -e KAFKA_LISTENER_SECURITY_PROTOCOL_MAP='CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT' \
    -e KAFKA_CONTROLLER_LISTENER_NAMES='CONTROLLER' \
    -e KAFKA_INTER_BROKER_LISTENER_NAME='PLAINTEXT' \
    -e CLUSTER_ID='1234567890abcdefghijkl' \
    confluentinc/cp-kafka
```

## Data

To send data I use the `kafka-console-producer` that comes with the container
image. When run it opens up a shell to send a message on each line:

```s
$ docker exec -it kafka kafka-console-producer \
  --bootstrap-server :9092 \
  --topic telegraf
>
```

When sending the first message, you might see a warning about an unknown topic,
but after the first message the topic is created and the warning can be ignored:

```s
> [2023-11-16 20:37:51,359] WARN [Producer clientId=console-producer] Error
while fetching metadata with correlation id 4 :
{telegraf=UNKNOWN_TOPIC_OR_PARTITION} (org.apache.kafka.clients.NetworkClient)
```

To exit the command, use `Ctrl-C` to quit.

## Telegraf

To consume messages as they come in with Telegraf:

```toml
[[inputs.kafka_consumer]]
  brokers = ["127.0.0.1:9092"]
  topics = ["telegraf"]
  data_format = "influx"
```
