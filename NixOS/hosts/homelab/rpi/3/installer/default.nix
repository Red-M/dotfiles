
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ../../3
    ../../../../../modules/ssh_server.nix
    ../../installers.nix
  ];

}

