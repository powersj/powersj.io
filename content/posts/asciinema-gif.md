---
title: "GIF Production from asciinema"
date: 2018-09-10
tags: ["ubuntu"]
draft: false
aliases:
  - /post/asciinema-gif/
---

[asciinema](https://asciinema.org/) is a fantastic application for recording terminal sessions and posting them to the web. I have used these as backups to presentations at conferences and as a way to quickly share with co-workers what I am seeing when reporting issues.

I recently wanted to embed a gif demo of an application I wrote. This post documents the tooling and methods I used.

![ubuntu-iso-download](/gif/asciinema/ubuntu-iso-download.gif#center)

## lxc

I run both of these apps in a Ubuntu Xenial container as I did not want to have all the extra dependencies of node on my main system. I also used Xenial as the version found in Bionic does not seem to work due to a [reported issue](https://github.com/asciinema/asciicast2gif/issues/44) and due to the fact that the [Dockerfile](https://github.com/asciinema/asciicast2gif/blob/master/Dockerfile) that is available also uses Xenial.

```bash
lxc launch ubuntu-daily:x ascii
```

This way all I need to do is pass the cast file in to the container, make my changes, generate the gif, and pull the resulting gif out:

```bash
lxc file push app_demo.cast ascii/root/
# do all my editing and generating
lxc file pull ascii/root/app_demo.gif .
```

## asciinema

If you have not used asciinema before check out the [homepage](https://asciinema.org/) and watch the cool video example. Once [installed](https://asciinema.org/docs/installation) it is time to begin making recordings.

The CLI is simple and what I typically use is something like the following:

```bash
asciinema rec app_demo.cast
```

That will produce a file in the current directory called `app_demo.cast`. This is really a [JSON file](https://github.com/asciinema/asciinema/blob/develop/doc/asciicast-v2.md) meaning you can open it up in a text editor and take a look at the contents after recording. For making small changes, editing the file directly can work, however if you want to make larger changes and scale differences, especially on longer recordings then the first tool I use helps with that.

## asciinema-edit

[asciinema-edit](https://github.com/cirocosta/asciinema-edit) is a fantastic set of post-production commands to run on asciinema recordings. This allows me to speed up or slow down certain parts of a recording or the whole thing. It can also cut out whole sections and have it automatically update the remaining timings to produce smooth playback.

This app works on version 2 of asciinema recordings, so older recordings will not work.

### Install

asciinema-edit is a Go app so it is very simple to get running. The below installs go as a snap, adds the go binaries to my path, and installs the app:

```bash
snap install go --classic
echo 'GOROOT=$HOME/go' | tee -a ~/.bashrc
echo 'PATH=$PATH:$GOROOT/bin' | tee -a ~/.bashrc
go get -u -v github.com/cirocosta/asciinema-edit
```

### Subcommands

There are three subcommands available for post-production:

#### Cut

The simplest, cut, removes a particular frame or range of frames from a cast. For example, if you want to remove a mistake or part from the recording that did not work out:

```bash
# Remove a single frame
asciinema-edit cut --start 12.998343 --end 12.998343
# Remove multiple frames between two times
asciinema-edit cut --start 2.343988 --end 18.019034
```

#### Speed

Next, consider the speed operation to adjust the length of parts of or an entire recording. This is of course useful if you want to shorten your entire recording down or are particular section (e.g. downloading a file):

```bash
# Reduce the time by half of the entire cast
asciinema-edit speed --factor .5 app_demo.cast
# For the specific start and end time, cut the duration to 1/10 and
# save the output as a new file
asciinema-edit speed --factor .1 --start 24.058306 --end 205.538531 \
    --out app_demo_fast.cast app_demo.cast
```

#### Quantize

Finally, the quantize subcommand allows for removing long delays. This is great for reducing delays between commands where the prompt does not update. If the prompt does update, as with a download progress bar, then the speed up option works better.

```bash
# Reduce delays bigger than 2 seconds down to 2 seconds
asciinema-edit quantize --range 2 app_demo.cast
```

## asciicast2gif

Now that the cast is captured and post-production is complete it is time to create the gif! For this I use [asciicast2gif](https://github.com/asciinema/asciicast2gif), which is a product of the asciinema team themselves.

### Install via npm

Install occurs via npm and on my Xenial container I needed a newer version of npm, so I grabbed node.js 8.x the current LTS code named "Carbon". This is one of the main reasons why I run this in a container:

```bash
echo "deb https://deb.nodesource.com/node_8.x xenial main" | sudo tee /etc/apt/sources.list.d/node.list
curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
sudo apt update
sudo apt install --yes nodejs imagemagick gifsicle
npm install asciicast2gif
echo "PATH=$HOME/node_modules/asciicast2gif:$PATH" | tee -a ~/.bashrc
```

### Usage

There are two ways to convert an asciinema to a gif:

#### cast to gif

From a cast file directly:

```bash
asciicast2gif app_demo.cast app_demo.gif
```

#### upload to gif

If you have an uploaded GIF to asciinema.org you can run using the URL of the cast, with `.cast` added to the end, and the filename of the gif you want:

```bash
asciicast2gif https://asciinema.org/a/131013.cast demo.gif
```

#### Options

Similar to asciinema-edit there are a number of options with asciicast2gif that allow you to modify the final gif:

* **theme**: like asciinema.org you can change the theme used in the final gif
* **speed**: the higher the number the faster it goes (i.e. 2 is twice as fast)
* **scale**: scale of the final image (i.e. 1 for smaller gif, 2 default)
* **columns**: clip the width to a specific number
* **rows**: clip the height to a specific number

## The Result

The combination of all three tools result in fantastic examples that can easily be shared and posted to the web.

![cloud-init with lxc](/gif/asciinema/cloud-init-lxd.gif#center)
