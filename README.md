
<pre>
  Title: Home Server
  Author: Momfer de Mol
  Status: Active
  Created: 02-03-2026
</pre>

# Home Server

## Virtual Machines

- [Unbound](./unbound)

# References

## Commands

```sh
nixos-rebuild switch
```

```sh
nix-channel --update
nixos-rebuild switch --upgrade
```

```sh
nix-collect-garbage -d
nix-store --gc
```

```sh
poweroff --reboot
```

## Documentation

- [Proxmox LXC Containers](https://nixos.wiki/wiki/Proxmox_Linux_Container#Running_NixOS_as_a_ProxmoxVE_LXC_container)
