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

## Commands

```sh
rm /etc/nixos/configuration.nix
```

```sh
curl https://raw.githubusercontent.com/momferdemol/nixcfg_home_server/refs/heads/main/lxc/unbound/configuration.nix > /etc/nixos/configuration.nix
```
