{
  description = "My NixOS flake";
  nixConfig = {
    extra-substituters = [
      "https://cache.lix.systems"
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
      "https://nixos-raspberrypi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
    extra-experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-alt.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";


    # lix-module = { # waiting until this is "stable" from lix
    #   url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
    #   # url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.3-1.tar.gz";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.lix = {
    #     url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
    #     flake = false;
    #   };
    # };

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
    };
    nixos-raspberrypi = {
      # url = "github:Red-M/nixos-raspberrypi/develop"; # https://github.com/nvmd/nixos-raspberrypi/issues/90
      # url = "github:nvmd/nixos-raspberrypi/develop"; # https://github.com/nvmd/nixos-raspberrypi/issues/90
      url = "github:nvmd/nixos-raspberrypi/main"; # https://github.com/nvmd/nixos-raspberrypi/issues/90
      # inputs.nixpkgs.follows = "nixpkgs"; # https://github.com/NixOS/nixpkgs/pull/398456
      inputs.nixpkgs.url = "github:nvmd/nixpkgs/modules-with-keys-unstable"; # https://github.com/NixOS/nixpkgs/pull/398456
    };
    nixos-images = {
      url = "github:nvmd/nixos-images/sdimage-installer";
      inputs.nixos-stable.follows = "nixpkgs";
      inputs.nixos-unstable.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ucodenix = {
      url = "github:e-tho/ucodenix";
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

  outputs = { self, nixpkgs, nixpkgs-alt, nixpkgs-unstable, home-manager, nixos-hardware, nixos-raspberrypi, nixos-images, nur, fenix, lanzaboote, outoftree, ... }@inputs:
    let inherit (self);

    unstable = {system, ...}: import nixpkgs-unstable {
      inherit inputs system;
      config.allowUnfree = true;
    };
    nixalt = {system, ...}: import nixpkgs-alt {
      inherit inputs system;
      config.allowUnfree = true;
    };
    nur = {system, ...}: import inputs.nur {
      inherit inputs system;
      config.allowUnfree = true;
    };

    mkNixOS = {host_modules, system, ...}: nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        # lix-module.nixosModules.default
      ] ++ host_modules;
      specialArgs = {
        inherit inputs system nixos-hardware outoftree;
        unstable = unstable {inherit system;};
        nixalt = nixalt {inherit system;};
        nur = nur {inherit system;};
      };

    };

    mkNixOSrpi = {host_modules, system, ...}: nixos-raspberrypi.lib.nixosSystem {
      inherit system;
      modules = [
        # lix-module.nixosModules.default
      ] ++ host_modules;
      specialArgs = {
        inherit inputs system nixos-hardware nixos-raspberrypi outoftree;
        unstable = unstable {inherit system;};
        nixalt = nixalt {inherit system;};
        nur = nur {inherit system;};
      };

    };

    mkRPiInstaller = {host_modules, system, ...}: nixos-raspberrypi.lib.nixosInstaller {
      inherit system;
      specialArgs = {
        inherit inputs system nixos-hardware nixos-raspberrypi outoftree;
        unstable = unstable {inherit system;};
        nixalt = nixalt {inherit system;};
        nur = nur {inherit system;};
      };
      modules = [
        nixos-images.nixosModules.sdimage-installer
        ({ config, lib, modulesPath, ... }: {
          disabledModules = [
            # disable the sd-image module that nixos-images uses
            (modulesPath + "/installer/sd-card/sd-image-aarch64-installer.nix")
          ];
          # nixos-images sets this with `mkForce`, thus `mkOverride 40`
          image.baseName = let
            cfg = config.boot.loader.raspberryPi;
          in lib.mkOverride 40 "nixos-installer-rpi${cfg.variant}-${cfg.bootloader}";
        })
      ] ++ host_modules;
    };

    forAllSys = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.all;
  in {
    nixosConfigurations = {
      potato = mkNixOS {
        system = "x86_64-linux";
        host_modules = [
          ./hosts/potato
        ];
      };

      redm = mkNixOS {
        system = "x86_64-linux";
        host_modules = [
          ./hosts/redm
        ];
      };

      redbox = mkNixOS {
        system = "x86_64-linux";
        host_modules = [
          ./hosts/redbox
        ];
      };


      gir = mkNixOS {
        system = "x86_64-linux";
        host_modules = [
          ./hosts/servers/gir
        ];
      };
      gir3 = mkNixOS {
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
      gir6 = mkNixOS {
        system = "x86_64-linux";
        host_modules = [
          ./hosts/servers/gir6
        ];
      };
      gir7 = mkNixOS {
        system = "x86_64-linux";
        host_modules = [
          ./hosts/servers/gir7
        ];
      };
      gir8 = mkNixOS {
        system = "x86_64-linux";
        host_modules = [
          ./hosts/servers/gir8
        ];
      };

      gitlab = mkNixOS {
        system = "x86_64-linux";
        host_modules = [
          ./hosts/homelab/gitlab
        ];
      };
      mqtt = mkNixOS {
        system = "x86_64-linux";
        host_modules = [
          ./hosts/homelab/mqtt
        ];
      };
      hass-hardware = mkNixOS {
        system = "x86_64-linux";
        host_modules = [
          ./hosts/homelab/hass-hardware
        ];
      };

      rpi3-0 = mkNixOSrpi {
        system = "aarch64-linux";
        host_modules = [
          ./hosts/homelab/rpi/3/0
        ];
      };
      rpi4-0 = mkNixOSrpi {
        system = "aarch64-linux";
        host_modules = [
          ./hosts/homelab/rpi/4/0
        ];
      };
      rpi4-1 = mkNixOSrpi {
        system = "aarch64-linux";
        host_modules = [
          ./hosts/homelab/rpi/4/1
        ];
      };
      rpi5-0 = mkNixOSrpi {
        system = "aarch64-linux";
        host_modules = [
          ./hosts/homelab/rpi/5/0
        ];
      };
      rpi5-1 = mkNixOSrpi {
        system = "aarch64-linux";
        host_modules = [
          ./hosts/homelab/rpi/5/1
        ];
      };
      rpi5-2 = mkNixOSrpi {
        system = "aarch64-linux";
        host_modules = [
          ./hosts/homelab/rpi/5/2
        ];
      };
      rpi5-3 = mkNixOSrpi {
        system = "aarch64-linux";
        host_modules = [
          ./hosts/homelab/rpi/5/3
        ];
      };


      rpi3-installer = mkRPiInstaller {
        system = "aarch64-linux";
        host_modules = [
          ./hosts/homelab/rpi/3/installer
        ];
      };
      rpi4-installer = mkRPiInstaller {
        system = "aarch64-linux";
        host_modules = [
          ./hosts/homelab/rpi/4/installer
        ];
      };
      rpi5-installer = mkRPiInstaller {
        system = "aarch64-linux";
        host_modules = [
          ./hosts/homelab/rpi/5/installer
        ];
      };

    };

    installerImages = let
      nixos = self.nixosConfigurations;
      mkImage = nixosConfig: nixosConfig.config.system.build.sdImage;
    in {
      rpi3 = mkImage nixos.rpi3-installer;
      rpi4 = mkImage nixos.rpi4-installer;
      rpi5 = mkImage nixos.rpi5-installer;
    };

    packages = forAllSys (system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      redserv = outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.redserv;

      redlibssh = outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.redlibssh;
      redlibssh2 = outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.redlibssh2;
      redssh = outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.redssh;
      redexpect = outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.redexpect;
      serial_portal = outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.serial_portal;

      reeemiks = outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.reeemiks;
      znc = outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.znc;
      znc_clientaway = outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.zncModules.clientaway;
      lovr = outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.lovr;
      lovr-playspace = outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.lovr-playspace;
      vrcadvert = outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.vrcadvert;
      oscavmgr = outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.oscavmgr;
      wayvr-dashboard = outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.wayvr-dashboard;
      wlx-overlay-s = outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.wlx-overlay-s;
      argbColors = outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.argbColors;
      resolute = outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.resolute;
      xrbinder = outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.xrbinder;
      xrizer = outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.xrizer;
      xrizer_multiarch = outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.xrizer_multiarch;
      monado = outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.monado;
      monado_multiarch = outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.monado_multiarch;
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
        outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.redexpect
      ];
    });

  };
}

