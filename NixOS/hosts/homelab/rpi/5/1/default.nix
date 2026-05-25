
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../5
    ../../../rpi
    ../../../../../modules/servers/rpi_ntp_gpsd.nix
  ];

  networking.hostName = "rpi5-1";
  system.stateVersion = "25.11";

  systemd.services = {
  };

}

