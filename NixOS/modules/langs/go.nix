
{ config, lib, pkgs, nixalt, unstable, nixmaster, inputs, ... }:

{
  users.users.redm = {
    packages = with pkgs; [
      go
    ];
  };
  # programs = {
  #   nix-ld = {
  #     libraries = with pkgs; [
  #       dbus.lib
  #       dbus-glib
  #     ];
  #   };
  # };
}

