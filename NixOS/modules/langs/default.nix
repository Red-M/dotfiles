
{ config, lib, pkgs, nixalt, unstable, nixmaster, outoftree, inputs, ... }:

{
  imports = [
    ./arduino.nix
    ./go.nix
    ./python.nix
  ];

}

