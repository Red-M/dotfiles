
{ config, lib, pkgs, nixalt, unstable, nixmaster, inputs, ... }:

{
  users.users.redm = {
    packages = with pkgs; [
      arduino
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

