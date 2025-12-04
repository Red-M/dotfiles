
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = with inputs.nixos-raspberrypi.nixosModules; [
    raspberry-pi-3.base
  ];

}

