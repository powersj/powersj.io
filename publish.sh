#!/bin/bash
set -ux

# Generate a new temporary directory for our deployment
deploy_dir=$(mktemp -d -t hugo-deploy)
echo "Using deploy directory ${deploy_dir}"

# Determine the remote origin Git location
git_remote=$(git remote get-url --push origin)
echo "Determined that Git remote is ${git_remote}"

# Update git submodules
echo "Updating Git submodules"
git submodule init
git submodule update

# Build the site in the deploy directory
echo
echo "Building Hugo site"
hugo -d "$deploy_dir"

# Initialise the deploy directory as a Git repository and add content
cd "$deploy_dir"

echo
echo "Creating a new Git repository and adding content"
git init
git remote add origin "$git_remote"
git checkout --orphan master
git add .
git commit -m "Site updated at $(date -u "+%Y-%m-%d %H:%M:%S") UTC"

echo
echo "Deploying code to the master branch"
#git push --force origin master
