
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{

  environment.systemPackages = with pkgs; [
    gnumake
    clang_multi
    cmake
    pkg-config
    glib
    glibc
    libgcc
    libglibutil
    libsecret
    libva-utils
  ];

}

