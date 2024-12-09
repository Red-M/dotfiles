
{ config, lib, pkgs, nixalt, unstable, nixmaster, outoftree, inputs, ... }:

{
  users.users.redm = {
    packages = with outoftree.pkgs.${pkgs.system}; [
      python3Optimized

      pyPkgs.pip
      pyPkgs.cython
      pyPkgs.virtualenvwrapper
      pyPkgs.dbus-python

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

