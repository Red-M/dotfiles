
{ config, lib, pkgs, nixalt, unstable, nixmaster, inputs, ... }:

{
  services.fprintd.enable = true;

  environment.systemPackages = with pkgs; [
    fprintd
  ];

}

