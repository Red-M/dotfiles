
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  services = {
    fwupd.enable = true;
    fstrim.enable = true;
    hardware.bolt.enable = true;
  };
  hardware.enableAllFirmware = true;

}

