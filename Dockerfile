##########################
## Builder Container
##########################
FROM golang:1.14.6-alpine3.12 as builder

WORKDIR /go/src/github.com/sample-go-webassembly

COPY . .

ENV CGO_ENABLED=0
ENV GOOS=js
ENV GOARCH=wasm

RUN apk update && \
      apk add --no-cache git && \
    go build -o test.wasm main.go

ENV GOOS=linux
ENV GOARCH=amd64

RUN go build -o server server.go


##########################
## Application Container
##########################
FROM alpine

WORKDIR /sample-go-webassembly

RUN apk add --no-cache ca-certificates

COPY --from=builder /go/src/github.com/sample-go-webassembly /sample-go-webassembly

CMD ["./server"]
