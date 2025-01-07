
{ config, lib, pkgs, nixalt, unstable, nixmaster, outoftree, inputs, ... }:

{
  imports = [
    ../patching/python.nix
  ];

  users.users.redm = {
    packages = with pkgs; [
      python3Optimized

      python3Optimized.pkgs.pip
      python3Optimized.pkgs.cython
      python3Optimized.pkgs.virtualenvwrapper
      python3Optimized.pkgs.dbus-python

    ];
    # packages = with outoftree.pkgs.${pkgs.system}; [
    #   python3Optimized
    #
    #   pyPkgs.pip
    #   pyPkgs.cython
    #   pyPkgs.virtualenvwrapper
    #   pyPkgs.dbus-python
    #
    # ];
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

