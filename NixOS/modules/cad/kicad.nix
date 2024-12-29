
{ config, lib, pkgs, nixalt, unstable, nixmaster, outoftree, inputs, ... }:

{
  users.users.redm = {
    packages = with pkgs; [
      kicad
      easyeda2kicad
      turbocase
    ];
  };
}

