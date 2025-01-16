
{ config, lib, pkgs, nixalt, unstable, nixmaster, outoftree, inputs, ... }:

{
  nixpkgs.overlays = [(pkgfinal: pkgprev:
    {
      freetype_qdoled = pkgprev.freetype.overrideAttrs (old : {
        patches = (old.patches or []) ++ [
          ./patches/freetype/0004-QD-OLED-subpixel.patch
        ];
        useEncumberedCode = true;
      });
    }
  )];

  environment.etc."custom_packages/freetype_qdoled".text = "${pkgs.freetype_qdoled}";

  environment.systemPackages = with pkgs; [
    freetype_qdoled
  ];

}

