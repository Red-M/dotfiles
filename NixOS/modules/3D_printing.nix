
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ./patching/cura.nix
  ];
  users.users.redm = {
    packages = with pkgs; [
      cura-appimage
    ];
  };
}

