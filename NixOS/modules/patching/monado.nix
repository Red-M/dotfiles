
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  nixpkgs.overlays = [(pkgfinal: pkgprev:
    {
      monado_patched = pkgfinal.monado.overrideAttrs (old : {
        version = old.version+"3";
        # src = pkgs.fetchgit {
        #   url = "https://gitlab.freedesktop.org/monado/monado.git";
        #   rev = "3eda5cbf1efcf075d5a0594991944639541b5dfa";
        #   fetchSubmodules = false;
        #   deepClone = false;
        #   leaveDotGit = false;
        #   sparseCheckout = [ ];
        #   sha256 = "sha256-NSOvFqIOo7QLya9ipGAdO/Vm9ryEQiPfP6ptxSfmpLc=";
        # };
        src = pkgs.fetchgit {
          url = "https://gitlab.freedesktop.org/monado/monado.git";
          rev = "1d37e1d6c8c0fa7c86f8cea029c5d12ee43d3f12";
          fetchSubmodules = false;
          deepClone = false;
          leaveDotGit = false;
          sparseCheckout = [ ];
          sha256 = "sha256-4iQjNpPyH423Z07YohWEvvE/VX6bCcZ4GafL5KST9gg=";
        };
        patches = (old.patches or []) ++ [
          # ./patches/monado/2253.patch # solarxr
          # ./patches/monado/2426.patch # index brightness
          # ./patches/monado/2522.patch # regession fix for 2509
          ./patches/monado/up_client_max.patch
        ];
      });
    }
  )];

}

