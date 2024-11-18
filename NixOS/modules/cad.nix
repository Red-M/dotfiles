
{ config, lib, pkgs, unstable, inputs, ... }:

{
  users.users.redm = {
    packages = with pkgs; [
      freecad
      # kicad # broken on 24.11
    ];
  };
}

