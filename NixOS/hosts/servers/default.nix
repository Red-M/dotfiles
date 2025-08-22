
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    inputs.disko.nixosModules.disko

    ../../modules/bootloader.nix
    ../../modules/kernel.nix
    ../../modules/linux.nix
    ../../modules/locale.nix
    ../../modules/my_user.nix
    ../../modules/nix.nix
    ../../modules/langs/python.nix
    ../../modules/dropbox.nix
    ../../modules/zram.nix

    ../../modules/servers/ssh_server.nix
    ../../modules/servers/redserv.nix
    ../../modules/servers/mail_relay_out.nix
  ];

  networking.domain = "red-m.net";

  environment.systemPackages = with pkgs; [
    ipset
  ];

  boot = {
    loader = {
      grub = {
        efiSupport = false;
        efiInstallAsRemovable = false;
      };
    };
  };

  systemd.services = {
    dropbox.enable = true;
    redserv.enable = true;
  };

  services = {
    openssh.enable = true;
    journald = {
      extraConfig = lib.mkForce ''
        SystemMaxUse=256M
      '';
    };
  };

  nix = {
    settings = {
      keep-outputs = lib.mkForce false;
      keep-derivations = lib.mkForce false;
      keep-failed = lib.mkForce false;
      keep-going = lib.mkForce true;
    };
  };

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  system.autoUpgrade.enable = true;

  networking = {
    firewall = {
      allowedTCPPorts = [
        80
        443
        8081
        8082
      ];
    };

    nftables = {
      enable = true;
      ruleset = ''
        table ip nat {
          chain PREROUTING {
            type nat hook prerouting priority dstnat; policy accept;
            tcp dport 80 dnat to :8081
          }
        }
      '';
    };
  };

}

