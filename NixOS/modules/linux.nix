
{ config, lib, pkgs, unstable, inputs, ... }:

{
  services.envfs.enable = true;

  programs = {
    # This fixes issues with libraries not being found to be more linux compatiable
    nix-ld = { enable = true; libraries = pkgs.steam-run.fhsenv.args.multiPkgs pkgs; };
  };

  # Allows running AppImage
  programs.appimage.enable = true;
  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

}

