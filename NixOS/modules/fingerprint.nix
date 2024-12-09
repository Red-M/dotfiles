
{ config, lib, pkgs, nixalt, unstable, nixmaster, outoftree, inputs, ... }:

{
  services.fprintd.enable = true;

  environment.systemPackages = with pkgs; [
    fprintd
  ];

}

