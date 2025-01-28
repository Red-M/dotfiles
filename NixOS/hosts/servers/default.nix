
{ config, lib, pkgs, nixalt, unstable, nixmaster, outoftree, inputs, ... }:

{
  imports = [
    ../../modules/kernel.nix
    ../../modules/linux.nix
    ../../modules/locale.nix
    ../../modules/my_user.nix
    ../../modules/nix.nix
    ../../modules/ssh_server.nix
    ../../modules/langs/python.nix
  ];

  environment.systemPackages = with pkgs; [
    outoftree.packages.${pkgs.system}.dropbox
    outoftree.packages.${pkgs.system}.dropbox-cli
  ];

}

