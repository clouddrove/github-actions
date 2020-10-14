#!/bin/bash

function readme {
  # Gather the output of `terraform plan`.
  echo "plan: info: planning Terraform configuration in ${tfWorkingDir}"
  export GITHUB_ACCESS_TOKEN=${{ secrets.GITHUB }}
  cd .. && cd .. && cd ..
  git clone https://${{ secrets.GITHUB }}@github.com/clouddrove/genie.git
  cd /home/runner/work/ajay-testing/ajay-testing
  make packages/install/gomplate
  make readme
}