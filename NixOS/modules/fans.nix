
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  programs = {
    coolercontrol.enable = true;
  };

  environment.systemPackages = with pkgs; [
    coolercontrol.coolercontrold
    coolercontrol.coolercontrol-liqctld

  ];
}

