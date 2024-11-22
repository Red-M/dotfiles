{
  description = "My NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-beta.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    home-manager = {
      url = "github:nix-community/home-manager";
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
    ucodenix.url = "github:e-tho/ucodenix";
  };

  outputs = { nixpkgs, nixpkgs-beta, nixpkgs-unstable, home-manager, nixos-hardware, ... }@inputs: {
    nixosConfigurations = {
      potato = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          inherit system;
          nixbeta = import nixpkgs-beta {
            inherit system;
            inherit inputs;
            config.allowUnfree = true;
          };
          unstable = import nixpkgs-unstable {
            inherit system;
            inherit inputs;
            config.allowUnfree = true;
          };
          nixmaster = import inputs.nixpkgs-master {
            inherit system;
            inherit inputs;
            config.allowUnfree = true;
          };
        };
        modules = [
          ./hosts/potato
        ];
      };

      redm = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          inherit system;
          nixbeta = import nixpkgs-beta {
            inherit system;
            inherit inputs;
            config.allowUnfree = true;
          };
          unstable = import nixpkgs-unstable {
            inherit system;
            inherit inputs;
            config.allowUnfree = true;
          };
          nixmaster = import inputs.nixpkgs-master {
            inherit system;
            inherit inputs;
            config.allowUnfree = true;
          };
        };
        modules = [
          ./hosts/redm
        ];
      };

      redbox = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          inherit system;
          nixbeta = import nixpkgs-beta {
            inherit system;
            inherit inputs;
            config.allowUnfree = true;
          };
          unstable = import nixpkgs-unstable {
            inherit system;
            inherit inputs;
            config.allowUnfree = true;
          };
          nixmaster = import inputs.nixpkgs-master {
            inherit system;
            inherit inputs;
            config.allowUnfree = true;
          };
        };
        modules = [
          ./hosts/redbox
        ];
      };
    };
  };
}

