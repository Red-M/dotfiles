
{ config, lib, pkgs, unstable, inputs, ... }:

{
  services = {
    fwupd.enable = true;
  };
}

