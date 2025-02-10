
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  services.home-manager.autoUpgrade = {
    enable = true;
    frequency = "weekly";
  };
}

