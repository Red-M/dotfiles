
{ config, lib, pkgs, nixalt, unstable, nixmaster, outoftree, inputs, ... }:

{
  users.users.redm = {
    extraGroups = [ "gamemode" ];
    packages = with pkgs; [
      lutris
      mangohud
      gamemode
      unstable.gamescope
      steamtinkerlaunch
      yad
      r2modman
      moonlight-qt
      r2mod_cli
      unstable.nexusmods-app-unfree

      bottles
    ];
  };

  programs = {
    gamescope = {
      enable = true;
      # capSysNice = true;
      package = unstable.gamescope;
    };
    gamemode.enable = true;
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

    # xone.enable = true;
    # xpadneo.enable = true;
    xpadneo.enable = false; # until the 6.12 fixed patch is in nixbeta, as the 6.12 fixed version is only in master atm
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
}

