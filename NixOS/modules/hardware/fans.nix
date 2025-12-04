
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{

  nixpkgs.overlays = [(final: prev: {
    # coolercontrol = outoftree.pkgs.${pkgs.system}.coolercontrol; # Updates to newer version https://github.com/NixOS/nixpkgs/pull/394379
  })];

  programs = {
    coolercontrol = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    coolercontrol.coolercontrold
    # coolercontrol.coolercontrol-liqctld
    liquidctl
    lm_sensors

  ];

}

