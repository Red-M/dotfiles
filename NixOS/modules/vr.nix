
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{

  imports = [
    inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
    ./patching/monado.nix
  ];
  nixpkgs.overlays = [(final: prev: {
    xrizer-patched = final.xrizer.overrideAttrs rec {
      nativeBuildInputs = with pkgs; [
        inputs.fenix.packages.${pkgs.system}.default.toolchain
      ] ++ final.xrizer.nativeBuildInputs;
      patches = [
        ./patching/patches/xrizer/67.patch
        # ./patching/patches/xrizer/68.patch
        ./patching/patches/xrizer/69.patch
        # ./patching/patches/xrizer/72.patch
      ] ++ outoftree.pkgs.${pkgs.system}.xrizer.patches;
      doCheck = false;
    };
    xrizer-patched2 = outoftree.pkgs.${pkgs.system}.xrizer.overrideAttrs rec {
      nativeBuildInputs = with pkgs; [
        inputs.fenix.packages.${pkgs.system}.default.toolchain
      ] ++ outoftree.pkgs.${pkgs.system}.xrizer.nativeBuildInputs;
      patches = [
        # ./patching/patches/xrizer/72.patch
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
      wlx-overlay-s
      libsurvive
      # wayvr-dashboard
      outoftree.pkgs.${pkgs.system}.wayvr-dashboard
      outoftree.pkgs.${pkgs.system}.lovr-playspace
      outoftree.pkgs.${pkgs.system}.vrcadvert
      outoftree.pkgs.${pkgs.system}.oscavmgr
      outoftree.pkgs.${pkgs.system}.adgobye
      outoftree.pkgs.${pkgs.system}.vr_start
      # outoftree.pkgs.${pkgs.system}.monado-vulkan-layers
    ];
  };

  services = {
    monado = {
      enable = true;
      defaultRuntime = true; # Register as default OpenXR runtime
      package = pkgs.monado_patched;
    };

  };
  # programs = {
  #   envision = {
  #     enable = false;
  #     package = pkgs.envision-unwrapped;
  #   };
  #   git = {
  #     enable = true;
  #     lfs.enable = true;
  #   };
  # };

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

