
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect

    ../../servers
  ];

  networking.hostName = "gir8";
  system.stateVersion = "24.11";

}

