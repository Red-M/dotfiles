
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ./amdgpu.nix
  ];

  hardware.amdgpu = {
    overdrive = {
      enable = true;
      ppfeaturemask = "0xffffffff";
    };
  };

  services.lact = {
    enable = true;
  };

  # programs.corectrl.enable = true;
  # users.users.redm = {
  #   extraGroups = [ "corectrl" ];
  # };
}

