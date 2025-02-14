
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{

  imports = [
    inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
  ];
  home-manager.users.redm = import ./home_manager/vr.nix;

  users.users.redm = {
    packages = with pkgs; [
      motoc
      index_camera_passthrough
      wlx-overlay-s
      libsurvive
      outoftree.pkgs.${pkgs.system}.lovr-playspace
      outoftree.pkgs.${pkgs.system}.vrcadvert
      outoftree.pkgs.${pkgs.system}.oscavmgr
    ];
  };

  services = {
    monado = {
      enable = true;
      defaultRuntime = true; # Register as default OpenXR runtime
    };

  };
  programs = {
    envision = {
      enable = false;
      package = pkgs.envision-unwrapped;
    };
    # git = {
    #   enable = true;
    #   lfs.enable = true;
    # };
  };

  environment.systemPackages = with pkgs; [ basalt-monado ];

  systemd.user.services.monado = {
    environment = {
      AMD_VULKAN_ICD="RADV";
      XRT_COMPOSITOR_SCALE_PERCENTAGE="130";
      U_PACING_COMP_MIN_TIME_MS = "5";
      STEAMVR_LH_ENABLE = "1";
      XRT_COMPOSITOR_COMPUTE = "1";
      VIT_SYSTEM_LIBRARY_PATH = "${pkgs.basalt-monado}/lib/libbasalt.so";
      IPC_EXIT_ON_DISCONNECT = "on"; # kill when last client disconnects
    };
  };

  # git clone https://gitlab.freedesktop.org/monado/utilities/hand-tracking-models ~/.local/share/monado/hand-tracking-models

  # https://github.com/NixOS/nixpkgs/issues/217119
  # https://github.com/Frogging-Family/community-patches/blob/master/linux61-tkg/cap_sys_nice_begone.mypatch
  boot.extraModulePackages = [
    (outoftree.pkgs.${pkgs.system}.amdgpu-kernel-module.overrideAttrs (_: {
      kernel = config.boot.kernelPackages.kernel;
      patches = [ ./patching/patches/amdgpu-kernel-module/cap_sys_nice_begone.patch ];
    }))
  ];

}

