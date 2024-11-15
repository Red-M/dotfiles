
{ config, lib, pkgs, unstable, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    distrobox
  ];
}

