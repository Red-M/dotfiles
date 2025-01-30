
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  nixpkgs.overlays = [(pkgfinal: pkgprev:
    {
      freetype_qdoled = pkgprev.freetype.overrideAttrs (old : {
        patches = (old.patches or []) ++ [
          ./patches/freetype/0004-QD-OLED-subpixel.patch
        ];
        useEncumberedCode = true;
      });
      google-chrome = pkgprev.google-chrome.override {
        freetype = pkgfinal.freetype_qdoled;
      };
    }
  )];

  environment.etc."custom_packages/freetype_qdoled".text = "${pkgs.freetype_qdoled}";

  environment.systemPackages = with pkgs; [
    freetype_qdoled
  ];

  environment.sessionVariables.LD_LIBRARY_PATH = [
    "${pkgs.freetype_qdoled}/lib"
  ];

}

