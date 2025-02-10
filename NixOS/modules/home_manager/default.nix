
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{

  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  home-manager.users.redm = {
    home.stateVersion = "24.11";
  };

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = {
    inherit inputs outoftree;
  };

}

