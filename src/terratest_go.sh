#!/bin/bash
#this is using for terraform  terratest
function goTest {

  echo "Install Go package fo terratest"
  go get  github.com/gruntwork-io/terratest/modules/terraform
fi

  # Gather the output of `teratest`.
  echo "teratest: info: teratest run configuration  in ${tfWorkingDir}"
  go test -run Test --timeout 150m
}