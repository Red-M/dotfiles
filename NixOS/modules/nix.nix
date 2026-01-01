
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{

  nixpkgs.overlays = [
    (final: prev: {
      python3Optimized.pkgs = lib.trivial.mergeAttrs prev.python3Optimized.pkgs {
        watchdog = prev.python3Optimized.pkgs.watchdog.override rec {
          disabledTestPaths = [
            "tests/test_inotify_c.py"
          ] ++ prev.python3Optimized.pkgs.watchdog.disabledTestPaths;
        };
      };
    })

    (final: prev: {
      inherit (final.lixPackageSets.stable)
        nixpkgs-review
        nix-direnv
        nix-eval-jobs
        nix-fast-build
        colmena;
    })

  ];

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    manual.manpages.enable = true;
  };

  nix = {
    package = pkgs.lixPackageSets.stable.lix;
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
    settings = {
      auto-optimise-store = true;
      keep-outputs = false;
      keep-derivations = false;
      keep-failed = false;
      keep-going = true;
      # Enable flakes and 'nix' command
      experimental-features = ["nix-command" "flakes"];
      trusted-users =  [ "root" "@wheel" ];
      trusted-substituters = [
        "https://cache.lix.systems"
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://nixos-raspberrypi.cachix.org"
      ];
      trusted-public-keys = [
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
      ];

    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than=7d";
    };
    optimise.automatic = true;

    # Add each flake input as a registry, making nix3 commands consistent with flake
    # registry.nixpkgs.flake = inputs.nixpkgs;
    registry = lib.mkForce (lib.mapAttrs (_: value: { flake = value; }) inputs);
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
      if [ -d /nix/store ]; then
      PATH=$PATH:${lib.makeBinPath [ pkgs.nvd pkgs.lixPackageSets.stable.lix ]}
      echo " ---  Changes since boot  ---"
      nvd diff /run/booted-system $(ls -dv /nix/var/nix/profiles/system-*-link | tail -1) || true
      echo " --- Changes from rebuild ---"
      nix --extra-experimental-features 'nix-command' store diff-closures /run/current-system "$systemConfig" || true
      nvd diff /run/current-system $(ls -dv /nix/var/nix/profiles/system-*-link | tail -1) || true
      echo " ____________________________"
      fi
    '';
  };

  # environment.etc."nixos/hardware-configuration.nix".source = "/home/redm/git/dotfiles/NixOS/hosts/${config.networking.hostName}/hardware-configuration.nix";

  environment.systemPackages = with pkgs; [
    nvd
  ];
}

