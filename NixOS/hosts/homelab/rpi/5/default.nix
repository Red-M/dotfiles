
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = with inputs.nixos-raspberrypi.nixosModules; [
    raspberry-pi-5.base
    raspberry-pi-5.page-size-16k
    raspberry-pi-5.display-vc4
    raspberry-pi-5.bluetooth
  ];

}

