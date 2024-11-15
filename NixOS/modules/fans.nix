
{ config, lib, pkgs, unstable, inputs, ... }:

{
  programs = {
    coolercontrol.enable = true;
  };

  environment.systemPackages = with pkgs; [
    coolercontrol.coolercontrold
    coolercontrol.coolercontrol-liqctld

  ];
}

