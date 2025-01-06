
{ config, lib, pkgs, nixalt, unstable, nixmaster, outoftree, inputs, ... }:

{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  # virtualisation.docker.enable = true;
  # virtualisation.docker.rootless = {
  #   enable = true;
  #   setSocketVariable = true;
  # };

  users.users.redm = {
    extraGroups = [ "docker" ];
  };

}

