
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../3
    ../../../rpi
  ];

  networking.hostName = "rpi3-0";
  system.stateVersion = "25.11";

  systemd.services = {
  };

}

