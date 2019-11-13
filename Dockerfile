FROM golang:alpine as build

RUN apk add --update -t build-deps git libc-dev gcc libgcc make \
    && go get -u github.com/percona/mongodb_exporter \
    && cd /go/src/github.com/percona/mongodb_exporter \
    && make build \
    && apk del --purge build-deps

FROM golang:alpine

EXPOSE 9216

COPY --from=build /go/src/github.com/percona/mongodb_exporter/bin/mongodb_exporter /bin/mongodb_exporter

ENTRYPOINT [ "/bin/mongodb_exporter" ]
