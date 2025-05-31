
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  nixpkgs.overlays = [(pkgfinal: pkgprev:
    {
      monado_patched = pkgfinal.monado.overrideAttrs (old : {
        # version = old.version+"3";
        # src = pkgs.fetchgit {
        #   url = "https://gitlab.freedesktop.org/monado/monado.git";
        #   rev = "155488d2a1c32679f1bcd29d7959866c367a2194";
        #   fetchSubmodules = false;
        #   deepClone = false;
        #   leaveDotGit = false;
        #   sparseCheckout = [ ];
        #   sha256 = "sha256-O2naX8aTLpr4UcdRbsvFNpVAVU2CaKRAZaPjxf5RBwY=";
        # };
        patches = (old.patches or []) ++ [
          # ./patches/monado/2253.patch # solarxr
          # ./patches/monado/2426.patch # index brightness
          ./patches/monado/up_client_max.patch
        ];
      });
    }
  )];

}

