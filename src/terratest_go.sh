#!/bin/bash
#this is using for terraform  terratest
function goTest {

  echo "install the terratest dependencies"
  apk add -d --update --no-cache go gcc bash musl-dev openssl-dev ca-certificates && update-ca-certificates

  echo "Install Go for terratest"
  if [ -x /github/home/.go ]; then
    echo exists
else

 wget https://dl.google.com/go/go1.14.3.src.tar.gz && tar -C /usr/local -xzf go$GOLANG_VERSION.src.tar.gz
 cd /usr/local/go/src && ./make.bash
 export  PATH=$PATH:/usr/local/go/bin
 rm go$GOLANG_VERSION.src.tar.gz

#we delete the apk installed version to avoid conflict
   apk del go

  echo "Install Go package fo terratest"
  go get github.com/gruntwork-io/terratest/modules/terraform github.com/stretchr/testify/assert
fi

  # Gather the output of `teratest`.
  echo "teratest: info: teratest run configuration  in ${tfWorkingDir}"
  go test -run Test --timeout 150m
}