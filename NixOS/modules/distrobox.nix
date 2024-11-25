
{ config, lib, pkgs, nixalt, unstable, nixmaster, inputs, ... }:

{
  imports = [
    ./docker.nix
  ];

  environment.systemPackages = with pkgs; [
    distrobox
  ];

}

