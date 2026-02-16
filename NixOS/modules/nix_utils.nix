
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    dconf2nix
    nix-index
    nixfmt
    nvfetcher

    nixos-anywhere
  ];
}

