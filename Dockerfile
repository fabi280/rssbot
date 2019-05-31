FROM ekidd/rust-musl-builder:nightly-2019-04-25-openssl11 AS builder
RUN git clone --depth 1 https://github.com/fabi280/rssbot.git .
RUN rustup toolchain install nightly
RUN rustup default nightly
RUN rustup target add x86_64-unknown-linux-musl --toolchain=nightly
RUN cargo +nightly build --release --target x86_64-unknown-linux-musl
FROM alpine:latest
RUN apk --no-cache add ca-certificates
COPY --from=builder \
    /home/rust/src/target/x86_64-unknown-linux-musl/release/rssbot \
    /usr/local/bin/
ENV DATAFILE="/rustrssbot/rssdata.json"
ENV TELEGRAM_BOT_TOKEN=""
VOLUME /rustrssbot
ENTRYPOINT /usr/local/bin/rssbot $DATAFILE $TELEGRAM_BOT_TOKEN