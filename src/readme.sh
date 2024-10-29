#!/bin/bash

function readme {
  export GITHUB_ACCESS_TOKEN=$1
  mkdir -p new-workflow
  cd .. && rsync -av --progress workspace/. /github/workspace/new-workflow --exclude new-workflow && cd /github/workspace/new-workflow
  
  # Cloning using the working method
  git clone https://$GITHUB_ACCESS_TOKEN@github.com/clouddrove/genie.git genie
  
  cd genie
  
  # Check if the gomplate target exists before trying to make it
  if make packages/install/gomplate; then
    echo "Gomplate installed successfully."
  else
    echo "No rule for packages/install/gomplate, proceeding without installation."
  fi
  
  # Ensure README.yaml exists before attempting to generate README
  if [[ -f README.yaml ]]; then
    make readme
  else
    echo "README.yaml not found. Please ensure it exists before generating README."
  fi
}

# Call the function with your GitHub token
readme "YOUR_GITHUB_ACCESS_TOKEN"
