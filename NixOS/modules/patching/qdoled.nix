
{ config, lib, pkgs, nixalt, unstable, nixmaster, outoftree, inputs, ... }:

{
  nixpkgs.overlays = [(pkgfinal: pkgprev:
    {
      freetype = pkgprev.freetype.overrideAttrs (old : {
        patches = (old.patches or []) ++ [
          ./patches/freetype/0004-QD-OLED-subpixel.patch
        ];
        useEncumberedCode = true;
      });
    }
  )];
}

