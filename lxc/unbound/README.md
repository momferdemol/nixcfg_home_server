# Unbound

Unbound is a validating, recursive, caching DNS resolver. It is designed to be fast and lean and incorporates modern features based on open standards. Unbound is created by NLnet Labs.

# DNS servers

```yaml
1.1.1.1           # Cloudflare
9.9.9.9           # Quad9
208.67.222.222    # OpenDNS
```

# Background

- Unbound DNS [tutorial](https://calomel.org/unbound_dns.html)
- Unbound DNS [example](https://helgeklein.com/blog/unbound-dns-server-configuration-static-ipv6-address-on-proxmox/)
- Unbound [documentation](https://unbound.docs.nlnetlabs.nl/en/latest/)

# Installation

## Proxmox CLI

Use the following commands (steps) to create the container.

```sh
CTID=201
CTT="local"
CTF="nixos-image-lxc-proxmox-25.11pre-git-x86_64-linux.tar.xz"
CTNAME="Unbound"
CT_CORES='1'
CT_RAM_MB="1024"
CT_STORAGE="vstore"
```

```sh
pct create ${CTID} "${CTT}:vztmpl/${CTF}" \
  --hostname "${CTNAME}" \
  --ostype=nixos --unprivileged=0 --features nesting=1 \
  --net0 name=eth0,bridge=vmbr0,ip=dhcp \
  --arch amd64 \
  --cores "${CT_CORES}" \
  --memory "${CT_RAM_MB}" \
  --storage "${CT_STORAGE}"
  ```

```sh
rm /etc/nixos/configuration.nix && \
curl https://raw.githubusercontent.com/momferdemol/nixconf/refs/heads/main/lxc-unbound/configuration.nix \
> /etc/nixos/configuration.nix
```
