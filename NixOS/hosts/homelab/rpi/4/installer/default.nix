
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ../../4
    ../../../../../modules/ssh_server.nix
    ../../installers.nix
  ];

}

