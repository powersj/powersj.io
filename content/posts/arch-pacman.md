---
title: "arch pacman cheatsheet"
date: 2024-01-17
tags: ["linux"]
draft: false
aliases:
  - /post/arch-pacman/
---

After spending years using apt, I made the move to arch a few years ago and love
it. However, my weakness is still the package manager, pacman, and knowing what
flags to use when. I do not have the muscel memory down yet.

The most helpful wiki pages include:

* [pacman](https://wiki.archlinux.org/title/pacman)
* [pacman: Tips and Tricks](https://wiki.archlinux.org/title/pacman/Tips_and_tricks)

Below is my cheatsheet of commands:

## Update

Syncs the package database and updates the system:

```shell
sudo pacman -Syu
```

Adding another `y` forces syncing the pakcage database.

## Install

Install packages:

```shell
sudo pacman -S <package>
```

## Remove

Removes a package and its dependencies not required by any other installed
package:

```shell
sudo pacman -Rs <package>
```

This next one requies some care before using. It can remove additional
packages. Removes a package and its dependencies and all the packages that
depend on the target package:

```shell
sudo pacman -Rcs <package>
```

## Queries

See all installed packages:

```shell
pacman -Qe
```

See detailed information about a package:

```shell
pacman -Si <package>
```

See what files are owned by a package:

```shell
pacman -Ql <package>
```

See what package owns a file:

```shell
pacman -Qo <file>
```

## Logs

Logs for pacman are kept in:

```shell
/var/log/pacman.log
```

## Mirror

In general I just use the default mirrors, but you can also use the `reflector`
package to potentially find a faster mirror:

```shell
sudo pacman -S reflector
sudo reflector --verbose -c US --age 10 --protocol https --sort rate \
  --save /etc/pacman.d/mirrorlist
```

## Cache

The cache of packages that have been installed are available under
`/var/cache/pacman/pkg/`. If needed, a user can combine these packages with
the `-U` option to install them directly:

```shell
sudo pacman -U /var/cache/pacman/pkg/<package>
```
