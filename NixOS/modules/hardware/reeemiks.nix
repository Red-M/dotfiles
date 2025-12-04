
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{

  users.users.redm = {
    packages = with pkgs; [
      outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.reeemiks
    ];
  };

  home-manager.users.redm = import ./home_manager/reeemiks.nix;

}

