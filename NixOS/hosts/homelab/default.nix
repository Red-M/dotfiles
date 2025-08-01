
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ../../modules/grub.nix
    ../../modules/kernel.nix
    ../../modules/linux.nix
    ../../modules/locale.nix
    ../../modules/my_user.nix
    ../../modules/nix.nix
    ../../modules/langs/python.nix

    ../../modules/ssh_server.nix
    ../../modules/servers/kvm_guest.nix
    ../../modules/servers/mail_relay_out.nix
  ];

  networking.domain = "bubble-berry";

  environment.systemPackages = with pkgs; [
    ipset
  ];

  services = {
    journald = {
      extraConfig = ''
        SystemMaxUse=256M
      '';
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
      ];
    };

    nftables = {
      enable = true;
      # ruleset = ''
      # '';
    };
  };

}

