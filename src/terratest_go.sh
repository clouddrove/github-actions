#!/bin/bash
#this is using for terraform  terratest
function goTest {

  echo "install the terratest dependencies"
  apk add -d --update --no-cache go curl gcc build-base

  echo "Install Go for terratest"
  if [ -x /github/home/.go ]; then
    echo exists
else
  echo "Install Go for terratest"
  echo "installing go version 1.14.3..." 
  apk add --no-cache --virtual .build-deps bash gcc musl-dev openssl go 
  echo start
  curl -O https://storage.googleapis.com/golang/go1.14.3.linux-amd64.tar.gz
  tar -C /usr/local -xzf go1.14.3.linux-amd64.tar.gz
  cd /usr/local/go/src/
  echo tarfinish
  export CGO_ENABLED=0
  ./make.bash 
  export PATH="/usr/local/go/bin:$PATH"
  export GOPATH=/opt/go/ 
  export PATH=$PATH:$GOPATH/bin 
  
  go version

  echo "Install Go package for terratest"
  go get github.com/gruntwork-io/terratest/modules/terraform github.com/stretchr/testify/assert
fi

  # Gather the output of `teratest`.
  echo "teratest: info: teratest run configuration  in ${tfWorkingDir}"
  go test -run Test --timeout 150m
}