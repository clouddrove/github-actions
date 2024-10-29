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

  # Check if gomplate installation is needed
  if grep -q "packages/install/gomplate" ../../../genie/Makefile; then
    make packages/install/gomplate || echo "Skipping gomplate installation due to errors."
  else
    echo "No gomplate installation target found. Proceeding."
  fi

  # Attempt to generate README
  make readme || echo "Failed to generate README. Please check the errors."
}

# Call the function with your GitHub access token as the argument
readme YOUR_GITHUB_ACCESS_TOKEN
