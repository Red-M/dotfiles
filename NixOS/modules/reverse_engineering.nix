
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

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

      gdb
      gdbgui
      gf
      cgdb
      seer
      xxgdb
      # pwndbg
      gef
      kdbg
      radare2
      iaito
      valgrind
    ];
  };
}

