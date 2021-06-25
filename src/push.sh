#!/bin/bash

function push {
  cd /github/workspace/new-workflow
  git config --global user.email "anmol+ci@clouddrove.com."
  git config --global user.name "clouddrove-ci"
  git add . && git commit -m "update README.md"
  git push origin master
}
