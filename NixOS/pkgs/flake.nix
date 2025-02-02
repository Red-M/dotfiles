{
  description = "Out Of Tree";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = {self, nixpkgs, ...}@inputs: let
    forAllSys = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.all;
  in {
    pkgs = forAllSys (system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      python3Optimized = pkgs.python3Full.overrideAttrs {
        enableOptimizations = true;
        reproducibleBuild = false;
      };
      pyPkgs = self.pkgs.${system}.python3Optimized.pkgs;

      dropbox = pkgs.callPackage ./dropbox {};
      dropbox-cli = pkgs.callPackage ./dropbox/cli.nix { dropbox = self.pkgs.${system}.dropbox; };

      pipewire-module-xrdp = pkgs.callPackage ./pipewire-module-xrdp {};
      redserv = pkgs.callPackage ./redserv {};
    });
    overlays = {};

  };
}

