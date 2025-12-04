
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{

  # Lets not do that, it is silly
  networking.firewall = {
    logRefusedConnections = lib.mkDefault false;
    allowPing = true;
  };

  # The notion of "online" is a broken concept
  # https://github.com/systemd/systemd/blob/e1b45a756f71deac8c1aa9a008bd0dab47f64777/NEWS#L13
  # https://github.com/NixOS/nixpkgs/issues/247608
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.network.wait-online.enable = false;

  # Do not take down the network for too long when upgrading,
  # This also prevents failures of services that are restarted instead of stopped.
  # It will use `systemctl restart` rather than stopping it with `systemctl stop`
  # followed by a delayed `systemctl start`.
  systemd.services.systemd-networkd.stopIfChanged = false;
  # Services that are only restarted might be not able to resolve when resolved is stopped before
  systemd.services.systemd-resolved.stopIfChanged = false;


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
      enable = lib.mkDefault true;
      # scheduler = "scx_bpfland";
      scheduler = "scx_lavd";
      package = pkgs.scx.rustscheds;
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
    pwgen
    dig
    tree

    mise
    usage

    # gnome.gnome-keyring
    coreutils-full
    procps
    certstrap
    psmisc
    pciutils
    usbutils
    lsof
    dmidecode

    bindfs

    dbus

    # python3Optimized
  ];

  console = {
    enable = true;
    font = "ter-powerline-v24b";
    packages = [
      pkgs.terminus_font
      pkgs.powerline-fonts
    ];
  };

  services.logind.settings.Login = {
    NAutoVTs = 6;
    ReserveVT = 6;
  };
  # systemd.services.systemd-vconsole-setup.after = [ "local-fs.target" ]; # https://github.com/NixOS/nixpkgs/issues/312452#issuecomment-2611908384  be aware of https://github.com/NixOS/nixpkgs/issues/312452#issuecomment-2612016529
  # systemd.services.systemd-vconsole-setup = { # https://github.com/NixOS/nixpkgs/issues/312452#issuecomment-2611908384  be aware of https://github.com/NixOS/nixpkgs/issues/312452#issuecomment-2612016529
  #   unitConfig = {
  #     After = "local-fs.target";
  #   };
  # };

}

