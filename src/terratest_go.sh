#!/bin/bash
#this is using for terraform  terratest
function goTest {

  echo "install the terratest dependencies"
  apk add -d --update --no-cache go gcc build-base

  echo "Install Go for terratest"
  if [ -x /github/home/.go ]; then
    echo exists
else
  echo "Install Go for terratest"
  echo "installing go version 1.4.3..." 
  apk add --no-cache --virtual .build-deps bash gcc musl-dev openssl go 
  wget -O https://storage.googleapis.com/golang/go1.4.3.linux-amd64.tar.gz 
  tar -C /usr/local -xzf go.tgz 
  cd /usr/local/go/src/ 
  ./make.bash 
  export PATH="/usr/local/go/bin:$PATH"
  export GOPATH=/opt/go/ 
  export PATH=$PATH:$GOPATH/bin 
  apk del .build-deps 
  go version
  echo starting
  go get github.com/gruntwork-io/terratest/modules/terraform github.com/stretchr/testify/assert
  echo ending

  echo "Install Go package for terratest"
  go get github.com/gruntwork-io/terratest/modules/terraform github.com/stretchr/testify/assert
fi

  # Gather the output of `teratest`.
  echo "teratest: info: teratest run configuration  in ${tfWorkingDir}"
  go test -run Test --timeout 150m
}