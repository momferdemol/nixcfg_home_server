
<pre>
  Title: Home Server
  Author: Momfer de Mol
  Status: Active
  Created: 02-03-2026
</pre>

# Home Server

## Virtual Machines

- [Unbound](./unbound)
- [Docker Host](./docker/)

### How To Install NixOS

Create a VM with the following settings:

Operating System
- Latest nixos image from [nixos.org](https://nixos.org/download/)

System
- Machine `q35`
- BIOS `OVMF (UEFI)`

Storage
- 16GB minimum

CPU / Memory
- For initial installation: 4 cores / 4096 GB

> Scale down after initial installation is done.

Boot the virtual machine for the first time, a `boot failure` will show. Enter the boot menu and select EFI Firmware Setup. From here you need to disable secure boot. Follow Device Manager > Secure Boot Configuration and you’ll see Attempt Secure Boot will be checked. Hit SPACE to uncheck. Once done, leave the EFI Firmware settings and restart.

NixOS should now boot normally into the installer.

Don't follow the installer, open the terminal and follow these commands.

```sh
sudo -i
```

```sh
passwd
```

```sh
systemctl start sshd
```

```sh
lsblk
```

Create 3 partitions: root, swap, and boot.

```sh
parted /dev/sda -- mklabel gpt
```

```sh
parted /dev/sda -- mkpart root ext4 512MB -4GB  # root
```

```sh
parted /dev/sda -- mkpart swap linux-swap -4GB 100%  # swap
```

```sh
parted /dev/sda -- mkpart ESP fat32 1MB 512MB  # boot
parted /dev/sda -- set 3 esp on
```

Format and mount the new partitions.

```sh
mkfs.ext4 -L nixos /dev/sda1
```

```sh
mkswap -L swap /dev/sda2
```

```sh
mkfs.fat -F 32 -n boot /dev/sda3
```

```sh
mount /dev/sda1 /mnt
```

```sh
mount --mkdir /dev/sda3 /mnt/boot
```

```sh
swapon /dev/sda2
```

Copy `configuration.nix` from source machine to the virtual machine.

```sh
scp configuration.nix root@*VM‑IP*:/tmp/configuration.nix
```

Prep nixos directory `/etc/nixos`

```sh
mkdir -p /mnt/etc/nixos
```

```sh
mv /tmp/configuration.nix /mnt/etc/nixos/configuration.nix
```

Run the command to generate the hardware-configuration.nix file.

```sh
nixos-generate-config --root /mnt
```

Run nixos installer with your configuration.nix file.

```sh
nixos-generate-config --root /mnt
```

After the installer is done.

```sh
umount -R /mnt  # recursively unmount everything
reboot
```

# References

## Commands

```sh
nixos-generate-config --root /mnt  # generate *.nix files
```

```sh
nixos-rebuild switch  # build and set new as default
```

```sh
nix-channel --update
nixos-rebuild switch --upgrade
```

```sh
nix-collect-garbage -d  # clear old generations
nix-store --gc
```

## Documentation

- [Create NixOS virtual machine on Proxmox](https://www.edwardhorsey.dev/blog/create-a-nixos-vm-on-proxmox/)
