#!/bin/bash

function terraformInit {
  # Gather the output of `terraform init`.
  echo "init: info: initializing Terraform configuration in ${tfWorkingDir}"
  terraform init

}
