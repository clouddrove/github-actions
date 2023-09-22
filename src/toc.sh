#!/bin/bash

function toc {

git config --global user.name  clouddrove.ca
git config --global user.email "clouddrove.ca@gmail.com"
# Add an exception for the /github/workspace/new-workflow directory
git config --global --add safe.directory /github/workspace/new-workflow
export GITHUB_ACCESS_TOKEN=$1
MODULES=$2
mkdir -p new-workflow
cd .. && rsync -av --progress workspace/. /github/workspace/new-workflow --exclude new-workflow && cd /github/workspace/new-workflow
cd .. && cd .. && cd ..
git clone https://$1@github.com/clouddrove/genie.git
pwd && ls -la
cd /github/workspace/new-workflow
make toc/deps
make toc include_modules="$MODULES"
git add .
git commit -m "feat: update toc readme file"
git push

}
