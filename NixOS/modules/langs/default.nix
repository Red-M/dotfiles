
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ./arduino.nix
    ./go.nix
    ./python.nix
  ];

}

