
{ config, lib, pkgs, nixalt, unstable, nixmaster, inputs, ... }:

{
  users.users.redm = {
    packages = with pkgs; [
      python3
      python3Packages.virtualenvwrapper
      python3Packages.dbus-python

    ];
  };
  programs = {
    nix-ld = {
      libraries = with pkgs; [
        dbus.lib
        dbus-glib
      ];
    };
  };
}

