#!/bin/bash
#this is using for terraform  terratest
function goTest {

  echo "initialize Go mod"
  go mod init terratest

  echo "Install Go package fo terratest"
  go get github.com/stretchr/testify/assert
  go get  github.com/gruntwork-io/terratest/modules/terraform

  # Gather the output of `teratest`.
  echo "teratest: info: teratest run configuration  in ${tfWorkingDir}"
  export DIGITALOCEAN_TOKEN=${DO_TOKEN}
  go test -run Test --timeout 150m
}
