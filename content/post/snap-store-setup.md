---
title: "Beautify a Snap Store Page"
date: 2018-09-12
tags: ["snap", "store"]
draft: false
---

# Beautify a Snap Store Page

I recently pushed three new confined snaps to the snap store and wanted to get the pages looking a little nicer. I first read through Martin Wimpress's blog to [Make your Snap store page pop](https://snapcraft.io/blog/make-your-snap-store-page-pop).

It gave some good suggestions, but I was not quite sure how to create the graphical components. This post describes how I found accomplished each of those.

![snap-store](/img/snap/snap-store.png#center)

## Logo

There are numerous online tools to create store apps, but the one I found the easiest to learn and use was from the [Android Asset Studio](https://androidassetstudio.net/). As a part of it I used the [Launcher Icon Generator](https://androidassetstudio.net/icons-launcher.html) to take a simple icon and incorporate it into a full logo. The studio also has an [Generic Icon Generator](https://androidassetstudio.net/icons-generic.html) that can take images, clip art, and text, resize, add color, and turn them into an icon as well.

![ubuntu-release-info](/img/snap/ubuntu-release-info.png#center)

The store does require a 256x256 icon, so I had to convert it using the convert command to reduce the size:

```bash
convert -resize 256x256 logo_512.png logo_256.png
```

## Screenshots

Getting snapshots is fairly easy as all that requires is using the screenshot utility. I liked to grab an example of help output and actual usage.

![ubuntu-bug-triage](/img/snap/ubuntu-bug-triage.png#center)

## GIF

A great way to show off an application is with an actual video of it in usage. I wrote up a separate post on creating a [GIF from an asciinema recording]({{< ref "asciinema-gif.md" >}}).

## Banner

Lots of social media sites now have banners and as a result there are numerous sites to create banners of different sizes. One example that I liked was [trianglify.io](https://trianglify.io/) which can produce some custom size and color images.

![trianglify](/img/snap/banner.png#center)
