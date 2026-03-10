{ config, pkgs, ... }:

let
  certloc = "/var/lib/acme/app.d35c.net";
in

{
    imports = [
        ./hardware-configuration.nix
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking = {
        hostName = "freestar";
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
                extraGroups = [ "docker" "networkmanager" "wheel" ];
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

    fileSystems."/mnt/media/audio" = {
        device = "//192.168.10.36/audio";
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
        caddy
        dig
    ];

    virtualisation.docker = {
        enable = true;
        extraOptions = "--iptables=false";  # use host firewall
    };

    security.acme = {
        acceptTerms = true;
        defaults.email = "hello@d35c.net";
        certs."app.d35c.net" = {
            group = config.services.caddy.group;
            domain = "app.d35c.net";
            extraDomainNames = [ "*.app.d35c.net" ];
            dnsProvider = "route53";
            dnsResolver = "1.1.1.1:53";
            dnsPropagationCheck = true;
            environmentFile = "/var/secrets/dnscred";
        };
    };

    services = {
    
        caddy = {
            enable=true;
            virtualHosts."localhost".extraConfig = ''
                respond "OK"
            '';
            virtualHosts."navidrome.app.d35c.net".extraConfig = ''
                reverse_proxy http://localhost:4533
      
                tls ${certloc}/cert.pem ${certloc}/key.pem {
                    protocols tls1.3
                }
            '';
        };

        openssh = {
            enable = true;
            openFirewall = true;
        };

        qemuGuest = {
            enable = true;
        };

        xserver.xkb = {
            layout = "us";
            variant = "";
        };

    };

  system.stateVersion = "25.11";
}