
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  nixpkgs.overlays = [(final: prev: {
    tmuxp = prev.tmuxp.overrideAttrs (old : {
      version = "1.64.0";
      src = pkgs.fetchPypi {
        pname = "tmuxp";
        version = "1.64.0";
        hash = "sha256-jx5duGqxgXqDHfc74mZ6YZlxdW16bYJ3KD5hRReJmCw=";
      };
      pythonRelaxDeps = [
        "libtmux"
      ];
    });
  })];

}

