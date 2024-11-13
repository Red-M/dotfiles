{
  description = "My NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    ucodenix.url = "github:e-tho/ucodenix";
  };

  outputs = { nixpkgs, nixpkgs-unstable, ... }@inputs: {
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
    };
  };
}
