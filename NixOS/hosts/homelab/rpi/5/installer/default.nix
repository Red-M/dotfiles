
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ../../5
    ../../../../../modules/ssh_server.nix
    ../../installers.nix
  ];

}

