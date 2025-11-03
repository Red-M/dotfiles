
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
      # index_camera_passthrough
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

      steamcmd # For BSB
      # BSB2e
      outoftree.pkgs.${pkgs.system}.go-bsb-cams
      outoftree.pkgs.${pkgs.system}.baballonia
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
        # VIT_SYSTEM_LIBRARY_PATH = "${pkgs.basalt-monado}/lib/libbasalt.so";
        XRT_COMPOSITOR_SCALE_PERCENTAGE="140";
        # XRT_COMPOSITOR_SCALE_PERCENTAGE="160";
        # U_PACING_COMP_MIN_TIME_MS = "3";
        # U_PACING_APP_IMMEDIATE_WAIT_FRAME_RETURN = "on";
        LH_HANDTRACKING = "on";
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
    SUBSYSTEM=="usb", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="0202", MODE="0660", TAG+="uaccess", GROUP="video", SYMLINK+="bigeye0"
    # SUBSYSTEM=="video4linux", SUBSYSTEMS=="usb", DRIVERS=="uvcvideo", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="0202", MODE="0660", TAG+="uaccess", GROUP="video"
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
  #   (outoftree.pkgs.${pkgs.system}.amdgpu-kernel-module.overrideAttrs (_: {
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
  #   (outoftree.pkgs.${pkgs.system}.amdgpu-kernel-module.overrideAttrs (_: {
  #     kernel = config.boot.kernelPackages.kernel;
  #     patches = [ ../patching/patches/amdgpu_kernel_module/cap_sys_nice_begone.patch ];
  #   }))
  # ];





}

