
{ config, lib, pkgs, unstable, inputs, ... }:

{
  services.hardware.openrgb.enable = true;
  users.users.redm = {
    packages = with pkgs; [
      freecad
      kicad
    ];
  };
}

