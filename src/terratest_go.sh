#!/bin/bash
#this is using for terraform  terratest
function goTest {
  echo "install the terratest dependencies"
  apk add -d --update --no-cache go curl gcc build-base

  echo "setup go"
  if [ -x /github/home/.go ]; then
    echo exists
  else
  echo "Install Go for terratest"
  wget -O go.tgz https://golang.org/dl/go1.15.3.linux-amd64.tar.gz
  tar -C /usr/local -xzf go.tgz
  cd /usr/local/go/src/
  ./make.bash
  export PATH="/usr/local/go/bin:$PATH"
  export GOPATH=/opt/go/
  export PATH=$PATH:$GOPATH/bin
  go version
  fi

  echo "Install Go dep for terratest"
  if [ -f Gopkg.toml ]; then
  curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
  dep ensure
  else
  go get -v -t -d ./...
  fi

  echo "teratest: info: teratest run configuration  in ${tfWorkingDir}"
  cd /github/workspace
  cd  ${tfWorkingDir}
  go test  --timeout 15000m
}
