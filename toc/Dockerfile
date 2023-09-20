# pinned version of the Alpine-tagged 'go' image
FROM golang:1.21-alpine
RUN apk add --update --no-cache go make
# install requirements
RUN apk add --update --no-cache bash ca-certificates curl jq
RUN apk add git
RUN apk add rsync
COPY toc/toc.sh /toc.sh
RUN chmod +x /toc.sh
# set the default entrypoint -- when this container is run, use this command
ENTRYPOINT ["/toc.sh"]