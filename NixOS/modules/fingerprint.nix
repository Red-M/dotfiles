
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  services.fprintd.enable = true;

  environment.systemPackages = with pkgs; [
    fprintd
  ];

}

