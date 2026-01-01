
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../4
    ../../../rpi
  ];

  networking.hostName = "rpi4-1";
  system.stateVersion = "25.11";

  systemd.services = {
  };

}

