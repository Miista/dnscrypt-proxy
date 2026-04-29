ARG DNSCRYPT_VERSION=2.1.15
FROM klutchell/dnscrypt-proxy:${DNSCRYPT_VERSION} AS upstream

FROM alpine:3.21

ARG TARGETARCH
ARG YQ_VERSION=v4.53.2

RUN wget -qO /usr/local/bin/yq \
      "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_${TARGETARCH}" \
    && chmod +x /usr/local/bin/yq

COPY --from=upstream /usr/local/bin/dnscrypt-proxy /usr/local/bin/dnscrypt-proxy
COPY --from=upstream /config/dnscrypt-proxy.toml /defaults/dnscrypt-proxy.toml

RUN mkdir -p /config

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
