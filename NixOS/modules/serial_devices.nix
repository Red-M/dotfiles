
{ config, lib, pkgs, nixbeta, unstable, nixmaster, inputs, ... }:

{
  users.users.redm = {
    extraGroups = [ "dialout" ];
  };
}

