#!/bin/bash

function terraformApply {
  # Gather the output of `terraform apply`.
  echo "apply: info: applying Terraform configuration in ${tfWorkingDir}"
  applyOutput=$(terraform apply -auto-approve -input=false ${*} 2>&1)
  applyExitCode=${?}
  applyCommentStatus="Failed"

  # Exit code of 0 indicates success. Print the output and exit.
  if [ ${applyExitCode} -eq 0 ]; then
    echo "apply: info: successfully applied Terraform configuration in ${tfWorkingDir}"
    echo "${applyOutput}"
    echo
    applyCommentStatus="Success"
  fi

  # Exit code of !0 indicates failure.
  if [ ${applyExitCode} -ne 0 ]; then
    echo "apply: error: failed to apply Terraform configuration in ${tfWorkingDir}"
    echo "${applyOutput}"
    echo
  fi

  exit ${applyExitCode}
}
