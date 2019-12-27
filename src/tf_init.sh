#!/bin/bash

function terraformInit {
  # Gather the output of `terraform init`.
  echo "init: info: initializing Terraform configuration in ${tfWorkingDir}"
  initOutput=$(terraform init -input=false ${*} 2>&1)
  initExitCode=${?}

  # Exit code of 0 indicates success. Print the output and exit.
  if [ ${initExitCode} -eq 0 ]; then
    echo "init: info: successfully initialized Terraform configuration in ${tfWorkingDir}"
    echo "${initOutput}"
    echo
    exit ${initExitCode}
  fi

  # Exit code of !0 indicates failure.
  echo "init: error: failed to initialize Terraform configuration in ${tfWorkingDir}"
  echo "${initOutput}"
  echo

  exit ${initExitCode}
}
