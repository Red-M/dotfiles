
{ config, lib, pkgs, nixbeta, unstable, nixmaster, inputs, ... }:

{
  imports = [
    ./docker.nix
  ];

  environment.systemPackages = with pkgs; [
    distrobox
  ];

}

