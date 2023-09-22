#!/bin/bash

# Set Git configuration
git config --global user.name "clouddrove.ca"
git config --global user.email "clouddrove.ca@gmail.com"

# Add an exception for the /github/workspace/new-workflow directory
git config --global --add safe.directory /github/workspace/new-workflow

# Check for the correct number of arguments
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <GitHub Access Token> <Modules>"
  exit 1
fi

GITHUB_ACCESS_TOKEN="$1"
MODULES="$2"

# Create the 'new-workflow' directory
mkdir -p /github/workspace/new-workflow

# Copy files from 'workspace/' to '/github/workspace/new-workflow' excluding 'new-workflow'
rsync -av --progress workspace/. /github/workspace/new-workflow --exclude new-workflow || {
  echo "Error: Failed to copy files."
  exit 1
}

# Clone the 'genie' repository
git clone "https://$GITHUB_ACCESS_TOKEN@github.com/clouddrove/genie.git" || {
  echo "Error: Failed to clone the repository."
  exit 1
}

# Change to the '/github/workspace/new-workflow' directory
cd /github/workspace/new-workflow

# Generate the TOC
make toc/deps || {
  echo "Error: Failed to generate TOC dependencies."
  exit 1
}

make toc include_modules="$MODULES" || {
  echo "Error: Failed to generate TOC."
  exit 1
}

# Commit and push changes
git add .
git commit -m "feat: update toc readme file"
git push || {
  echo "Error: Failed to push changes to the repository."
  exit 1
}

echo "TOC generation and push completed successfully."
