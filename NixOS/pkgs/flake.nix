{
  description = "Out Of Tree";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
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
      unstable_pkgs = import inputs.nixpkgs-unstable {
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

      argbColors = pkgs.callPackage ./argbColors {};
      coolercontrol = pkgs.callPackage ./coolercontrol {};
      it87 = pkgs.callPackage ./it87 { kernel = pkgs.linuxKernel.kernels.linux_6_15; };

      ## VR
      wayvr-dashboard = pkgs.callPackage ./wayvr-dashboard {};
      lovr = pkgs.callPackage ./lovr {};
      lovr-playspace = pkgs.callPackage ./lovr-playspace { lovr = self.pkgs.${system}.lovr; };
      vrcadvert = pkgs.callPackage ./vrcadvert {};
      oscavmgr = pkgs.callPackage ./oscavmgr {};
      wlx-overlay-s = pkgs.callPackage ./wlx-overlay-s { unstable = unstable_pkgs; };
      xrizer = pkgs.callPackage ./xrizer {};
      eepyxr = pkgs.callPackage ./eepyxr {
        zig = unstable_pkgs.zig;
        sdl3 = unstable_pkgs.sdl3;
      };
      resolute = pkgs.callPackage ./resolute {};
      xrbinder = pkgs.callPackage ./xrbinder {};

    });

  };
}

