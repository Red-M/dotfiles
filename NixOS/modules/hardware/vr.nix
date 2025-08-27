
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{

  imports = [
    inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
    ../patching/vr.nix
  ];
  home-manager.users.redm = import ./home_manager/vr.nix;

  users.users.redm = {
    packages = with pkgs; [
      v4l-utils # cameras
      xrgears # testing, just in case
      # opencomposite
      xrizer
      # xrizer-patched
      # xrizer-patched2
      # outoftree.pkgs.${pkgs.system}.xrizer
      motoc
      index_camera_passthrough
      wlx-overlay-s
      # wlx-overlay-s_patched
      # outoftree.pkgs.${pkgs.system}.wlx-overlay-s
      libsurvive
      wayvr-dashboard
      # outoftree.pkgs.${pkgs.system}.wayvr-dashboard
      outoftree.pkgs.${pkgs.system}.lovr-playspace
      outoftree.pkgs.${pkgs.system}.vrcadvert
      oscavmgr
      # outoftree.pkgs.${pkgs.system}.oscavmgr
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

  systemd.user.services = {
    monado = {
      environment = {
        XRT_LOG = "error";
        AMD_VULKAN_ICD = "RADV";
        XRT_COMPOSITOR_COMPUTE = "1";
        STEAMVR_LH_ENABLE = "1";
        VIT_SYSTEM_LIBRARY_PATH = "${pkgs.basalt-monado}/lib/libbasalt.so";
        XRT_COMPOSITOR_SCALE_PERCENTAGE="130";
        U_PACING_COMP_MIN_TIME_MS = "3";
        # U_PACING_APP_IMMEDIATE_WAIT_FRAME_RETURN = "on";
        # LH_HANDTRACKING = "on";
        # IPC_EXIT_ON_DISCONNECT = "on"; # kill when a client disconnects
        IPC_EXIT_WHEN_IDLE = "on"; # kill on idle! :)
        IPC_EXIT_WHEN_IDLE_DELAY_MS = "10000";
      };
    };

    wlx-overlay-s = {
      description = "VR wlx-overlay-s";
      path = [ pkgs.wayvr-dashboard ];
      serviceConfig = {
        ExecStart = "${pkgs.wlx-overlay-s}/bin/wlx-overlay-s";
        Restart = "on-abnormal";
      };
      bindsTo = [ "monado.service" ];
      partOf = [ "monado.service" ];
      after = [ "monado.service" ];
      upheldBy = [ "monado.service" ];
      unitConfig.ConditionUser = "!root";
    };
    index_camera_passthrough = {
      description = "VR index_camera_passthrough";
      serviceConfig = {
        ExecStart = "${pkgs.index_camera_passthrough}/bin/index_camera_passthrough";
        Restart = "on-abnormal";
      };
      bindsTo = [ "monado.service" ];
      partOf = [ "monado.service" ];
      after = [ "monado.service" ];
      upheldBy = [ "wlx-overlay-s.service" ];
      unitConfig.ConditionUser = "!root";
    };
    lovr-playspace = {
      description = "VR lovr-playspace";
      serviceConfig = {
        ExecStart = "${outoftree.pkgs.${pkgs.system}.lovr-playspace}/bin/lovr-playspace";
        Restart = "on-abnormal";
      };
      bindsTo = [ "monado.service" ];
      partOf = [ "monado.service" ];
      after = [ "monado.service" ];
      upheldBy = [ "monado.service" ];
      unitConfig.ConditionUser = "!root";
    };
    motoc = {
      description = "VR motoc";
      serviceConfig = {
        Restart = "on-abnormal";
      };
      script = ''
        ${pkgs.motoc}/bin/motoc monitor &> /dev/null
      '';
      bindsTo = [ "monado.service" ];
      partOf = [ "monado.service" ];
      after = [ "monado.service" ];
      upheldBy = [ "monado.service" ];
      unitConfig.ConditionUser = "!root";
    };
    oscavmgr = {
      description = "VR oscavmgr";
      serviceConfig = {
        Restart = "on-abnormal";
      };
      script = ''
        ${outoftree.pkgs.${pkgs.system}.oscavmgr}/bin/oscavmgr openxr &> /dev/null
      '';
      bindsTo = [ "monado.service" ];
      partOf = [ "monado.service" ];
      after = [ "monado.service" ];
      upheldBy = [ "monado.service" ];
      unitConfig.ConditionUser = "!root";
    };
  };

  # https://github.com/NixOS/nixpkgs/issues/217119
  # https://github.com/Frogging-Family/community-patches/blob/master/linux61-tkg/cap_sys_nice_begone.mypatch
  boot.extraModulePackages = [
    (outoftree.pkgs.${pkgs.system}.amdgpu-kernel-module.overrideAttrs (_: {
      kernel = config.boot.kernelPackages.kernel;
      patches = [ ../patching/patches/amdgpu-kernel-module/cap_sys_nice_begone.patch ];
    }))
  ];





}

