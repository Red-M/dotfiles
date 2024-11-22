
{ config, lib, pkgs, nixbeta, unstable, nixmaster, inputs, ... }:

{
  programs = {
    virt-manager.enable = true;
  };
  virtualisation.libvirtd.enable = true;

  users.users.redm = {
    extraGroups = [ "kvm" ];
  };

}

