
{ config, lib, pkgs, unstable, inputs, ... }:

{
  services.envfs.enable = true;

  programs = {
    # This fixes issues with libraries not being found to be more linux compatiable
    nix-ld = { enable = true; libraries = pkgs.steam-run.fhsenv.args.multiPkgs pkgs; };
  };

  # Allows running AppImage
  programs.appimage.enable = true;
  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

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

    gnome.gnome-keyring
    wl-clipboard-x11
    coreutils-full
    procps
    certstrap
    libva-utils
    psmisc
    pciutils

    libgcc
    clang_multi
    cmake
    glib
    glibc
    libglibutil

    gparted
    ntfs3g
    bindfs
    ventoy-full

    xwayland
    dbus

    mono

    python3

    firmware-updater
  ];

}

