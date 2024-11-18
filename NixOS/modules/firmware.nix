
{ config, lib, pkgs, unstable, inputs, ... }:

{
  services = {
    fwupd.enable = true;
    fstrim.enable = true;
    hardware.bolt.enable = true;
  };

}

