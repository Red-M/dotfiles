{
  description = "Out Of Tree";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
  };

  outputs = {self, nixpkgs, nixpkgs-xr, ...}@inputs: let
    forAllSys = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.all;
  in {
    pkgs = forAllSys (system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {

      amdgpu-kernel-module = pkgs.callPackage ./amdgpu-kernel-module {};

      python3Optimized = pkgs.python3Full.overrideAttrs {
        enableOptimizations = true;
        reproducibleBuild = false;
      };
      pyPkgs = self.pkgs.${system}.python3Optimized.pkgs;

      pipewire-module-xrdp = pkgs.callPackage ./pipewire-module-xrdp {};

      dropbox = pkgs.callPackage ./dropbox {};
      dropbox-cli = pkgs.callPackage ./dropbox/cli.nix { dropbox = self.pkgs.${system}.dropbox; };
      redserv = pkgs.callPackage ./redserv {};
      reeemiks = pkgs.callPackage ./reeemiks {};

      znc = pkgs.callPackage ./znc {};
      zncModules = pkgs.callPackage ./znc/modules.nix { znc = self.pkgs.${system}.znc; };

      ## VR
      # broken on openxr or no longer being used
      ovras = pkgs.libsForQt5.callPackage ./ovras {};
      wayvr-dashboard = pkgs.callPackage ./wayvr-dashboard {};

      lovr = pkgs.callPackage ./lovr {};
      lovr-playspace = pkgs.callPackage ./lovr-playspace { lovr = self.pkgs.${system}.lovr; };
      vrcadvert = pkgs.callPackage ./vrcadvert {};
      oscavmgr = pkgs.callPackage ./oscavmgr {};
      adgobye = pkgs.callPackage ./adgobye {};
      wlx-overlay-s = pkgs.callPackage ./wlx-overlay-s {};

      vr_start = pkgs.callPackage ./vr_start {
        vrcadvert = self.pkgs.${system}.vrcadvert;
        oscavmgr = self.pkgs.${system}.oscavmgr;
        lovr-playspace = self.pkgs.${system}.lovr-playspace;
        adgobye = self.pkgs.${system}.adgobye;
        motoc = pkgs.motoc;
        wlx-overlay-s = nixpkgs-xr.outputs.packages.${system}.wlx-overlay-s;
        index_camera_passthrough = nixpkgs-xr.outputs.packages.${system}.index_camera_passthrough;
      };

    });

  };
}

