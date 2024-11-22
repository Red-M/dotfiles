
{ config, lib, pkgs, nixbeta, unstable, nixmaster, inputs, ... }:

{
  services.envfs.enable = true;

  programs = {
    # This fixes issues with libraries not being found to be more linux compatiable
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        zlib
        zstd
        stdenv.cc.cc
        curl
        openssl
        attr
        libssh
        bzip2
        libxml2
        acl
        libsodium
        util-linux
        xz
        systemd
        libGL
        unstable.kdePackages.qtwayland
        unstable.kdePackages.qt5compat
        unstable.libsForQt5.qt5.qtwayland
        gcc-unwrapped.lib
        wayland
        xwayland
      ] ++ pkgs.steam-run.args.multiPkgs pkgs;
    };
  };

  # Allows running AppImage
  programs.appimage = {
    enable = true;
    binfmt = true;
    # package = pkgs.appimage-run.override {
    #   extraPkgs = pkgs: [
    #     pkgs.libGL
    #   ];
    # };
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

    mise
    usage

    pkg-config
    # gnome.gnome-keyring
    wl-clipboard-x11
    coreutils-full
    procps
    certstrap
    libva-utils
    psmisc
    pciutils
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

