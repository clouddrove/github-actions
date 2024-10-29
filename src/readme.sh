#!/bin/bash

function readme {
  export GITHUB_ACCESS_TOKEN=$1
  mkdir -p new-workflow
  cd .. && rsync -av --progress workspace/. /github/workspace/new-workflow --exclude new-workflow && cd /github/workspace/new-workflow

  # Clone the genie repo
  cd .. && cd .. && cd ..
  git clone https://$1@github.com/clouddrove/genie.git

  # Copy README.yaml to the genie directory
  cp /github/workspace/new-workflow/README.yaml /github/workspace/new-workflow/genie/

  # Change to the new-workflow directory
  cd /github/workspace/new-workflow

  # Try installing gomplate and generating README
  make packages/install/gomplate
  make readme
}
