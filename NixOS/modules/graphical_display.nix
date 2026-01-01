
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  programs = {
    xwayland.enable = true;
    kdeconnect.enable = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "au";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  users.users.redm = {
    extraGroups = [ "video" ];
  };

  environment.systemPackages = with pkgs; [
    mesa-demos
    vulkan-tools
    clinfo
    xdg-utils

    libglibutil

    kdePackages.sddm-kcm
    kdePackages.kwallet-pam

    alacritty
    # alacritty-graphics
    qdirstat
    gparted
    ntfs3g
    # ventoy-full # upstream marked as insecure
    xwayland
    libsForQt5.qt5.qtwayland
    mono

    firmware-updater

  ];

  hardware = {
    bluetooth.enable = true;

    graphics = {
      enable = true;
      ## radv: an open-source Vulkan driver from freedesktop
      enable32Bit = true;

      extraPackages = with pkgs; [
        libva-utils
      ];
      extraPackages32 = with pkgs; [
        libva-utils
      ];
    };
  };

  services = {
    udisks2.enable = true;

  };
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (subject.isInGroup("wheel")) {
        if (action.id.startsWith("org.freedesktop.udisks2.")) {
          return polkit.Result.YES;
        }
      }
    });
  '';

  environment.etc."opt/chrome/native-messaging-hosts/org.keepassxc.keepassxc_browser.json".text = ''
    {
      "name": "org.keepassxc.keepassxc_browser",
      "description": "KeepassXC integration with Native Messaging support",
      "path" : "${pkgs.keeweb}/share/keeweb-desktop/keeweb-native-messaging-host",
      "type": "stdio",
      "allowed_origins": [
        "chrome-extension://pikpfmjfkekaeinceagbebpfkmkdlcjk/",
        "chrome-extension://dphoaaiomekdhacmfoblfblmncpnbahm/",
        "chrome-extension://iopaggbpplllidnfmcghoonnokmjoicf/",
        "chrome-extension://oboonakemofpalcgghocfoadofidjkkk/",
        "chrome-extension://pdffhmdngciaglkoonimfcmckehcpafo/"
      ]
    }
  '';

  programs = {
    # This fixes issues with libraries not being found to be more linux compatiable
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        libGL
        icu.dev
        unstable.kdePackages.qt5compat
        unstable.kdePackages.qtwayland
        unstable.libsForQt5.qt5.qtwayland
        wayland
        xwayland
      ];
    };
  };

  users.users.redm = {
    packages = with pkgs; [
      neofetch
      xorg.xwininfo
      xdotool
      xclip
      google-chrome

      deluge
      remmina
      scrcpy
    ];
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

}

