---
title: "I use Arch btw"
date: 2022-12-23
tags: ["linux"]
draft: false
aliases:
  - /post/i-use-arch-btw/
---

![Banner](/img/arch.png)

While at Canonical, I did dozens of interviews with candidates to join us in
various roles. I noticed that a surprisingly large number of excellent
candidates ran Arch, or one of its derivatives, as their daily driver. Given
the popularity among candidates, I decided to give Arch a try after leaving
Canonical last year.

## The install

Unlike Ubuntu's installer which walks a user through the install process,
[Arch's downloadable image][1] is simply a bootable environment with all the
tools needed to install a system. I had seen other users suggest everyone
should go through this process at least once and so I did. I walked through the
[installation guide][2] step by step. I loved the experience and the ability
to customize and choose exactly how I wanted to set up the system. I would also
recommend this to anyone who wants to really understand the process of
installing a system better.

[1]: https://archlinux.org/download/
[2]: https://wiki.archlinux.org/title/Installation_guide

The trade-off for this customization and flexibility is a very intimidating
experience for newer users. While many parts are documented in the ArchWiki,
it is clear why many of the Arch derivatives, like [Manjaro][3] and
[EndeavourOS][4] provide a more traditional install experience.

[3]: https://manjaro.org/
[4]: https://endeavouros.com/

Another alternative is the [Arch-guided installer][5], which provides a
step-by-step installation similar to a more conventional install process. This
is the method I ultimately used for additional systems. It is fast and still
provides a great deal of flexibility. This is the way to first try for most
users, especially new ones.

[5]: https://python-archinstall.readthedocs.io/en/latest/installing/guided.html

After the install and reboot, I got things up and running like any other Gnome
install, except I had the [pacman package manager][6] and a lot newer versions
of everything.

[6]: https://wiki.archlinux.org/title/Pacman

## What I love

Some high-level observations that I love from running Arch as a daily driver
over the past year:

**Latest** - Having the latest kernel, Nvidia drivers, and software available
to me all the time. Rolling releases for the desktop are great for developers.
New versions of Go are on my system within what feels like hours of the
release, and the same goes for many other packages.

**Documentation** - The ArchWiki is famous for a reason, and every page I have
had to look up has seemingly had recent improvements that answered my
questions.

**Speed** - I created several snap packages and used a handful at Canonical.
However, I did not realize the impact on my boot speed and general application
performance till I watched how fast my system booted and I opened Spotify on
Arch. Everything is faster. More importantly, I run an AMD Ryzen 9 5950X; until
recently, this was one of the fastest CPUs a consumer can buy, paired with a
PCIe Gen 4 NVMe. If I notice a speed difference, I cannot imagine the speed hit
for a five- or six-year-old laptop user who may still have an SSD or even a
spinning drive.

**Stability** - I update my desktop every weekday, and after more than a year,
I have only had one issue slow me down. That includes dozens of new minor
kernel versions, graphics drivers, and language updates.

**Availability** - between the Arch package repo and the AUR repo, I have not
had any issues getting the packages I need.

## What I miss

I took some time to think about what I might miss from using Ubuntu, the big
thing that stood out was the command not found output. I loved typing a command
and having the terminal print out the package to install that binary if the
command was missing. Arch users must learn `sudo pacman -Fy <cmd>` or use the
[package search site] to find the package name.

[7]: https://archlinux.org/packages/

## What takes time

Given pacman is the package manager, knowing the various options, flags, and
capabilities of the command is pretty essential. I am still learning some
options and have to look them up occasionally, but these will come with time.
I have to recall I did not learn all the various `apt`, `apt-cache`, and
`dpkg` commands in a month, let alone a year.

## What hurt

I say hurt, but in reality, neither of these items was that big of an issue:

**Pacman signing keys** - As mentioned above, I tend to update every weekday,
but on my laptop the updates happen less often. Occasionally I will get a
message about a signature not trusted or an invalid package. Every time this
was resolved with updating the `archlinux-keyring` package first. The
[ArchWiki][8] even mentions installing this package first before updating if
an upgrade gets delayed for an extended period.

[8]: https://wiki.archlinux.org/title/Pacman/Package_signing#Tips_and_tricks

**Sound issue** - I updated my system one morning and then I lost all sound.
After doing my own troubleshooting I went to the forums and almost immediately
found a thread with someone else having the same issue and a way to resolve it.

## Going forward

If someone asked me what distro to try, the answer of course depends. If they
are new to Linux and want to explore, handing them the great initial user
experience of Ubuntu is the obvious choice. There is more hand-holding, and
the defaults provide a great initial experience. However, if someone knows
Linux and is ready to dive in a bit more or desires newer software, a
performant user experience, and a very active community, Arch is my choice.
