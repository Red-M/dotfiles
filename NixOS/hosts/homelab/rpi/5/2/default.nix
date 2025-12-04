
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../5
    ../../../rpi
  ];

  networking.hostName = "rpi5-2";
  system.stateVersion = "25.11";

  systemd.services = {
  };

}

