
{ config, lib, pkgs, nixalt, unstable, nixmaster, outoftree, inputs, ... }:

{
  imports = [
    ../patching/python.nix
  ];

  users.users.redm = {
    packages = with pkgs; [
      python3Full

      python3Full.pkgs.pip
      python3Full.pkgs.cython
      python3Full.pkgs.virtualenvwrapper
      python3Full.pkgs.dbus-python

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

