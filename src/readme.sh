#!/bin/bash

function readme {
  export GITHUB_ACCESS_TOKEN=$1
  mkdir -p new-workflow
  cd .. && rsync -av --progress workspace/. /github/workspace/new-workflow --exclude new-workflow && cd /github/workspace/new-workflow
  
  # Cloning using the working method
  git clone https://$GITHUB_ACCESS_TOKEN@github.com/clouddrove/genie.git genie
  
  cd genie
  make packages/install/gomplate
  make readme
}

# Call the function with your GitHub token
readme "YOUR_GITHUB_ACCESS_TOKEN"
