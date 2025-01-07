
{ config, lib, pkgs, nixalt, unstable, nixmaster, outoftree, inputs, ... }:

{
  nixpkgs.overlays = [(pkgfinal: pkgprev:
    {
      python3Optimized = pkgprev.python3Full.override {
        enableOptimizations = true;
        reproducibleBuild = false;
      };

      # python3 = pkgprev.python3.override {
      #   enableOptimizations = true;
      #   reproducibleBuild = false;
      # };
      # python3Full = pkgprev.python3Full.override {
      #   enableOptimizations = true;
      #   reproducibleBuild = false;
      # };
      #
      # python38 = pkgprev.python38.override {
      #   enableOptimizations = true;
      #   reproducibleBuild = false;
      # };
      # python39 = pkgprev.python39.override {
      #   enableOptimizations = true;
      #   reproducibleBuild = false;
      # };
      # python310 = pkgprev.python310.override {
      #   enableOptimizations = true;
      #   reproducibleBuild = false;
      # };
      # python311 = pkgprev.python311.override {
      #   enableOptimizations = true;
      #   reproducibleBuild = false;
      # };
      # python312 = pkgprev.python312.override {
      #   enableOptimizations = true;
      #   reproducibleBuild = false;
      # };
      # python313 = pkgprev.python313.override {
      #   enableOptimizations = true;
      #   reproducibleBuild = false;
      # };
    }
  )];
}

