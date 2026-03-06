{ config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
    ];

    boot.loader.grub = {
        enable = true;
        device = "/dev/sda";
        useOSProber = true;
    };

    networking = {
        hostName = "freestar";
        useDHCP = false;
        interfaces.ens18 = {
            ipv4.addresses = [
                {
                    address = "192.168.10.15";
                    prefixLength = 32;
                }
            ];
        };
        defaultGateway = {
            address = "192.168.10.1";
            interface = "ens18";
        };
        networkmanager = {
            enable = true;
        };
        firewall = {
            enable = true;
            allowedUDPPorts = [ 80 443 2049 ];
            allowedTCPPorts = [ 80 443 2049 ];
        };
    };

    time.timeZone = "Europe/Amsterdam";
    i18n.defaultLocale = "en_US.UTF-8";

    users = {
        users = {
            operator = {
                home = "/home/operator";
                isNormalUser = true;
                createHome = true;
                initialPassword = "operatorwho";
                group = "operator";
                extraGroups = [ "networkmanager" "wheel" ];
            };
        };

        groups = {
            operator = {
                name = "operator";
                members = [ "operator" ];
            };
            mediashare = {
                name = "mediashare";
                members = [ "operator" ];
            };
        };
    };

    fileSystems."/mnt/mediashare" = {
        device = "//192.168.10.26/Media";
        fsType = "cifs";
        options =
        [
            "credentials=/var/secrets/smbcred"
            "uid=1000"
            "gid=${toString config.users.groups.mediashare.gid}"
        ]
        ++ [
            "noauto"
            "x-systemd.automount"
            "x-systemd.idle-timeout=300"
            "x-systemd.device-timeout=5s"
            "x-systemd.mount-timeout=5s"
        ];
    };

    programs.bash = {
        loginShellInit = ''
            ${pkgs.fastfetch}/bin/fastfetch
        '';
    };

    environment.systemPackages = with pkgs; [
        fastfetch
        docker_29
        dig
    ];

    virtualisation.docker = {
        enable = true;
    };

    services = {
    
        openssh = {
            enable = true;
        };

        qemuGuest = {
            enable = true;
        };

        xserver.xkb = {
            layout = "us";
            variant = "";
        };

    };

  system.stateVersion = "25.05";
}