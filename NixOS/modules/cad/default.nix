
{ config, lib, pkgs, nixalt, unstable, nixmaster, outoftree, inputs, ... }:

{
  imports = [
    ./freecad.nix
    ./kicad.nix
  ];

}

