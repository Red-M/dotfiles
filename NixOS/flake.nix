{
  description = "My NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
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

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, nixos-hardware, ... }@inputs: {
    nixosConfigurations = {
      potato = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          inherit system;
          unstable = import nixpkgs-unstable {
            inherit system;
            inherit inputs;
            # Refer to the `system` parameter from
            # the outer scope recursively
            # To use Chrome, we need to allow the
            # installation of non-free software.
            config.allowUnfree = true;
          };
        };
        modules = [
          ./hosts/potato/configuration.nix
        ];
      };

      redm = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          inherit system;
          unstable = import nixpkgs-unstable {
            inherit system;
            inherit inputs;
            config.allowUnfree = true;
          };
        };
        modules = [
          ./hosts/redm/configuration.nix
        ];
      };

      redbox = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          inherit system;
          unstable = import nixpkgs-unstable {
            inherit system;
            inherit inputs;
            config.allowUnfree = true;
          };
        };
        modules = [
          ./hosts/redbox/configuration.nix
        ];
      };
    };
  };
}

