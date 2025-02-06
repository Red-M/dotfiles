
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    manual.manpages.enable = true;
  };

  nix = {
    package = pkgs.lix;
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
    settings = {
      auto-optimise-store = true;
      keep-outputs = true;
      keep-derivations = true;
      keep-failed = false;
      keep-going = true;
      # Enable flakes and 'nix' command
      experimental-features = ["nix-command" "flakes"];
      trusted-users =  [ "root" "@wheel" ];
      trusted-substituters = [
        "https://cache.nixos.org/"
        "https://hydra.nixos.org/"
        "https://nix-community.cachix.org"
        "https://helix.cachix.org"
        "https://cache.lix.systems"
      ];
      trusted-public-keys = [
        "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
      ];

    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than=7d";
    };
    optimise.automatic = true;

    # Add each flake input as a registry, making nix3 commands consistent with flake
    # registry.nixpkgs.flake = inputs.nixpkgs;
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    # Additionally, add inputs to system's legacy channels to make legacy nix commands consistent
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  };

  systemd.services = {
    nix-gc.serviceConfig = {
      Nice = 19;
    };
    nix-optimise.serviceConfig = {
      Nice = 19;
    };
    nixos-upgrade.serviceConfig = {
      Nice = 19;
    };
    nix-daemon.serviceConfig = {
      Nice = 19;
    };
  };

  system = {
    autoUpgrade = {
      enable = true;
      dates = "02:00";
      randomizedDelaySec = "45min";
      persistent = true;
    };

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

  environment.systemPackages = with pkgs; [
    nvd
    dconf2nix
    nix-index

    nixos-anywhere
  ];
}

