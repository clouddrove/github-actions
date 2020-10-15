#!/bin/bash
#this is using for terraform  terratest
function goTest {

  echo "install the terratest dependencies"
  apk add -d --update --no-cache go curl gcc build-base

  echo "Install Go dep for terratest"
  if [ -f Gopkg.toml ]; then
  curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
  dep ensure
  else
  go get -v -t -d ./...
  fi
}
