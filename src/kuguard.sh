# this is using clouddrve internal tool

function builBinary {
    echo "Install Go for kuguard"
    wget -q -O - https://raw.githubusercontent.com/canha/golang-tools-install-script/master/goinstall.sh \
 | bash -s -- --version 1.13.2

    echo "Install gcc, build-base for kuguard"
    apk add --update --no-cache zip gcc build-base

    echo "copy  kuguard"
    cp kuguard -r $HOME/go/src

    echo "Install go  package"
    go get github.com/mitchellh/go-homedir github.com/spf13/cobra

    echo  "Build binary for Mac"
    env GOOS=darwin GOACRCH=amd64 go build -o kuguard_darwin_amd64/kuguard kuguard
    echo  "Zip the Mac binary file"
    zip -r kuguard_darwin_amd64.zip kuguard_darwin_amd64/kuguard

    echo "Build binary for Linux"
    env GOOS=linux GOACRCH=amd64 go build -o kuguard_linux_amd64/kuguard kuguard
    echo  "Zip the Linux binary file"
    zip -r kuguard_linux_amd64.zip kuguard_linux_amd64/kuguard

    echo "Install mousetrap package of go for windows binary"
    go get github.com/inconshreveable/mousetrap
    echo "Build binary for Windows"
    env GOOS=windows GOACRCH=amd64 go build -o kuguard_windows_amd64.exe/kuguard kuguard
    echo  "Zip for Windows binary file"
    zip -r kuguard_windows_amd64.exe.zip kuguard_windows_amd64.exe/kuguard

}