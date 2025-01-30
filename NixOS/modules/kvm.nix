
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  programs = {
    virt-manager.enable = true;
  };
  virtualisation.libvirtd.enable = true;

  users.users.redm = {
    extraGroups = [ "kvm" ];
  };

}

