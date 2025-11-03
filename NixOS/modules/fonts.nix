
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  fonts = {
    fontDir.enable = true;
    fontconfig = {
      cache32Bit = true;
      antialias = true;
      hinting.enable = true;
      subpixel.lcdfilter = "default";
      subpixel.rgba = "rgb";
      includeUserConf =  true;
      defaultFonts.monospace = [
        "Cozette Vector NFM"
        "Cozette Vector NF"
        "Noto Color Emoji"
        "Noto Emoji"
        "DejaVu Sans Mono"
      ];
    };
    packages = with pkgs; [
      ubuntu-classic
      liberation_ttf
      # Persian Font
      vazir-fonts
      # Asian Font
      wqy_zenhei

      noto-fonts
      noto-fonts-cjk-sans
      emojione
      noto-fonts-color-emoji
      openmoji-color
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
      winePackages.fonts
    ];
  };

  environment.systemPackages = with pkgs; [
    fontconfig
    font-config-info

  ];
}

