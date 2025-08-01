
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  zramSwap = {
    enable = true;
  };
  services.zram-generator = {
    enable = true;
  };
}

