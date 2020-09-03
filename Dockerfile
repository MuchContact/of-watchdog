FROM golang:1.13

ARG CGO_ENABLED=0
ARG GO111MODULE="off"
ARG GOPROXY=""

WORKDIR /go/src/github.com/openfaas/of-watchdog

COPY vendor              vendor
COPY config              config
COPY executor            executor
COPY metrics             metrics
COPY main.go             .

# Run a gofmt and exclude all vendored code.
#RUN test -z "$(gofmt -l $(find . -type f -name '*.go' -not -path "./vendor/*"))"

RUN go test -v ./...

# Stripping via -ldflags "-s -w" 
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags "-s -w" -installsuffix cgo -o of-watchdog .
