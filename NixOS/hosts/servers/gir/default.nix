
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../servers
    ../../../modules/servers/znc.nix
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "gir";
  networking.domain = "red-m.net";
  services.openssh.enable = true;
  system.stateVersion = "24.11";

  systemd.services = {
    znc.enable = true;
  };

}

