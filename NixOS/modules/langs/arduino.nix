
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  users.users.redm = {
    packages = with pkgs; [
      arduino
      arduino-cli
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

