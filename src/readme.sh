#!/bin/bash

function readme {
  export GITHUB_ACCESS_TOKEN=${{ secrets.GITHUB }}
  cd .. && cd .. && cd ..
  git clone https://${{ secrets.GITHUB }}@github.com/clouddrove/genie.git
  cd /home/runner/work/ajay-testing/ajay-testing
  make packages/install/gomplate
  make readme
}