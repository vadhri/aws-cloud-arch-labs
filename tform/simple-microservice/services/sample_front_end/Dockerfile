FROM rust:1.54.0-alpine as builder
RUN apk add --no-cache musl-dev
RUN apk add cmake make gcc libc-dev g++ openblas-dev libx11-dev
RUN apk update && apk add --no-cache pkgconfig openssl-dev ca-certificates linux-headers && update-ca-certificates

WORKDIR /usr/src/sample_front_end
COPY . .
RUN cargo install --path .

FROM alpine:latest
COPY --from=builder /usr/local/cargo/bin/sample_front_end /usr/local/bin/sample_front_end
CMD ["sample_front_end"]

