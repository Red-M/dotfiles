
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{

  imports = [
    inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
    ./patching/monado.nix
  ];

  nixpkgs.overlays = [(final: prev: {
    wlx-overlay-s_patched = final.wlx-overlay-s.overrideAttrs rec {
      nativeBuildInputs = with pkgs; [
        inputs.fenix.packages.${pkgs.system}.default.toolchain
      ] ++ final.wlx-overlay-s.nativeBuildInputs;
    };
    wlx-overlay-s_patched2 = outoftree.pkgs.${pkgs.system}.wlx-overlay-s.overrideAttrs rec {
      nativeBuildInputs = with pkgs; [
        inputs.fenix.packages.${pkgs.system}.default.toolchain
      ] ++ outoftree.pkgs.${pkgs.system}.wlx-overlay-s.nativeBuildInputs;
    };
    xrizer-patched = final.xrizer.overrideAttrs rec {
      src = pkgs.fetchgit {
        url = "https://github.com/Supreeeme/xrizer.git";
        rev = "898d41051d33f9404ea9a9e599f0c1118c82cc54";
        fetchSubmodules = false;
        deepClone = false;
        leaveDotGit = false;
        sparseCheckout = [ ];
        sha256 = "sha256-quCljMhsx1sy385NgQl6oPuJe44CuyoO3FWcmS005Wk=";
      };
      nativeBuildInputs = with pkgs; [
        inputs.fenix.packages.${pkgs.system}.default.toolchain
      ] ++ final.xrizer.nativeBuildInputs;
      patches = [
        # ./patching/patches/xrizer/68.patch
        # ./patching/patches/xrizer/69.patch
        # ./patching/patches/xrizer/82.patch
        # ./patching/patches/xrizer/funny_serial_numbers.patch
        ./patching/patches/xrizer/rin_experimental2_funny_serials.patch
      ] ++ outoftree.pkgs.${pkgs.system}.xrizer.patches;
      doCheck = false;
      # target = "i686-unknown-linux-gnu";
      # target = "x86_64-unknown-linux-gnu";
    };
    xrizer-patched2 = outoftree.pkgs.${pkgs.system}.xrizer.overrideAttrs rec {
      nativeBuildInputs = with pkgs; [
        inputs.fenix.packages.${pkgs.system}.default.toolchain
      ] ++ outoftree.pkgs.${pkgs.system}.xrizer.nativeBuildInputs;
      patches = [
      ] ++ outoftree.pkgs.${pkgs.system}.xrizer.patches;
      doCheck = false;
    };
  })];

  home-manager.users.redm = import ./home_manager/vr.nix;

  users.users.redm = {
    packages = with pkgs; [
      # opencomposite
      xrizer-patched
      # xrizer-patched2
      # outoftree.pkgs.${pkgs.system}.xrizer
      motoc
      index_camera_passthrough
      # unstable.wlx-overlay-s
      # wlx-overlay-s_patched
      outoftree.pkgs.${pkgs.system}.wlx-overlay-s
      libsurvive
      # wayvr-dashboard
      outoftree.pkgs.${pkgs.system}.wayvr-dashboard
      outoftree.pkgs.${pkgs.system}.lovr-playspace
      outoftree.pkgs.${pkgs.system}.vrcadvert
      outoftree.pkgs.${pkgs.system}.oscavmgr
      # outoftree.pkgs.${pkgs.system}.vr_start
      outoftree.pkgs.${pkgs.system}.resolute
      # outoftree.pkgs.${pkgs.system}.monado-vulkan-layers
      outoftree.pkgs.${pkgs.system}.xrbinder
    ];
  };

  services = {
    monado = {
      enable = true;
      defaultRuntime = true; # Register as default OpenXR runtime
      package = pkgs.monado_patched;
    };

  };

  environment.systemPackages = with pkgs; [ basalt-monado ];

  systemd.user.services.monado = {
    environment = {
      AMD_VULKAN_ICD="RADV";
      XRT_COMPOSITOR_COMPUTE = "1";
      STEAMVR_LH_ENABLE = "1";
      VIT_SYSTEM_LIBRARY_PATH = "${pkgs.basalt-monado}/lib/libbasalt.so";
      XRT_COMPOSITOR_SCALE_PERCENTAGE="130";
      U_PACING_COMP_MIN_TIME_MS = "3";
      # U_PACING_APP_IMMEDIATE_WAIT_FRAME_RETURN = "on";
      # LH_HANDTRACKING = "on";
      # IPC_EXIT_ON_DISCONNECT = "on"; # kill when a client disconnects
    };
  };

  # https://github.com/NixOS/nixpkgs/issues/217119
  # https://github.com/Frogging-Family/community-patches/blob/master/linux61-tkg/cap_sys_nice_begone.mypatch
  boot.extraModulePackages = [
    (outoftree.pkgs.${pkgs.system}.amdgpu-kernel-module.overrideAttrs (_: {
      kernel = config.boot.kernelPackages.kernel;
      patches = [ ./patching/patches/amdgpu-kernel-module/cap_sys_nice_begone.patch ];
    }))
  ];

}

