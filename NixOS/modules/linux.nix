
{ config, lib, pkgs, nixalt, unstable, nixmaster, inputs, ... }:

{
  services.envfs.enable = true;

  programs = {
    # This fixes issues with libraries not being found to be more linux compatiable
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        acl
        attr
        bzip2
        curl
        gcc-unwrapped.lib
        libGL
        libsodium
        libssh
        libxml2
        openssl
        stdenv.cc.cc
        systemd
        icu.dev
        unstable.kdePackages.qt5compat
        unstable.kdePackages.qtwayland
        unstable.libsForQt5.qt5.qtwayland
        util-linux
        wayland
        xwayland
        xz
        zlib
        zstd
      ] ++ pkgs.steam-run.args.multiPkgs pkgs;
    };
  };

  # Allows running AppImage
  programs.appimage = {
    enable = true;
    binfmt = true;
    package = pkgs.appimage-run.override {
      extraPkgs = pkgs: [
        pkgs.icu.dev
      ];
    };
  };
  # boot.binfmt.registrations.appimage = {
  #   wrapInterpreterInShell = false;
  #   interpreter = "${pkgs.appimage-run}/bin/appimage-run";
  #   recognitionType = "magic";
  #   offset = 0;
  #   mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
  #   magicOrExtension = ''\x7fELF....AI\x02'';
  # };

  services.gnome.gnome-keyring.enable = true;

  environment.systemPackages = with pkgs; [
    alacritty
    unstable.neovim
    tmux
    rsync

    git
    # bash
    # bashInteractive
    bashInteractiveFHS
    curl
    bc
    htop
    iotop
    iftop
    file
    sysstat
    complete-alias
    gnupg
    unzip
    pwgen

    mise
    usage

    pkg-config
    # gnome.gnome-keyring
    coreutils-full
    procps
    certstrap
    libva-utils
    psmisc
    pciutils
    usbutils
    qdirstat

    libgcc
    clang_multi
    cmake
    glib
    glibc
    libglibutil
    libsecret

    gparted
    ntfs3g
    bindfs
    ventoy-full

    xwayland
    libsForQt5.qt5.qtwayland
    dbus

    mono

    python3

    firmware-updater
  ];

}

