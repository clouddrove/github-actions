#!/bin/bash

function readme {
  if [ -z "$1" ]; then
    echo "Error: GitHub access token is required."
    exit 1
  fi

  export GITHUB_ACCESS_TOKEN="$1"
  
  # Create the new-workflow directory if it doesn't exist
  mkdir -p new-workflow
  echo "Current directory: $(pwd)"
  
  echo "Syncing files to new-workflow..."
  if ! rsync -av --progress . new-workflow --exclude new-workflow; then
    echo "Error: Failed to sync files."
    exit 1
  fi

  echo "Contents of new-workflow directory after sync:"
  ls -la new-workflow

  # Clone the genie repository into a separate directory
  echo "Cloning genie repository..."
  if ! git clone "https://$GITHUB_ACCESS_TOKEN@github.com/clouddrove/genie.git" new-workflow/genie; then
    echo "Error: Failed to clone the genie repository."
    exit 1
  fi

  echo "Contents of genie Makefile:"
  cat new-workflow/genie/Makefile

  # Install gomplate if not already installed
  if ! command -v gomplate &> /dev/null; then
    echo "Installing gomplate..."
    curl -L https://github.com/harness/drone-plugins/releases/download/v0.0.1/gomplate -o /usr/local/bin/gomplate && chmod +x /usr/local/bin/gomplate || {
      echo "Error: Failed to install gomplate."
      exit 1
    }
  else
    echo "gomplate already installed."
  fi

  # Ensure README.yaml exists in the correct location
  if [ -f new-workflow/README.yaml ]; then
    echo "README.yaml found. Copying to genie directory..."
    cp new-workflow/README.yaml new-workflow/genie/README.yaml
  else
    echo "Error: README.yaml not found in new-workflow. Please ensure it exists."
    exit 1
  fi

  # Change to the genie directory and generate the README
  cd new-workflow/genie || {
    echo "Error: Could not change to genie directory."
    exit 1
  }
  
  echo "Generating README..."
  if ! make readme; then
    echo "Error: Failed to generate README."
    exit 1
  fi

  echo "README generated successfully in new-workflow/genie."
}

# Call the function with the GitHub token passed as an argument
readme "$1"
