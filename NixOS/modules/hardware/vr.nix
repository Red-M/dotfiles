
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
      lighthouse-steamvr
      # opencomposite
      # xrizer
      # xrizer-patched
      # xrizer-patched2
      outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.xrizer_multiarch
      motoc
      # index_camera_passthrough
      # wlx-overlay-s
      # wlx-overlay-s_patched
      outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.wlx-overlay-s
      libsurvive
      wayvr-dashboard
      # outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.wayvr-dashboard
      # lovr-playspace
      outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.lovr-playspace
      outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.vrcadvert
      oscavmgr
      # outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.oscavmgr
      outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.resolute
      # outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.monado-vulkan-layers
      outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.xrbinder

      steamcmd # For BSB
      # BSB2e
      # outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.go-bsb-cams
      go-bsb-cams
      cameractrls
      outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.baballonia
    ];
  };

  services = {
    monado = {
      enable = true;
      defaultRuntime = true; # Register as default OpenXR runtime
      # package = pkgs.monado_patched;
      # package = pkgs.monado_matrix;
      package = pkgs.monado_multiarch_oot;
      # package = outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.monado;
      highPriority = true;
    };

  };

  environment.systemPackages = with pkgs; [
    # monado-vulkan-layers
    basalt-monado
  ];

  systemd.user.services = {
    monado = {
      environment = let log_level = "info"; in {
        XRT_LOG = log_level;
        XRT_COMPOSITOR_LOG = log_level;
        IPC_LOG = log_level;
        PROBER_LOG = log_level;
        LIGHTHOUSE_LOG = log_level;
        XRT_NO_STDIN = "on";
        XRT_DEBUG_GUI = "on";
        # XRT_WINDOW_PEEK = "2";

        AMD_VULKAN_ICD = "RADV";
        XRT_COMPOSITOR_COMPUTE = "on";
        STEAMVR_LH_ENABLE = "on";
        LH_HANDTRACKING = "on";
        VIT_SYSTEM_LIBRARY_PATH = "${pkgs.basalt-monado}/lib/libbasalt.so";
        XRT_COMPOSITOR_SCALE_PERCENTAGE="120";
        # XRT_COMPOSITOR_SCALE_PERCENTAGE="160";
        U_PACING_COMP_MIN_TIME_MS = "2";
        # U_PACING_COMP_TIME_FRACTION_PERCENT = "80";
        # U_PACING_APP_IMMEDIATE_WAIT_FRAME_RETURN = "on";
        # U_PACING_APP_ALIGN_PREDICTED_DISPLAY_TIME_TO_APP_PERIOD = "1";
        # U_PACING_APP_USE_MIN_FRAME_PERIOD = "1";
        # U_PACING_COMP_MIN_TIME_MS = "8";
        # IPC_EXIT_ON_DISCONNECT = "on"; # kill when a client disconnects
        IPC_EXIT_WHEN_IDLE = "on"; # kill on idle! :)
        IPC_EXIT_WHEN_IDLE_DELAY_MS = "300"; # This will only work if you have the following services enabled, otherwise monado will instantly shutdown
      };
      serviceConfig = {
        TimeoutStopSec = "2";
        # Nice = -20;
      };
    };

    wlx-overlay-s = {
      description = "VR wlx-overlay-s";
      path = [ pkgs.wayvr-dashboard ];
      serviceConfig = {
        ExecStart = "${outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.wlx-overlay-s}/bin/wlx-overlay-s";
        Restart = "on-abnormal";
      };
      environment = {
        OXR_DEBUG_IPD_MM="67";
      };
      bindsTo = [ "monado.service" ];
      partOf = [ "monado.service" ];
      after = [ "monado.service" ];
      upheldBy = [ "monado.service" ];
      unitConfig.ConditionUser = "!root";
    };
    lovr-playspace = {
      description = "VR lovr-playspace";
      serviceConfig = {
        # ExecStart = "${pkgs.lovr-playspace}/bin/lovr-playspace";
        ExecStart = "${outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.lovr-playspace}/bin/lovr-playspace";
        Restart = "on-abnormal";
      };
      environment = {
        OXR_DEBUG_IPD_MM="67";
      };
      bindsTo = [ "monado.service" ];
      partOf = [ "monado.service" ];
      after = [ "monado.service" ];
      upheldBy = [ "monado.service" ];
      unitConfig.ConditionUser = "!root";
    };
    # oscavmgr = {
    #   description = "VR oscavmgr";
    #   serviceConfig = {
    #     Restart = "on-abnormal";
    #   };
    #   script = ''
    #     ${pkgs.oscavmgr}/bin/oscavmgr openxr &> /dev/null
    #   '';
    #   bindsTo = [ "monado.service" ];
    #   partOf = [ "monado.service" ];
    #   after = [ "monado.service" ];
    #   upheldBy = [ "monado.service" ];
    #   unitConfig.ConditionUser = "!root";
    # };
    # index_camera_passthrough = {
    #   description = "VR index_camera_passthrough";
    #   serviceConfig = {
    #     ExecStart = "${pkgs.index_camera_passthrough}/bin/index_camera_passthrough";
    #     Restart = "on-abnormal";
    #   };
    #   environment = {
    #     OXR_DEBUG_IPD_MM="67";
    #   };
    #   bindsTo = [ "monado.service" ];
    #   partOf = [ "monado.service" ];
    #   after = [ "monado.service" ];
    #   upheldBy = [ "wlx-overlay-s.service" ];
    #   unitConfig.ConditionUser = "!root";
    # };
    # motoc = {
    #   description = "VR motoc";
    #   serviceConfig = {
    #     Restart = "on-abnormal";
    #   };
    #   script = ''
    #     ${pkgs.motoc}/bin/motoc monitor &> /dev/null
    #   '';
    #   bindsTo = [ "monado.service" ];
    #   partOf = [ "monado.service" ];
    #   after = [ "monado.service" ];
    #   upheldBy = [ "monado.service" ];
    #   unitConfig.ConditionUser = "!root";
    # };
  };

  services.udev.extraRules = ''
    # Bigscreen Beyond
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="0101", MODE="0660", TAG+="uaccess", GROUP="video"
    # Bigscreen Bigeye
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="0202", MODE="0660", TAG+="uaccess", GROUP="video", SYMLINK+="bigeye0"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="0202", MODE="0660", GROUP="video", TAG+="uaccess"
    SUBSYSTEM=="video4linux", SUBSYSTEMS=="usb", DRIVERS=="uvcvideo", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="0202", MODE="0660", TAG+="uaccess", GROUP="video"
    # Bigscreen Beyond Audio Strap
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="0105", MODE="0660", TAG+="uaccess", GROUP="video"
    # Bigscreen Beyond Firmware Mode?
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="4004", MODE="0660", TAG+="uaccess", GROUP="video"
  '';
  boot.kernelPatches = [
    {
      name = "BSB_part1";
      patch = ../patching/patches/amdgpu_kernel_module/BSB_drm-amd-use-fixed-dsc-bits-per-pixel-from-edid.patch;
    }
    {
      name = "BSB_part2";
      patch = ../patching/patches/amdgpu_kernel_module/BSB_drm-edid-parse-DRM-VESA-dsc-bpp-target.patch;
    }
  ];
  #networking.firewall.allowedTCPPorts = [ 8080 ]; # For go-bsb-cams to allow other hosts to connect to it

  # boot.extraModulePackages = [
  #   (outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.amdgpu-kernel-module.overrideAttrs (_: {
  #     kernel = config.boot.kernelPackages.kernel;
  #     patches = [ ../patching/patches/amdgpu_kernel_module/BSB_drm-amd-use-fixed-dsc-bits-per-pixel-from-edid.patch ../patching/patches/drm_kernel_module/BSB_drm-edid-parse-DRM-VESA-dsc-bpp-target.patch ];
  #   }))
  # ];

  # At this current point in time, I was able to get steamvr to run in the flatpak version of steam due to segfaults in nixpkgs unstable
  services.flatpak.enable = true;
  # This is for steamvr
  # https://github.com/NixOS/nixpkgs/issues/217119
  # https://github.com/Frogging-Family/community-patches/blob/master/linux61-tkg/cap_sys_nice_begone.mypatch
  # boot.extraModulePackages = [
  #   (outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.amdgpu-kernel-module.overrideAttrs (_: {
  #     kernel = config.boot.kernelPackages.kernel;
  #     patches = [ ../patching/patches/amdgpu_kernel_module/cap_sys_nice_begone.patch ];
  #   }))
  # ];





}

