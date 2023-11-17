---
title: "pacman"
date: 2024-01-01
tags: ["linux"]
draft: true
---


# CRUD commands
apt update
apt upgrade
apt install
apt purge

# find package
apt search

# what package contains binary
dpkg -S /bin/ls

# find specific file and package that owns it
apt-file find kwallet.h
