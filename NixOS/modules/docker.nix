
{ config, lib, pkgs, nixbeta, unstable, nixmaster, inputs, ... }:

{
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  users.users.redm = {
    extraGroups = [ "docker" ];
  };

}

