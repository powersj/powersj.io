---
title: "Docker: Run Telegraf not as root"
date: 2021-11-03
tags: ["telegraf"]
draft: false
aliases:
  - /post/telegraf-not-root/
---

***This is a copy of a [blog post](https://www.influxdata.com/blog/docker-run-telegraf-as-non-root/)
I wrote originally posted on [InfluxData.com](https://www.influxdata.com/)***

The [Telegraf 1.20.3](https://www.influxdata.com/blog/release-announcement-telegraf-1-20-3/)
release changed the official Telegraf [DockerHub image](https://hub.docker.com/_/telegraf/)
to no longer run the Telegraf service as root. With this change, the Telegraf
service runs with the least amount of privileges in the container to enhance
security given the wide extensibility and array of plugins available in
Telegraf.

Both [Docker’s published best practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user)
and the [Center for Internet Security (CIS) Docker Benchmark](https://www.cisecurity.org/benchmark/docker/)
encourage running containers as a non-root user to limit a container’s
exploitability and impact on the host system. This change was made to align
with those recommendations and further enhance the security and experience of
running Telegraf in a container.

We understand that making this change in a maintenance release is both
unexpected and has the potential to cause undesirable side effects. After some
initial feedback on the
[initial change](https://github.com/docker-library/official-images/pull/11200),
we made an [additional update](https://github.com/docker-library/official-images/pull/11226)
to our implementation to lessen the impact on users and are more widely
advertising this change. The Telegraf 1.20.3, 1.19.3, and 1.18.3 DockerHub
images were all updated a second time.

The result of this change may require users to modify how they use the Telegraf
Docker image. Users need to ensure the `telegraf` user or `telegraf` group,
which runs the Telegraf service, has access to any additional required
services, sockets, files, etc., required for operation. Users can grant access
using standard commands like `usermod` to add the telegraf user to a group or
`chown` to change the ownership of a file.

Users are still able to install extra packages or configure services using the
DockerHub image.

If a user passes in the Docker socket for Telegraf to monitor Docker itself,
then they will need to add the `telegraf` user to the group that owns the
Docker socket. One way to achieve this is to use the `--user` option when
launching from the docker CLI:

```shell
docker run --user telegraf:$(stat -c '%g' /var/run/docker.sock) ...
```

The [Docker run](https://docs.docker.com/engine/reference/run/#user)
documentation has further information on specifying a user and group.

At InfluxData we’ve built the company based on a set of
[core values](https://www.influxdata.com/about/). The introduction of this
change actually reminds us of four of the five of these values:

* We are committed to open source
* We believe humility drives learning
* We embrace failure
* We get stuff done

Our desire to align with the best practices and support the community was at
the forefront of this change. We have had a strong focus on continuing to
advance our security posture in 2021 and we will continue to do so in the
future. However, our open source community also let us know that making this
change in a maintenance release was less than ideal, despite the good
intentions. We appreciated the direct and specific feedback provided by the
community. So, we worked quickly to incorporate the feedback.  We will use
this experience to learn and improve our release processes going forward.

We appreciate our amazing community and continue to be humbled by their
encouragement and suggestions, particularly when we don’t get it quite right.
