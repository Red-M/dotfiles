
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{

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
        libsodium
        libssh
        libxml2
        libGLU
        libGL
        openssl
        stdenv.cc.cc
        systemd
        util-linux
        xz
        zlib.dev
        zstd
      ] ++ pkgs.steam-run.args.multiPkgs pkgs;
    };
  };

  services = {
    envfs.enable = true;
    scx = { # experimental
      enable = true;
      scheduler = "scx_bpfland";
    };
    gnome.gnome-keyring.enable = true;
    journald = {
      extraConfig = ''
        SystemMaxUse=512M
      '';
    };
  };

  environment.systemPackages = with pkgs; [
    unstable.neovim
    tmux
    rsync

    git
    # bash
    # bashInteractive
    bashInteractiveFHS
    su
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
    unrar-wrapper
    pwgen
    dig
    tree

    mise
    usage

    gnumake
    pkg-config
    # gnome.gnome-keyring
    coreutils-full
    procps
    certstrap
    libva-utils
    psmisc
    pciutils
    usbutils
    lsof
    likwid
    dmidecode

    libgcc
    clang_multi
    cmake
    glib
    glibc
    libglibutil
    libsecret

    bindfs

    dbus

    # python3Optimized
  ];

  console = {
    font = "ter-powerline-v24b";
    packages = [
      pkgs.terminus_font
      pkgs.powerline-fonts
    ];
  };
  systemd.services.systemd-vconsole-setup = { # https://github.com/NixOS/nixpkgs/issues/312452#issuecomment-2611908384  be aware of https://github.com/NixOS/nixpkgs/issues/312452#issuecomment-2612016529
    unitConfig = {
      After = "local-fs.target";
    };
  };

}

