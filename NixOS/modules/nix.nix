
{ config, lib, pkgs, unstable, inputs, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      auto-optimise-store = true;
      keep-outputs = true;
      keep-derivations = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than=7d";
    };
  };

  system = {
    autoUpgrade = {
      enable = true;
      dates = "02:00";
      randomizedDelaySec = "45min";
      persistent = true;
    };

    modulesTree = lib.mkForce [(
      (pkgs.aggregateModules
        ( config.boot.extraModulePackages ++ [ config.boot.kernelPackages.kernel ])
      ).overrideAttrs {
        # earlier items in the list above override the contents of later items
        ignoreCollisions = true;
      }
    )]; # Allows loading out-of-tree modules over the top of mainline modules

    activationScripts.report-changes = ''
      PATH=$PATH:${lib.makeBinPath [ pkgs.nvd pkgs.nix ]}
      echo " ---  Changes since boot  ---"
      nvd diff /run/booted-system $(ls -dv /nix/var/nix/profiles/system-*-link | tail -1)
      echo " --- Changes from rebuild ---"
      nix --extra-experimental-features 'nix-command' store diff-closures /run/current-system "$systemConfig"
      nvd diff /run/current-system $(ls -dv /nix/var/nix/profiles/system-*-link | tail -1)
      echo " ____________________________"
    '';
  };

  environment.etc."nixos/hardware-configuration.nix".source = "/home/redm/git/dotfiles/NixOS/hosts/${config.networking.hostName}/hardware-configuration.nix";

}

