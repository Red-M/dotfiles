
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ./docker.nix
  ];

  environment.systemPackages = with pkgs; [
    distrobox
  ];

}

