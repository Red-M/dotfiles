
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  nixpkgs.overlays = [(final: prev: {
    openrgb_1_0 = final.openrgb.overrideAttrs (old : {
      version = old.version+"1337";
      __intentionallyOverridingVersion = true;
      src = pkgs.fetchgit {
        url = "https://codeberg.org/OpenRGB/OpenRGB.git";
        rev = "72dc73cf88aa9079394ba245ff97da9ab9c1699c";
        fetchSubmodules = false;
        deepClone = false;
        leaveDotGit = false;
        sparseCheckout = [ ];
        sha256 = "sha256-7f2LVWurmDFpwIJN9m2g32wn57gSsnIX0VZYrqju3Xk=";
      };
      patches = [];
      postPatch = ''
        patchShebangs scripts/build-udev-rules.sh
        substituteInPlace scripts/build-udev-rules.sh \
          --replace-fail "/usr/bin/env chmod" "${pkgs.coreutils}/bin/chmod"

        patchShebangs scripts/git-get-branch.sh
        substituteInPlace scripts/git-get-branch.sh \
          --replace-fail git "${pkgs.git}/bin/git"
        '';
    });
  })];

}

