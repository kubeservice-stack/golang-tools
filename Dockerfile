ARG GO_VERSION=1.22.1-alpine3.19
ARG CLI_VERSION=20.10.2
ARG ALPINE_VERSION=3.19.0
ARG GOLANGCI_LINT_VERSION=v1.56.2-alpine

FROM golang:${GO_VERSION} AS builder
RUN apk add --no-cache \
    bash \
    git \
    make \
    wget

####
# golangci-lint
####
FROM golangci/golangci-lint:${GOLANGCI_LINT_VERSION} AS lint-base

####
# gotestsum
####
FROM alpine:${ALPINE_VERSION} AS gotestsum
RUN apk add --no-cache \
    tar \
    wget
# install gotestsum
WORKDIR /root
ARG ARCH=amd64
ARG OS=linux
ARG GOTESTSUM_VERSION=1.11.0
RUN wget https://github.com/gotestyourself/gotestsum/releases/download/v${GOTESTSUM_VERSION}/gotestsum_${GOTESTSUM_VERSION}_${OS}_${ARCH}.tar.gz -nv -O - | tar -xz

FROM builder AS lint
COPY --from=lint-base /usr/bin/golangci-lint /usr/bin/golangci-lint
COPY --from=gotestsum /root/gotestsum /usr/local/bin/gotestsum
RUN go get github.com/boumenot/gocover-cobertura

