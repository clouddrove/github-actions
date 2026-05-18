#!/bin/bash

function push {
  export GITHUB_ACCESS_TOKEN=$1
  cd /github/workspace/new-workflow
  git config --global --add safe.directory /github/workspace/new-workflow
  git config --global user.email "anmol+ci@clouddrove.com."
  git config --global user.name "clouddrove-ci"
  git remote set-url origin https://x-access-token:${GITHUB_ACCESS_TOKEN}@github.com/${GITHUB_REPOSITORY}.git
  git add .
  git commit -m "update README.md" || true
  git push origin master
}