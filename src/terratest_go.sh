#!/bin/bash
#this is using for terraform  terratest
function goTest {
  # install the terratest dependencies
  echo "Install Go for terratest"
  wget -q -O - https://raw.githubusercontent.com/canha/golang-tools-install-script/master/goinstall.sh \
 | bash -s -- --version 1.13.2
  echo "Install Go package fo terratest"
  go get github.com/gruntwork-io/terratest/modules/terraform github.com/stretchr/testify/assert

  # Gather the output of `teratest`.
  echo "teratest: info: teratest run configuration  in ${tfWorkingDir}"
  teratestOutput=$( go test -run Test )
  teratestExitCode=${?}

  # Exit code of 0 indicates success. Print the output and exit.
  if [ ${teratestExitCode} -eq 0 ]; then
    echo "teratest: info: successfully teratest configuration in ${tfWorkingDir}"
    echo "${teratestOutput}"
    echo
    exit ${teratestExitCode}
  fi

  # Exit code of !0 indicates failure.
  echo "teratest: error: failed teratest configuration in ${tfWorkingDir}"
  echo "${teratestOutput}"
  echo

  # Comment on the pull request if necessary.
  if [ "$GITHUB_EVENT_NAME" == "pull_request" ] && [ "${tfComment}" == "1" ]; then
    teratestCommentWrapper="#### \`teratest\` Failed

\`\`\`
${teratestOutput}
\`\`\`

*Workflow: \`${GITHUB_WORKFLOW}\`, Action: \`${GITHUB_ACTION}\`, Working Directory: \`${tfWorkingDir}\`*"

    teratestCommentWrapper=$(stripColors "${teratestCommentWrapper}")
    echo "teratest: info: creating JSON"
    teratestPayload=$(echo "${teratestCommentWrapper}" | jq -R --slurp '{body: .}')
    teratestCommentsURL=$(cat ${GITHUB_EVENT_PATH} | jq -r .pull_request.comments_url)
    echo "teratest: info: commenting on the pull request"
    echo "${teratestPayload}" | curl -s -S -H "Authorization: token ${GITHUB_TOKEN}" --header "Content-Type: application/json" --data @- "${teratestCommentsURL}" > /dev/null
  fi

  exit ${teratestExitCode}
}
