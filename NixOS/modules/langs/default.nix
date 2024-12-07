
{ config, lib, pkgs, nixalt, unstable, nixmaster, inputs, ... }:

{
  imports = [
    ./arduino.nix
    ./go.nix
    ./python.nix
  ];

}

