
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ../patching/python.nix
  ];

  users.users.redm = {
    packages = with pkgs; [
      python3

      python3.pkgs.pip
      python3.pkgs.cython
      python3.pkgs.virtualenvwrapper
      python3.pkgs.dbus-python

    ];
    # packages = with pkgs; [
    #   python3Optimized
    #
    #   python3Optimized.pkgs.pip
    #   python3Optimized.pkgs.cython
    #   python3Optimized.pkgs.virtualenvwrapper
    #   python3Optimized.pkgs.dbus-python
    #
    # ];
    # packages = with outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}; [
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

