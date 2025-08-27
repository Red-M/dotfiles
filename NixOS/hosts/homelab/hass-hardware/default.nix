
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../homelab
    ../../../modules/servers/hass_hardware.nix
  ];

  networking.hostName = "hass-hardware";
  system.stateVersion = "25.11";

  systemd.services = {
  };

}

