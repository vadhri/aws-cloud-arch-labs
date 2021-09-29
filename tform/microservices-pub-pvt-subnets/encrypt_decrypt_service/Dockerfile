FROM rust:1.54.0-alpine as builder
RUN apk add --no-cache musl-dev

WORKDIR /usr/src/encrypt_decrypt_service
COPY . .
RUN cargo install --path .

FROM alpine:latest
COPY --from=builder /usr/local/cargo/bin/encrypt_decrypt_service /usr/local/bin/encrypt_decrypt_service
CMD ["encrypt_decrypt_service"]

