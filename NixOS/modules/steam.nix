
{ config, lib, pkgs, unstable, inputs, ... }:

{
  users.users.redm = {
    extraGroups = [ "gamemode" ];
    packages = with pkgs; [
      lutris
      mangohud
      gamemode
      gamescope
      steamtinkerlaunch
      yad
      r2modman
      moonlight-qt
    ];
  };

  programs = {
    # gamescope.enable = true;
    gamemode.enable = true;
    java.enable = true;
    steam = {
      enable = true;
      # gamescopeSession.enable = true;
      # protontricks.enable = true;
      # package = unstable.steam;
      package = pkgs.steam.override {
        extraPkgs = pkgs: with pkgs; [
          # mangohud
          # gamescope
          # gamemode
          # steamtinkerlaunch
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils
        ] ++ config.fonts.packages;
      };
      # extraPackages = config.fonts.packages;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };
  };

  hardware = {
    graphics = {
      extraPackages = with pkgs; [
        mangohud
        gamescope
        gamemode
      ];
      extraPackages32 = config.hardware.graphics.extraPackages;
    };

    # xone.enable = true;
    xpadneo.enable = true;
    steam-hardware.enable = true;
  };

  environment.systemPackages = with pkgs; [
    linuxKernel.packages.linux_6_11.xpadneo
    linuxKernel.packages.linux_latest_libre.xpadneo
  ];

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
              command = "${pkgs.gamemode}/libexec/cpugovctl";
              options = [ "NOPASSWD" ];
            }
            {
              command = "${pkgs.gamemode}/libexec/gpuclockctl";
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
  };
}

