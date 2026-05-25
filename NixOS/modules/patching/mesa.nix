
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  nixpkgs.overlays = [(final: prev: {
    mesa_patched = prev.mesa.override (old : {
      # env = {
      #   "VULKAN_DRIVERS" = "amd";
      # };
      galliumDrivers = [
        "radeonsi"
        "llvmpipe"
        "zink"
        "d3d12"
      ];
      vulkanDrivers = [
        "amd"
        "swrast"
        "microsoft-experimental"
      ];
    });
    mesa = final.mesa_patched.overrideAttrs (old : {
      src = pkgs.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "mesa";
        repo = "mesa";
        rev = "mesa-26.0.6";
        hash = "sha256-rSX+dVcquTIdITfTy+heipeq6xktOaA3psn6vXm1S34=";
      };
      # version = "25.3.5";
      # src = pkgs.fetchFromGitLab {
      #   domain = "gitlab.freedesktop.org";
      #   owner = "mesa";
      #   repo = "mesa";
      #   # rev = "mesa-25.3.5";
      #   # hash = "sha256-IihkUQU5eY4UNjuUVGwTt9mPcH7LXphgUOR2Qc4ZmTc=";
      #   # rev = "mesa-25.3.6";
      #   # hash = "sha256-kOUx9TR9DozSI5ZswfbhZJ2P7plsn+WL+dYHik1xXFM=";
      #   # rev = "mesa-26.0.0";
      #   # hash = "sha256-CUJi0qWmxjC6MxmXDKrza6bOjYwbh//NcTTI2Z165lI=";
      #   # rev = "e766ffccc6ad038e6db694a7e6c60a5f99f5092f"; # just after 25.3.6, avoids merge commit
      #   # rev = "9ef0c96f2622bc252c4e7a93adcbe3a9ac4f4e19";
      #   # hash = "sha256-Uq4Rii1Wl37WmSJi+cZgd4gVed2wMOjU3wRM2tcIol4=";
      # };
      patches = (old.patches or []) ++ [
        ./patches/mesa/15158.patch
      ];
    });
  })];

}

