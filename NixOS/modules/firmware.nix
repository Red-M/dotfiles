
{ config, lib, pkgs, nixalt, unstable, nixmaster, inputs, ... }:

{
  services = {
    fwupd.enable = true;
    fstrim.enable = true;
    hardware.bolt.enable = true;
  };

}

