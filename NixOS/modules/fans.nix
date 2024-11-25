
{ config, lib, pkgs, nixalt, unstable, nixmaster, inputs, ... }:

{
  programs = {
    coolercontrol.enable = true;
  };

  environment.systemPackages = with pkgs; [
    coolercontrol.coolercontrold
    coolercontrol.coolercontrol-liqctld

  ];
}

