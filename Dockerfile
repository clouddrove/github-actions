FROM golang:1.24-alpine

RUN ["/bin/sh", "-c", "apk add --update --no-cache bash ca-certificates rsync curl make git go jq openssh file"]

COPY ["src", "/src/"]

ENTRYPOINT ["/src/main.sh"]

