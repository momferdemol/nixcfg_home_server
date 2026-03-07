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

  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    dates = "Monday 04:00 UTC";
    rebootWindow = {
      lower = "04:00";
      upper = "06:00";
    };
  };

  nix.gc = {
    automatic = true;
    dates = "Monday 07:00 UTC";
    options = "--delete-older-than 7d";
  };

  # run garbage collection when less than 500MB free space left
  nix.extraOptions = ''
    min-free = ${toString (500 * 1024 * 1024)}
  '';

  # clean up system logs old then 1 month
  systemd = {
    services.qemu-guest-agent = {
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
    };
    services.clear-log = {
      description = "clean 30+ old logs every week";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.systemd}/bin/journalctl --vacuum-time=30d";
      };
    };
    timers.clear-log = {
      wantedBy = [ "timers.target" ];
      partOf = [ "clear-log.service" ];
      timerConfig.OnCalendar = "weekly UTC";
    };
  };

  networking = {
    hostName = "unbound";
    useDHCP = false;
    interfaces.ens18 = {
      ipv4.addresses = [
        {
          address = "192.168.10.10";
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
      allowedUDPPorts = [ 53 ];
      allowedTCPPorts = [ 53 ];
    };
  };

  time.timeZone = "Europe/Amsterdam";

  i18n.defaultLocale = "en_US.UTF-8";

  users = {
    users = {
      unbound = {
        home = "/var/lib/unbound";
        createHome = true;
        isSystemUser = true;
        group = "unbound";
      };
    };

    groups = {
      unbound = {
        members = [ "unbound" ];
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
    dig
    unbound
  ];

  services = {
    unbound = {
      enable = true;
      user = "unbound";
      group = "unbound";
      settings = {
        server = {
          verbosity = 1;
          auto-trust-anchor-file = "/var/lib/unbound/root.key";
          qname-minimisation = true;
          interface = "0.0.0.0";
          access-control = "192.168.0.0/16 allow";
          private-domain = "lan.d35c.net";
          local-zone = "\"lan.d35c.net.\" redirect";
          local-data = [
            "\"lan.d35c.net.\tIN A 192.168.10.11\""
          ];
        };

        forward-zone = [
          {
            name = ".";
            forward-addr = [
              "1.1.1.1"
              "9.9.9.9"
            ];
          }
        ];

        remote-control = {
          control-enable = false;
        };
      };
      enableRootTrustAnchor = true;
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

  system.stateVersion = "25.05";
}