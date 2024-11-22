
{ config, lib, pkgs, nixbeta, unstable, nixmaster, inputs, ... }:

{
  services = {
    fwupd.enable = true;
    fstrim.enable = true;
    hardware.bolt.enable = true;
  };

}

