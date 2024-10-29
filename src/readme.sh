#!/bin/bash

function readme {
  if [ -z "$1" ]; then
    echo "Error: GitHub access token is required."
    exit 1
  fi

  export GITHUB_ACCESS_TOKEN=$1
  
  mkdir -p new-workflow
  if ! rsync -av --progress workspace/. /github/workspace/new-workflow --exclude new-workflow; then
    echo "Error: Failed to sync files."
    exit 1
  fi

  cd /github/workspace/new-workflow || exit
  
  if ! git clone https://$GITHUB_ACCESS_TOKEN@github.com/clouddrove/genie.git; then
    echo "Error: Failed to clone the genie repository."
    exit 1
  fi

  make packages/install/gomplate || {
    echo "Error: Failed to install gomplate."
    exit 1
  }

  make readme || {
    echo "Error: Failed to generate README."
    exit 1
  }

  echo "README generated successfully."
}
