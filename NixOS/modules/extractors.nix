
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{

  environment.systemPackages = with pkgs; [
    unzip
    unrar-wrapper
    p7zip
    gzip
    bzip2
    gnutar
    arj
    unar
  ];

}

