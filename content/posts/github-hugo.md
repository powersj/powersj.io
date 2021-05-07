---
title: "Hosting Hugo Site on GitHub Pages"
date: 2018-02-08
tags: ["blog"]
draft: false
aliases:
  - /post/github-hugo/
---

Like Jekyll, [Hugo](https://gohugo.io/) is a static site generator. I have
personally found Hugo to be faster for development, more flexible, and
more simple to use. As a result, I switched my blog to using it.

GitHub unfortunately, does not have native support Hugo, so it requires a
little extra effort it to make it work. This documents how I did it.

## Two Branches

I suggest having two branches in your repo:

- source: this is where your raw files will live
- master: this will be your published site that GitHub will in turn host

GitHub only allows username.github.io sites to publish from the [master
branch](https://help.github.com/articles/configuring-a-publishing-source-for-github-pages/).
Other types of repos can use the master, gh-pages, or /docs directory
though.

## Build and Publish

To accomplish the building and publishing of the Hugo site I use a short
shell script:

``` bash
#!/bin/bash
# Deploy hugo site to master branch
#
# Assumes you are on a branch called 'source' for storing the
# source and building. Builds and pushes to 'master' branch.
#
# Joshua Powers <mrpowersj@gmail.com>
set -ux

BRANCH_CURRENT=$(git rev-parse --abbrev-ref HEAD)
BRANCH_MASTER="master"
BRANCH_SOURCE="source"
BUILD_DIR="build"
GIT_REMOTE="origin"
GIT_REMOTE_URL=$(git remote get-url --push "$GIT_REMOTE")

cleanup() {
    if [ -d "$BUILD_DIR" ]; then
        rm -rf "$BUILD_DIR"
    fi
}

error() {
    echo "$@" 1>&2
}

fail() {
    [ $# -eq 0 ] || error "$@"
    exit 1
}

if [ "$BRANCH_CURRENT" != "$BRANCH_SOURCE" ]; then
    fail "not on source branch"
fi

echo "updating git submodules"
git submodule init || fail "submodule init failed"
git submodule update || fail "submodule update failed"

echo "building site"
cleanup
hugo --destination "$BUILD_DIR" || fail "build failed"
pushd "$BUILD_DIR" || fail "could not change to build dir"

echo "creating git commit"
git init
git remote add "$GIT_REMOTE" "$GIT_REMOTE_URL"
git checkout --orphan "$BRANCH_MASTER"
git add .
git commit -m "site updated at $(date -u "+%Y-%m-%d %H:%M:%S") UTC"

echo "publishing site"
git push --force "$GIT_REMOTE" "$BRANCH_MASTER"

popd
cleanup
```

This updates your submodules, making sure you have the latest version
of your themes, build's the site to a specific build directory, then
from the build directory pushes the site to your master branch.

The force push is a little harsh, as you lose history, but because the master
branch is used only for rendering the site it seems to work.
