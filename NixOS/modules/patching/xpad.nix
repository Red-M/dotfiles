
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  nixpkgs.overlays = [(pkgfinal: pkgprev:
    {
      linuxPackages_latest = pkgprev.linuxPackages_latest.extend(_lfinal: lprev: {
        xpadneo = lprev.xpadneo.overrideAttrs (old : { # https://github.com/NixOS/nixpkgs/pull/497943
          version = "0.10";
          src = pkgs.fetchFromGitHub {
            owner = "atar-axis";
            repo = "xpadneo";
            tag = "v0.10";
            hash = "sha256-jIY7NzjVZMlJ+2EY4hrka1MBUalQiNWzQgW2aiNi7WU=";
          };
        });
        xpad-noone = lprev.xpad-noone.overrideAttrs (old : {
          patches = [
            # https://github.com/medusalix/xpad-noone/pull/9
            (pkgs.fetchpatch2 {
              name = "remove-usage-of-deprecated-ida-simple-xx-api.patch";
              url = "https://github.com/medusalix/xpad-noone/commit/e0f6ad5f2fabd5f8e74796a87154c92c8e9b6068.patch";
              hash = "sha256-7Ye/rd51RpzThgts8R5RT0CRVvx5bKmy5i0KPidic30=";
            })
          ];
        });
      });
    }
  )];

}

