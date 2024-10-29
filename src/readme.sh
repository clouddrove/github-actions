#!/bin/bash

function readme {
  export GITHUB_ACCESS_TOKEN=$1
  mkdir -p new-workflow
  cd .. && rsync -av --progress workspace/. /github/workspace/new-workflow --exclude new-workflow && cd /github/workspace/new-workflow

  # Clone the genie repo
  cd .. && cd .. && cd ..
  git clone https://$GITHUB_ACCESS_TOKEN@github.com/clouddrove/genie.git
  
  # Navigate into the new-workflow directory
  cd /github/workspace/new-workflow

  # Check if the genie directory was created
  if [ ! -d "../genie" ]; then
    echo "Failed to clone genie repository."
    exit 1
  fi

  # Copy README.yaml to the genie directory
  cp README.yaml ../genie/

  # Check if gomplate installation is needed
  if [ -f "../genie/Makefile" ]; then
    if grep -q "packages/install/gomplate" ../genie/Makefile; then
      make -C ../genie packages/install/gomplate || echo "Skipping gomplate installation due to errors."
    else
      echo "No gomplate installation target found. Proceeding."
    fi
  else
    echo "Makefile not found in genie directory."
    exit 1
  fi

  # Attempt to generate README
  make -C ../genie readme || echo "Failed to generate README. Please check the errors."
}

# Call the function with your GitHub access token as the argument
readme "YOUR_ACTUAL_GITHUB_ACCESS_TOKEN"
