
{ config, lib, pkgs, unstable, inputs, ... }:

{
  programs = {
    virt-manager.enable = true;
  };
  virtualisation.libvirtd.enable = true;

}

