#!/bin/bash

function stripColors {
  echo "${1}" | sed 's/\x1b\[[0-9;]*m//g'
}

function hasPrefix {
  case ${2} in
    "${1}"*)
      true
      ;;
    *)
      false
      ;;
  esac
}

#Static Version of Terraform
INPUT_TF_ACTIONS_VERSION=0.12.13

function parseInputs {
  # Required inputs
  if [ "${INPUT_TF_ACTIONS_VERSION}" != "" ]; then
    tfVersion=${INPUT_TF_ACTIONS_VERSION}
  else
    echo "Input terraform_version cannot be empty"
    exit 1
  fi

  if [ "${INPUT_ACTIONS_SUBCOMMAND}" != "" ]; then
    Subcommand=${INPUT_ACTIONS_SUBCOMMAND}
  else
    echo "Input terraform_subcommand cannot be empty"
    exit 1
  fi

  # Optional inputs
  tfWorkingDir="."
  if [ "${INPUT_TF_ACTIONS_WORKING_DIR}" != "" ] || [ "${INPUT_TF_ACTIONS_WORKING_DIR}" != "." ]; then
    tfWorkingDir=${INPUT_TF_ACTIONS_WORKING_DIR}
  fi

  tfComment=0
  if [ "${INPUT_TF_ACTIONS_COMMENT}" == "1" ] || [ "${INPUT_TF_ACTIONS_COMMENT}" == "true" ]; then
    tfComment=1
  fi

  tfCLICredentialsHostname=""
  if [ "${INPUT_TF_ACTIONS_CLI_CREDENTIALS_HOSTNAME}" != "" ]; then
    tfCLICredentialsHostname=${INPUT_TF_ACTIONS_CLI_CREDENTIALS_HOSTNAME}
  fi

  tfCLICredentialsToken=""
  if [ "${INPUT_TF_ACTIONS_CLI_CREDENTIALS_TOKEN}" != "" ]; then
    tfCLICredentialsToken=${INPUT_TF_ACTIONS_CLI_CREDENTIALS_TOKEN}
  fi
}

function configureCLICredentials {
  if [[ ! -f "${HOME}/.terraformrc" ]] && [[ "${tfCLICredentialsToken}" != "" ]]; then
    cat > ${HOME}/.terraformrc << EOF
credentials "${tfCLICredentialsHostname}" {
  token = "${tfCLICredentialsToken}"
}
EOF
  fi
}

function terraformPlan {
   terraform plan
}
function installTerraform {
  url="https://releases.hashicorp.com/terraform/${tfVersion}/terraform_${tfVersion}_linux_amd64.zip"

  echo "Downloading Terraform v${tfVersion}"
  curl -s -S -L -o /tmp/terraform_${tfVersion} ${url}
  if [ "${?}" -ne 0 ]; then
    echo "Failed to download Terraform v${tfVersion}"
    exit 1
  fi
  echo "Successfully downloaded Terraform v${tfVersion}"

  echo "Unzipping Terraform v${tfVersion}"
  unzip -d /usr/local/bin /tmp/terraform_${tfVersion} &> /dev/null
  if [ "${?}" -ne 0 ]; then
    echo "Failed to unzip Terraform v${tfVersion}"
    exit 1
  fi
  echo "Successfully unzipped Terraform v${tfVersion}"
}


function main {
  # Source the other files to gain access to their functions
  scriptDir=$(dirname ${0})
  source ${scriptDir}/tf_fmt.sh
  source ${scriptDir}/tf_init.sh
  source ${scriptDir}/tf_validate.sh
  source ${scriptDir}/tf_plan.sh
  source ${scriptDir}/tf_apply.sh
  source ${scriptDir}/tf_output.sh
  source ${scriptDir}/terratest_go.sh
  source ${scriptDir}/file_upload.sh
  source ${scriptDir}/kuguard.sh

  parseInputs
  configureCLICredentials
  cd ${GITHUB_WORKSPACE}/${tfWorkingDir}

  case "${Subcommand}" in
    fmt)
      installTerraform
      terraformFmt ${*}
      ;;
    init)
      installTerraform
      terraformInit ${*}
      ;;
    validate)
      installTerraform
      terraformValidate ${*}
      ;;
    plan)
      installTerraform
      terraformPlan ${*}
      ;;
    apply)
      installTerraform
      terraformApply ${*}
      ;;
    output)
      installTerraform
      terraformOutput ${*}
      ;;
    terratest)
      installTerraform
      goTest ${*}
      ;;
    file_upload)
      builBinary
      fileUpload ${*}
      ;;
    *)
      echo "Error: Must provide a valid value for subcommand"
      exit 1
      ;;
  esac
}

main "${*}"
