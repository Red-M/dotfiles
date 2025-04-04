
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  users.users.redm = {
    packages = with pkgs; [
      wl-clipboard-x11

      kdePackages.kcalc
      kdePackages.kate

      # mpv
      open-in-mpv
      # play-with-mpv
      libplacebo
      (mpv-unwrapped.wrapper {
        mpv = mpv-unwrapped;
        scripts = [
          mpvScripts.uosc
          mpvScripts.thumbfast
          mpvScripts.sponsorblock
          mpvScripts.quality-menu
          mpvScripts.mpv-cheatsheet
          mpvScripts.reload
          mpvScripts.modernx
          mpvScripts.autoload
          mpvScripts.chapterskip
          mpvScripts.blacklistExtensions
          mpvScripts.mpv-playlistmanager
        ];
      })
      mpvpaper

      krita
      gimp-with-plugins
      kdePackages.kdenlive

      libreoffice-qt6-fresh

      winbox4
    ];
  };

}

