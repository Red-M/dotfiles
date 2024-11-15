
{ config, lib, pkgs, unstable, inputs, ... }:

{
  users.users.redm = {
    extraGroups = [ "dialout" ];
  };
}

