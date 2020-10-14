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
<<<<<<< HEAD
  wget -O go.tgz https://dl.google.com/go/go1.10.3.src.tar.gz 
  tar -C /usr/local -xzf go.tgz 
  cd /usr/local/go/src/ 
./make.bash 
export PATH="/usr/local/go/bin:$PATH"
export GOPATH=/opt/go/ 
export PATH=$PATH:$GOPATH/bin 
apk del .build-deps 
go version

  echo "Install Go package fo terratest"
=======
  echo "installing go version 1.14.3..." 
  apk add --no-cache --virtual .build-deps bash gcc musl-dev openssl go
  go version
  wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
  wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.32-r0/glibc-2.32-r0.apk
  apk add glibc-2.32-r0.apk
  curl -O https://storage.googleapis.com/golang/go1.10.3.linux-amd64.tar.gz
  tar -C /usr/local -xzf go1.10.3.linux-amd64.tar.gz
  export CGO_ENABLED=0
  export PATH="/usr/local/go/bin:$PATH"
  export GOPATH=/opt/go/ 
  export PATH=$PATH:$GOPATH/bin
  cd /opt
  mkdir go
  cd go 
  mkdir bin
  source /etc/profile
  cd /usr/local/go/src
  echo 123
  ./make.bash
  go version
  echo "Install dep"
  curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
  echo "Install Go package for terratest"
>>>>>>> bebc31ca55bce4dd0e77022d5491a10630cb8076
  go get github.com/gruntwork-io/terratest/modules/terraform github.com/stretchr/testify/assert
fi

  # Gather the output of `teratest`.
  echo "teratest: info: teratest run configuration  in ${tfWorkingDir}"
  go test -run Test --timeout 150m
}
