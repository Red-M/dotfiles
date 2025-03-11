
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  users.users.redm = {
    extraGroups = [ "gamemode" ];
    packages = with pkgs; [
      unstable.lutris
      mangohud
      gamemode
      unstable.gamescope
      steamtinkerlaunch
      yad

      moonlight-qt

      prismlauncher

      vulkan-tools

      r2modman
      r2mod_cli
      unstable.nexusmods-app-unfree

      bottles

      xboxdrv
    ];
  };

  services.ananicy = { # https://github.com/NixOS/nixpkgs/issues/351516
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-cpp;
    extraRules = [
      {
        "name" = "gamescope";
        "nice" = -20;
      }
    ];
  };

  programs = {
    gamescope = {
      enable = true;
      capSysNice = false;
      # capSysNice = true;
      # package = unstable.gamescope;
    };
    gamemode = {
      enable = true;
      settings = {
        general = {
          renice = 10;
        };
        # gpu = {
        #   apply_gpu_optimisations = "accept-responsibility";
        #   gpu_device = 1;
        #   amd_performance_level = "high";
        # };
      };
    };
    steam = {
      enable = true;
      # gamescopeSession.enable = true;
      protontricks.enable = true;
      # package = unstable.steam;
      extraPackages = with pkgs; [
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        xorg.libxcb
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
        gamemode
        procps
        usbutils
      ] ++ config.fonts.packages;
      extraCompatPackages = with pkgs; [
        steamtinkerlaunch
      ];
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };
    java.enable = true;
  };

  hardware = {
    graphics = {
      extraPackages = with pkgs; [
        # mangohud
        # gamescope
        # gamemode
      ];
      extraPackages32 = config.hardware.graphics.extraPackages;
    };

    xone.enable = true;
    xpadneo.enable = true;
    steam-hardware.enable = true;
  };

  boot = {
    kernelModules = with config.boot.kernelPackages; [
      "hid-xpadneo"
    ];
    extraModulePackages = with config.boot.kernelPackages; [
      xpadneo
    ];
    extraModprobeConfig = ''
      options hid_xpadneo disable_deadzones=0 rumble_attenuation=0 trigger_rumble_mode=0 ff_connect_notify=1 disable_shift_mode=1

      alias hid:b0005g*v0000045Ep000002E0 hid_xpadneo
      alias hid:b0005g*v0000045Ep000002FD hid_xpadneo
      alias hid:b0005g*v0000045Ep00000B05 hid_xpadneo
      alias hid:b0005g*v0000045Ep00000B13 hid_xpadneo
      alias hid:b0005g*v0000045Ep00000B20 hid_xpadneo
      alias hid:b0005g*v0000045Ep00000B22 hid_xpadneo

    '';

    kernel.sysctl = {
      # SteamOS/Fedora default, can help with performance.
      "vm.max_map_count" = 2147483642;
    };

  };

  services.udev.extraRules = ''
    KERNEL=="cpu_dma_latency", GROUP="gamemode"
  '';
  security = {
    sudo = {
      extraRules = [
        {
          groups = [
            "gamemode"
          ];
          commands = [
            {
              command = "${pkgs.gamemode}/bin/gamemoderun";
              options = [ "NOPASSWD" ];
            }
            {
              command = "${pkgs.gamemode}/libexec/procsysctl";
              options = [ "NOPASSWD" ];
            }
            {
              command = "${pkgs.gamemode}/libexec/cpugovctl";
              options = [ "NOPASSWD" ];
            }
            {
              command = "${pkgs.gamemode}/libexec/gpuclockctl";
              options = [ "NOPASSWD" ];
            }
            {
              command = "^/nix/store/.*/bin/gamemoderun$";
              options = [ "NOPASSWD" ];
            }
            {
              command = "^/nix/store/.*/libexec/procsysctl$";
              options = [ "NOPASSWD" ];
            }
            {
              command = "^/nix/store/.*/libexec/cpugovctl$";
              options = [ "NOPASSWD" ];
            }
            {
              command = "^/nix/store/.*/libexec/gpuclockctl$";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];
    };

    pam = {
      # Higher resource limits. Used by Lutris/Wine.
      loginLimits = [
        { domain = "@gamemode"; item = "nofile"; type = "soft"; value = "1048576"; }
        { domain = "@gamemode"; item = "nofile"; type = "hard"; value = "1048576"; }
        { domain = "@gamemode"; type = "-"; item = "rtprio"; value = 98; }
        { domain = "@gamemode"; type = "-"; item = "memlock"; value = "unlimited"; }
        { domain = "@gamemode"; type = "-"; item = "nice"; value = -11; }
      ];
    };
    # wrappers = {
    #   mangohud = {
    #     owner = "root";
    #     group = "root";
    #     source = "${pkgs.mangohud}/bin/mangohud";
    #     capabilities = "cap_sys_nice+pie";
    #   };
    #   mangoapp = {
    #     owner = "root";
    #     group = "root";
    #     source = "${pkgs.mangohud}/bin/mangoapp";
    #     capabilities = "cap_sys_nice+pie";
    #   };
    # };
  };
  security.polkit.extraConfig = ''
    polkit.addRule(function (action, subject) {
      if ((action.id == "com.feralinteractive.GameMode.governor-helper" ||
        action.id == "com.feralinteractive.GameMode.gpu-helper" ||
        action.id == "com.feralinteractive.GameMode.cpu-helper" ||
        action.id == "com.feralinteractive.GameMode.procsys-helper") &&
        subject.isInGroup("gamemode"))
      {
        return polkit.Result.YES;
      }
    });
  '';

  environment.etc."polkit-1/actions/com.feralinteractive.GameMode.policy".text = ''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE policyconfig PUBLIC
 "-//freedesktop//DTD PolicyKit Policy Configuration 1.0//EN"
 "http://www.freedesktop.org/standards/PolicyKit/1.0/policyconfig.dtd">
<policyconfig>

  <!--
    Copyright (c) 2017-2019, Feral Interactive
    All rights reserved.
  -->

  <vendor>Feral GameMode Activation</vendor>
  <vendor_url>http://www.feralinteractive.com</vendor_url>

  <action id="com.feralinteractive.GameMode.governor-helper">
    <description>Modify the CPU governor</description>
    <message>Authentication is required to modify the CPU governor</message>
    <defaults>
      <allow_any>no</allow_any>
      <allow_inactive>no</allow_inactive>
      <allow_active>no</allow_active>
    </defaults>
    <annotate key="org.freedesktop.policykit.exec.path">${pkgs.gamemode}/libexec/cpugovctl</annotate>
  </action>

  <action id="com.feralinteractive.GameMode.gpu-helper">
    <description>Modify the GPU clock states</description>
    <message>Authentication is required to modify the GPU clock states</message>
    <defaults>
      <allow_any>no</allow_any>
      <allow_inactive>no</allow_inactive>
      <allow_active>no</allow_active>
    </defaults>
    <annotate key="org.freedesktop.policykit.exec.path">${pkgs.gamemode}/libexec/gpuclockctl</annotate>
    <annotate key="org.freedesktop.policykit.exec.allow_gui">true</annotate>
  </action>

  <action id="com.feralinteractive.GameMode.cpu-helper">
    <description>Modify the CPU core states</description>
    <message>Authentication is required to modify the CPU core states</message>
    <defaults>
      <allow_any>no</allow_any>
      <allow_inactive>no</allow_inactive>
      <allow_active>no</allow_active>
    </defaults>
    <annotate key="org.freedesktop.policykit.exec.path">${pkgs.gamemode}/libexec/cpucorectl</annotate>
    <annotate key="org.freedesktop.policykit.exec.allow_gui">true</annotate>
  </action>

  <action id="com.feralinteractive.GameMode.procsys-helper">
    <description>Modify the /proc/sys values</description>
    <message>Authentication is required to modify the /proc/sys/ values</message>
    <defaults>
      <allow_any>no</allow_any>
      <allow_inactive>no</allow_inactive>
      <allow_active>no</allow_active>
    </defaults>
    <annotate key="org.freedesktop.policykit.exec.path">${pkgs.gamemode}/libexec/procsysctl</annotate>
    <annotate key="org.freedesktop.policykit.exec.allow_gui">true</annotate>
  </action>
</policyconfig>
  '';

}

