# dnscrypt-proxy

A wrapper image around [klutchell/dnscrypt-proxy-docker](https://github.com/klutchell/dnscrypt-proxy-docker) that adds support for overriding individual config values without duplicating the entire config file.

## The problem

The upstream image requires mounting a complete `dnscrypt-proxy.toml` to change any setting. This means maintaining a full copy of the config just to override one or two values, and manually keeping it in sync with upstream defaults as the project evolves.

## How it works

This image ships the upstream default config internally. At startup, it deep-merges an optional `overrides.toml` on top of the defaults using [yq](https://github.com/mikefarah/yq). Only the keys present in your overrides file are changed — everything else inherits from the upstream defaults.

If no overrides file is mounted, the container runs with the upstream defaults unchanged.

## Usage

```yaml
services:
  dnscrypt-proxy:
    image: ghcr.io/miista/dnscrypt-proxy:latest
    volumes:
      - ./overrides.toml:/config/overrides.toml:ro
```

`overrides.toml` contains only the settings you want to change:

```toml
# Only specify what you want to change.
# All other settings inherit from the upstream defaults.
ipv6_servers = false
dnscrypt_servers = false
```

## Automatic updates

A GitHub Actions workflow runs daily and checks for new releases of the upstream image. When a new version is detected, it automatically builds and publishes a new multi-arch image (`linux/amd64`, `linux/arm64`) to GHCR.
