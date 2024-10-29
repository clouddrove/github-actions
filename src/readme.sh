#!/bin/bash

function readme {
  if [ -z "$1" ]; then
    echo "Error: GitHub access token is required."
    exit 1
  fi

  export GITHUB_ACCESS_TOKEN=$1
  
  mkdir -p new-workflow
  echo "Current directory: $(pwd)"
  
  echo "Syncing files to new-workflow..."
  if ! rsync -av --progress . /github/workspace/new-workflow --exclude new-workflow; then
    echo "Error: Failed to sync files."
    exit 1
  fi

  echo "Contents of new-workflow directory after sync:"
  ls -la /github/workspace/new-workflow

  echo "Cloning genie repository..."
  if ! git clone https://$GITHUB_ACCESS_TOKEN@github.com/clouddrove/genie.git /github/workspace/new-workflow/genie; then
    echo "Error: Failed to clone the genie repository."
    exit 1
  fi

  echo "Contents of genie Makefile:"
  cat /github/workspace/new-workflow/genie/Makefile

  # Install gomplate if not available
  if ! command -v gomplate &> /dev/null; then
    echo "Installing gomplate..."
    curl -L https://github.com/harness/drone-plugins/releases/download/v0.0.1/gomplate -o /usr/local/bin/gomplate && chmod +x /usr/local/bin/gomplate || {
      echo "Error: Failed to install gomplate."
      exit 1
    }
  else
    echo "gomplate already installed."
  fi

  # Check if README.yaml exists
  if [ -f /github/workspace/new-workflow/README.yaml ]; then
    echo "README.yaml found. Copying to genie directory..."
    cp /github/workspace/new-workflow/README.yaml /github/workspace/new-workflow/genie/README.yaml
  else
    echo "Error: README.yaml not found in new-workflow. Please ensure it exists."
    exit 1
  fi

  echo "Generating README..."
  make -C /github/workspace/new-workflow/genie readme || {
    echo "Error: Failed to generate README."
    exit 1
  }

  echo "README generated successfully."
}
