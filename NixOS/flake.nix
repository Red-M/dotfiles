{
  description = "My NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-alt.url = "github:NixOS/nixpkgs/nixos-24.11";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-2.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR"; # https://github.com/nix-community/NUR
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ucodenix.url = "github:e-tho/ucodenix";
    outoftree = {
      url = "path:./pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-alt, nixpkgs-unstable, lix-module, home-manager, nixos-hardware, nur, outoftree, ... }@inputs:
    let inherit (self);
    mkNixOS = {host_modules, system, ...}: nixpkgs.lib.nixosSystem rec {
      inherit system;
      modules = [
        lix-module.nixosModules.default
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
        nixmaster = import inputs.nixpkgs-master {
          inherit inputs system;
          config.allowUnfree = true;
        };
        nur = import inputs.nur {
          inherit inputs system;
          config.allowUnfree = true;
        };
      };

    };
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
    };
  };
}

