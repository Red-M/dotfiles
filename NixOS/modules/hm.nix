
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{

  imports = [
    ./home_manager
  ];

  home-manager.users.redm = import ./home_manager/hm.nix;

}

