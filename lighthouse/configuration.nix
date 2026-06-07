{ config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking = {
        hostName = "Starstation";
        networkmanager = {
            enable = true;
        };
        firewall = {
            enable = true;
            allowedUDPPorts = [ 4242 ];
            # allowedTCPPorts = [ 4242 ];
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
        };
    };

    programs.bash = {
        loginShellInit = ''
            ${pkgs.fastfetch}/bin/fastfetch
        '';
    };

    environment.systemPackages = with pkgs; [
        fastfetch
        docker_29
    ];

    virtualisation.docker = {
        enable = true;
        extraOptions = "--iptables=false";  # use host firewall
    };

    services = {
    
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