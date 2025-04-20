
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  nixpkgs.overlays = [(pkgfinal: pkgprev:
    {
      redserv = outoftree.pkgs.${pkgs.system}.redserv.overrideAttrs (old : {
        # python312 = pkgs.python3Optimized;
      });
    }
  )];

}

