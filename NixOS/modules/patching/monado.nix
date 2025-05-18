
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  nixpkgs.overlays = [(pkgfinal: pkgprev:
    {
      monado_patched = pkgprev.monado.overrideAttrs (old : {
        # version = old.version+"3";
        src = pkgs.fetchgit {
          url = "https://gitlab.freedesktop.org/monado/monado.git";
          rev = "2a6932d46dad9aa957205e8a47ec2baa33041076";
          fetchSubmodules = false;
          deepClone = false;
          leaveDotGit = false;
          sparseCheckout = [ ];
          sha256 = "sha256-Bus9GTNC4+nOSwN8pUsMaFsiXjlpHYioQfBLxbQEF+0=";
        };
        patches = (old.patches or []) ++ [
          ./patches/monado/2253.patch # solarxr
          # ./patches/monado/2426.patch # index brightness
          ./patches/monado/up_client_max.patch
        ];
      });
    }
  )];

}

