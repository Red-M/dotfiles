
{ config, lib, pkgs, nixbeta, unstable, nixmaster, inputs, ... }:

{
  services.fprintd.enable = true;

  environment.systemPackages = with pkgs; [
    fprintd
  ];

}

