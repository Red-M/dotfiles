
{ config, lib, pkgs, unstable, inputs, ... }:

{
  programs = {
    gamescope.enable = true;
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

