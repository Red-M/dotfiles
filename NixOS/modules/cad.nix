
{ config, lib, pkgs, nixalt, unstable, nixmaster, outoftree, inputs, ... }:

{
  users.users.redm = {
    packages = with pkgs; [
      freecad
      # kicad # broken on 24.11
    ];
  };
}
