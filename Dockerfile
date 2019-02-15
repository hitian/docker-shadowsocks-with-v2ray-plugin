FROM golang:alpine as builder

RUN apk add git build-base
RUN git clone https://github.com/shadowsocks/v2ray-plugin.git /tmp/v2ray-plugin
RUN cd /tmp/v2ray-plugin && GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o /go/bin/v2ray-plugin

FROM alpine
COPY --from=builder /go/bin/v2ray-plugin /bin
RUN apk add --no-cache ca-certificates build-base git autoconf automake gettext pcre-dev libtool asciidoc xmlto udns-dev c-ares-dev libev-dev libsodium-dev mbedtls-dev linux-headers && \
    git clone https://github.com/shadowsocks/shadowsocks-libev /tmp/shadowsocks-libev && \
    cd /tmp/shadowsocks-libev && git submodule update --init --recursive && \
    ./autogen.sh && ./configure && make && make install  && \
    apk del build-base git autoconf automake gettext libtool asciidoc xmlto linux-headers && \
    rm -rf /tmp/shadowsocks-libev
