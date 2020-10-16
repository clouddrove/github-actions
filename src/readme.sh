#!/bin/bash

function readme {
  export GITHUB_ACCESS_TOKEN=$1
  mkdir -p new-workflow
  cd .. && rsync -av --progress workspace/. /github/workspace/new-workflow --exclude new-workflow && cd /github/workspace/new-workflow
  cd .. && cd .. && cd ..
  git clone https://$1@github.com/clouddrove/genie.git
  pwd && ls -la
  cd /github/workspace/new-workflow
  make packages/install/gomplate
  make readme
}