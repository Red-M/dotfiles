
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  services.hardware.openrgb.enable = true;
  users.users.redm = {
    packages = with pkgs; [
      openrgb-with-all-plugins
    ];
  };
}

