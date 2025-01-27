
{ config, lib, pkgs, nixalt, unstable, nixmaster, outoftree, inputs, ... }:

{
  imports = [
    ../../modules/grub.nix
    ../../modules/kernel.nix
    ../../modules/linux.nix
    ../../modules/locale.nix
    # ../../modules/my_user.nix
    ../../modules/nix.nix
    ../../modules/ssh_server.nix
  ];

}

