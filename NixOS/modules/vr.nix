
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{

  home-manager.users.redm = import ./home_manager/vr.nix;

  users.users.redm = {
    packages = with pkgs; [
      opencomposite
      wlx-overlay-s
    ];
  };

  services = {
    monado = {
      enable = true;
      defaultRuntime = true; # Register as default OpenXR runtime
    };

  };
  programs = {
    envision.enable = true;
    git = {
      enable = true;
      lfs.enable = true;
    };
  };

  systemd.user.services.monado.environment = {
    STEAMVR_LH_ENABLE = "1";
    XRT_COMPOSITOR_COMPUTE = "1";
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

