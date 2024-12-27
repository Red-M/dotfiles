
{ config, lib, pkgs, nixalt, unstable, nixmaster, outoftree, inputs, ... }:

{
  users.users.redm = {
    packages = with pkgs; [
      (pkgs.ghidra.withExtensions(p: with p; [
        ret-sync
        findcrypt
        gnudisassembler
        ghidraninja-ghidra-scripts
        ghidra-delinker-extension
        ghidra-golanganalyzerextension
      ]))
    ];
  };
}

