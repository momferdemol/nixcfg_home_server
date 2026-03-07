# Docker host

# Installation

## Commands

```sh
rm /etc/nixos/configuration.nix
```

```sh
curl https://raw.githubusercontent.com/momferdemol/nixcfg_home_server/refs/heads/main/docker/configuration.nix > /etc/nixos/configuration.nix
```

# Containers

## Navidrome

- [Navidrome](./containers/navidrome/)

> Create the `smbcred` in the `/var/secrets/` directory to establish NAS access.

```
username=<name>
password=<secret>
domain=WORKGROUP
```

```sh
docker compose up -d
```