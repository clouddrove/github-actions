#!/bin/bash

function terraformPlan {
  # Gather the output of `terraform plan`.
  echo "plan: info: planning Terraform configuration in ${tfWorkingDir}"
  terraform plan
}