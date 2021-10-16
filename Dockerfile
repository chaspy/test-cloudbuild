FROM golang:1.16.5 as builder

WORKDIR /go/src

COPY go.mod ./
RUN go mod download

COPY . .

ARG CGO_ENABLED=0
ARG GOOS=linux
ARG GOARCH=amd64
RUN go build \
    -o /go/bin/test-cloudbuild \
    -ldflags '-s -w'

FROM alpine:3.14.0 as runner

COPY --from=builder /go/bin/test-cloudbuild /app/test-cloudbuild

RUN adduser -D -S -H cloudbuild

USER cloudbuild

ENTRYPOINT ["/app/cloudbuild"]
