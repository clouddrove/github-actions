FROM alpine:3.10

RUN ["/bin/sh", "-c", "apk add --update --no-cache bash ca-certificates curl git jq openssh go  gcc build-base file"]

COPY ["src", "/src/"]

ENTRYPOINT ["/src/main.sh"]

