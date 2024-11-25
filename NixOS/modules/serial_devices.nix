
{ config, lib, pkgs, nixalt, unstable, nixmaster, inputs, ... }:

{
  users.users.redm = {
    extraGroups = [ "dialout" ];
  };
}

