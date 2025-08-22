
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ./bootloader.nix
  ];

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        efiInstallAsRemovable = false;
      };
    };
  };

}

