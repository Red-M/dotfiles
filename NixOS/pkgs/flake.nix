{
  description = "Out Of Tree";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
  };

  outputs = {self, nixpkgs, nixpkgs-xr, ...}@inputs: let
    forAllSys = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.all;
  in {
    pkgs = forAllSys (system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.rocmSupport = true;
      };
      unstable_pkgs = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
        config.rocmSupport = true;
      };
    in {

      amdgpu-kernel-module = pkgs.callPackage ./amdgpu-kernel-module {};

      python3Optimized = pkgs.python3Full.overrideAttrs {
        enableOptimizations = true;
        reproducibleBuild = false;
      };
      pyPkgs = self.pkgs.${system}.python3Optimized.pkgs;

      redserv = pkgs.callPackage ./redserv {};
      redlibssh = pkgs.python3Packages.callPackage ./redlibssh {};
      redlibssh2 = pkgs.python3Packages.callPackage ./redlibssh2 {};
      redssh = pkgs.python3Packages.callPackage ./redssh { redlibssh2 = self.pkgs.${system}.redlibssh2; redlibssh = self.pkgs.${system}.redlibssh; };
      redexpect = pkgs.python3Packages.callPackage ./redexpect { redssh = self.pkgs.${system}.redssh; };
      serial_portal = pkgs.python3Packages.callPackage ./serial_portal { redexpect = self.pkgs.${system}.redexpect; };

      pipewire-module-xrdp = pkgs.callPackage ./pipewire-module-xrdp {};

      dropbox = pkgs.callPackage ./dropbox {};
      dropbox-cli = pkgs.callPackage ./dropbox/cli.nix { dropbox = self.pkgs.${system}.dropbox; };
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
      xrizer = pkgs.callPackage ./xrizer/package.nix {};
      xrizer_multiarch = pkgs.callPackage ./xrizer/multiarch.nix {xrizer = self.pkgs.${system}.xrizer;};
      monado = pkgs.callPackage ./monado/package.nix {
        inherit (pkgs.gst_all_1) gstreamer gst-plugins-base;
      };
      monado_multiarch = pkgs.callPackage ./monado/multiarch.nix {monado = self.pkgs.${system}.monado;};
      eepyxr = pkgs.callPackage ./eepyxr {
        zig = unstable_pkgs.zig;
        sdl3 = unstable_pkgs.sdl3;
      };
      resolute = pkgs.callPackage ./resolute {};
      xrbinder = pkgs.callPackage ./xrbinder {};
      go-bsb-cams = pkgs.callPackage ./go-bsb-cams {};
      baballonia = pkgs.callPackage ./baballonia {};


    });

  };
}

