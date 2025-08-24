{
  description = "My NixOS flake";
  nixConfig = {
    extra-substituters = "https://cache.lix.systems https://cache.nixos.org/ https://nix-community.cachix.org";
    extra-trusted-public-keys = "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
    extra-experimental-features = "nix-command flakes";
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-alt.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
    # nixpkgs-xr.url = "github:nix-community/nixpkgs-xr/58aeae5249afc3cbfe690768392fcd504e1e914a";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    lix-module = {
      # url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.3-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.lix = {
      #   # url = "git+https://git.lix.systems/lix-project/lix";
      #   # url = "git+https://git.lix.systems/lix-project/lix?ref=release-2.93";
      #   inputs.nixpkgs.follows = "nixpkgs";
      # };
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ucodenix = {
      url = "github:e-tho/ucodenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    outoftree = {
      url = "path:./pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-alt, nixpkgs-unstable, lix-module, home-manager, nixos-hardware, nur, fenix, lanzaboote, outoftree, ... }@inputs:
    let inherit (self);
    mkNixOS = {host_modules, system, ...}: nixpkgs.lib.nixosSystem rec {
      inherit system;
      modules = [
        # lix-module.nixosModules.default # I am tired of broken builds, constantly rebuilding lix and never getting it from the cache even when on stable releases from lix themselves, they can have a timeout.
      ] ++ host_modules;
      specialArgs = {
        inherit inputs system nixos-hardware outoftree;
        nixalt = import nixpkgs-alt {
          inherit inputs system;
          config.allowUnfree = true;
        };
        unstable = import nixpkgs-unstable {
          inherit inputs system;
          config.allowUnfree = true;
        };
        nur = import inputs.nur {
          inherit inputs system;
          config.allowUnfree = true;
        };
      };

    };
    forAllSys = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.all;
  in {
    nixosConfigurations = {
      potato = mkNixOS rec {
        system = "x86_64-linux";
        host_modules = [
          ./hosts/potato
        ];
      };

      redm = mkNixOS rec {
        system = "x86_64-linux";
        host_modules = [
          ./hosts/redm
        ];
      };

      redbox = mkNixOS rec {
        system = "x86_64-linux";
        host_modules = [
          ./hosts/redbox
        ];
      };


      gir = mkNixOS rec {
        system = "x86_64-linux";
        host_modules = [
          ./hosts/servers/gir
        ];
      };
      gir3 = mkNixOS rec {
        system = "x86_64-linux";
        host_modules = [
          ./hosts/servers/gir3
        ];
      };
      gir5 = mkNixOS rec {
        system = "x86_64-linux";
        host_modules = [
          ./hosts/servers/gir5
        ];
      };
      gir6 = mkNixOS rec {
        system = "x86_64-linux";
        host_modules = [
          ./hosts/servers/gir6
        ];
      };
      gir7 = mkNixOS rec {
        system = "x86_64-linux";
        host_modules = [
          ./hosts/servers/gir7
        ];
      };
      gir8 = mkNixOS rec {
        system = "x86_64-linux";
        host_modules = [
          ./hosts/servers/gir8
        ];
      };

      gitlab = mkNixOS rec {
        system = "x86_64-linux";
        host_modules = [
          ./hosts/homelab/gitlab
        ];
      };
      mqtt = mkNixOS rec {
        system = "x86_64-linux";
        host_modules = [
          ./hosts/homelab/mqtt
        ];
      };
      hass-hardware = mkNixOS rec {
        system = "x86_64-linux";
        host_modules = [
          ./hosts/homelab/hass-hardware
        ];
      };

    };

    packages = forAllSys (system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      redserv = outoftree.pkgs.${pkgs.system}.redserv;

      redlibssh = outoftree.pkgs.${pkgs.system}.redlibssh;
      redlibssh2 = outoftree.pkgs.${pkgs.system}.redlibssh2;
      redssh = outoftree.pkgs.${pkgs.system}.redssh;
      redexpect = outoftree.pkgs.${pkgs.system}.redexpect;
      serial_portal = outoftree.pkgs.${pkgs.system}.serial_portal;

      reeemiks = outoftree.pkgs.${pkgs.system}.reeemiks;
      znc = outoftree.pkgs.${pkgs.system}.znc;
      znc_clientaway = outoftree.pkgs.${pkgs.system}.zncModules.clientaway;
      lovr = outoftree.pkgs.${pkgs.system}.lovr;
      lovr-playspace = outoftree.pkgs.${pkgs.system}.lovr-playspace;
      vrcadvert = outoftree.pkgs.${pkgs.system}.vrcadvert;
      oscavmgr = outoftree.pkgs.${pkgs.system}.oscavmgr;
      wayvr-dashboard = outoftree.pkgs.${pkgs.system}.wayvr-dashboard;
      wlx-overlay-s = outoftree.pkgs.${pkgs.system}.wlx-overlay-s;
      argbColors = outoftree.pkgs.${pkgs.system}.argbColors;
      resolute = outoftree.pkgs.${pkgs.system}.resolute;
      xrbinder = outoftree.pkgs.${pkgs.system}.xrbinder;
    });

    devShell = forAllSys (system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      unstable_pkgs = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      outoftree = import inputs.outoftree {
        inherit system;
        config.allowUnfree = true;
      };
    in
    pkgs.mkShell {
      buildInputs = with pkgs; [
        outoftree.pkgs.${pkgs.system}.redexpect
      ];
    });

  };
}

