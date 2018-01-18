#!/bin/bash
set -ux

deploy_dir="public"
rm -rf "$deploy_dir"
echo "Using deploy directory ${deploy_dir}"

git_remote=$(git remote get-url --push origin)
echo "Determined that Git remote is ${git_remote}"

echo "Updating Git submodules"
git submodule init
git submodule update

echo "Building Hugo site"
hugo --destination "$deploy_dir"

echo "Creating a new Git repository and adding content"
cd "$deploy_dir"
git init
git remote add origin "$git_remote"
git checkout --orphan master
git add .
git commit -m "Site updated at $(date -u "+%Y-%m-%d %H:%M:%S") UTC"

echo "Deploying code to the master branch"
git push --force origin master

rm -rf "$deploy_dir"

