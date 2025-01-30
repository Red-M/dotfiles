
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ./freecad.nix
    ./kicad.nix
  ];

}

