
{ config, lib, pkgs, nixalt, unstable, nixmaster, outoftree, inputs, ... }:

{
  nixpkgs.overlays = [(pkgfinal: pkgprev:
    {
      freetype_qdoled = pkgprev.freetype.overrideAttrs (old : {
        patches = (old.patches or []) ++ [
          ./patches/freetype/0004-QD-OLED-subpixel.patch
          # ./patches/freetype/QD-OLED-lcdfilter.patch
        ];
        useEncumberedCode = true;
      });
    }
  )];

  environment.systemPackages = with pkgs; [
    freetype_qdoled
  ];

}

