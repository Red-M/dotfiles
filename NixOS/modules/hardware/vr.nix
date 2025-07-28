
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{

  imports = [
    inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
    ../patching/monado.nix
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
        fetchSubmodules = false;
        deepClone = false;
        leaveDotGit = false;
        sparseCheckout = [ ];
        rev = "74c3462d27ce3bdeeee70011746c9cfdf83cb49b";
        sha256 = "sha256-Up4Qk3IvppjdT11VG0LBsn2EJo+TGPM6j2h/VLjJBxs=";
      };
      nativeBuildInputs = with pkgs; [
        inputs.fenix.packages.${pkgs.system}.default.toolchain
      ] ++ final.xrizer.nativeBuildInputs;
      patches = [
        # ./patching/patches/xrizer/68.patch
        # ./patching/patches/xrizer/69.patch
        # ./patching/patches/xrizer/82.patch
        # ./patching/patches/xrizer/funny_serial_numbers.patch
        # ./patching/patches/xrizer/rin_experimental2_funny_serials.patch
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
      v4l-utils # cameras
      xrgears # testing, just in case
      # opencomposite
      # xrizer
      xrizer-patched
      # xrizer-patched2
      # outoftree.pkgs.${pkgs.system}.xrizer
      motoc
      index_camera_passthrough
      wlx-overlay-s
      # unstable.wlx-overlay-s
      # wlx-overlay-s_patched
      # outoftree.pkgs.${pkgs.system}.wlx-overlay-s
      libsurvive
      wayvr-dashboard
      # outoftree.pkgs.${pkgs.system}.wayvr-dashboard
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
      };
    };

    wlx-overlay-s = {
      description = "VR wlx-overlay-s";
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

