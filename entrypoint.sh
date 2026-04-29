#!/bin/sh
set -e

DEFAULTS=/defaults/dnscrypt-proxy.toml
OVERRIDES=/config/overrides.toml
MERGED=/tmp/dnscrypt-proxy.toml

if [ -f "$OVERRIDES" ]; then
    yq eval-all 'select(fi==0) * select(fi==1)' "$DEFAULTS" "$OVERRIDES" \
        --output-format=toml > "$MERGED"
    echo "dnscrypt-proxy: merged overrides from $OVERRIDES"
else
    cp "$DEFAULTS" "$MERGED"
    echo "dnscrypt-proxy: no overrides, using defaults"
fi

exec dnscrypt-proxy -config "$MERGED" "$@"
