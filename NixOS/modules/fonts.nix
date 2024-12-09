
{ config, lib, pkgs, nixalt, unstable, nixmaster, outoftree, inputs, ... }:

{
  fonts = {
    fontDir.enable = true;
    fontconfig = {
      cache32Bit = true;
      defaultFonts.monospace = [
        "Cozette Vector NFM"
        "Cozette Vector NF"
        "Noto Color Emoji"
        "Noto Emoji"
        "DejaVu Sans Mono"
      ];
    };
    packages = with pkgs; [
      ubuntu_font_family
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
      noto-fonts-emoji
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

  ];
}

