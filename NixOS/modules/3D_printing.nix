
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  users.users.redm = {
    packages = with pkgs; [
      cura-appimage
    ];
  };
}

