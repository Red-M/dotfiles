
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../servers
    ../../../modules/servers/znc.nix
  ];

  networking.hostName = "gir";
  system.stateVersion = "24.11";

  systemd.services = {
    znc.enable = true;
  };

}

