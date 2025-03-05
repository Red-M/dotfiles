
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  nixpkgs.overlays = [(pkgfinal: pkgprev:
    {
      monado_patched = pkgfinal.monado.overrideAttrs (old : {
        # version = old.version+"3";
        patches = (old.patches or []) ++ [
          ./patches/monado/2253.patch
          ./patches/monado/2389.patch
          ./patches/monado/2426.patch
          ./patches/monado/up_client_max.patch
        ];
      });
    }
  )];

}

