
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{

  users.users.redm = {
    packages = with pkgs; [
      outoftree.pkgs.${pkgs.system}.reeemiks
    ];
  };

  home-manager.users.redm = import ./home_manager/reeemiks.nix;

}

