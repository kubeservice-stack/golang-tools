ARG GO_VERSION=1.22.1-alpine3.19
ARG CLI_VERSION=20.10.2
ARG GOLANGCI_LINT_VERSION=v1.56.2-alpine

FROM golang:${GO_VERSION} AS builder
RUN apk add --no-cache \
    bash \
    git \
    make \
    wget

FROM golangci/golangci-lint:${GOLANGCI_LINT_VERSION} AS lint-base

FROM builder AS lint
####
# golangci-lint
####
COPY --from=lint-base /usr/bin/golangci-lint /usr/bin/golangci-lint
####
# gotestsum
####
ARG ARCH=amd64
ARG OS=linux
ARG GOTESTSUM_VERSION=1.11.0
RUN wget https://github.com/gotestyourself/gotestsum/releases/download/v${GOTESTSUM_VERSION}/gotestsum_${GOTESTSUM_VERSION}_${OS}_${ARCH}.tar.gz -nv -O - | tar -xz
RUN mv /root/gotestsum /usr/local/bin/gotestsum
