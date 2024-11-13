
{ config, lib, pkgs, unstable, inputs, ... }:

# let
#   unstable = import
#     (builtins.fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz)
#     # reuse the current configuration
#     { config = config.nixpkgs.config; };
# in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/amdgpu_oc.nix
    ../../modules/fans.nix
    ../../modules/fingerprint.nix
    ../../modules/firmware.nix
    ../../modules/fonts.nix
    ../../modules/graphical_display.nix
    ../../modules/grub.nix
    ../../modules/linux.nix
    ../../modules/locale.nix
    ../../modules/nix.nix
    ../../modules/rgb.nix
    ../../modules/sound.nix
    ../../modules/steam.nix
    ../../modules/ucode.nix
  ];

  networking.hostName = "potato"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.redm = {
    isNormalUser = true;
    description = "Red_M";
    group = "redm";
    extraGroups = [ "networkmanager" "wheel" "dialout" "kvm" "gamemode" ];
    packages = with pkgs; [
      unstable.neovim
      rclone

      (keepass.override {
        plugins = [
          keepass-keeagent
          keepass-keepasshttp
          keepass-keepassrpc
        ];
      })
      keeweb

      google-chrome

      (unstable.discord.override {
        withOpenASAR = false;
        withVencord = true;
      })
      (unstable.discord-ptb.override {
        withOpenASAR = false;
        withVencord = true;
      })
      (unstable.discord-canary.override {
        withOpenASAR = false;
        withVencord = true;
      })
      betterdiscordctl
      telegram-desktop
      teamspeak_client

      complete-alias
      mise
      lutris
      mangohud
      gamemode
      gamescope
      steamtinkerlaunch
      r2modman
      moonlight-qt

      freecad
      kicad

      (pkgs.wrapOBS { plugins = [
        obs-studio-plugins.obs-vkcapture
        obs-studio-plugins.input-overlay
        obs-studio-plugins.obs-backgroundremoval
        obs-studio-plugins.obs-tuna
        obs-studio-plugins.obs-vaapi
        obs-studio-plugins.obs-ndi
        obs-studio-plugins.obs-teleport
        obs-studio-plugins.obs-source-clone
        obs-studio-plugins.obs-shaderfilter
        obs-studio-plugins.looking-glass-obs
        obs-studio-plugins.obs-pipewire-audio-capture
        obs-studio-plugins.wlrobs
      ]; }) # obs-studio and plugins

      python3
      openrgb-with-all-plugins
      unixtools.xxd
      xorg.xwininfo
      xdotool
      wget
      curl
      deluge
    ];
  };


  users.groups = {
    redm = {
      gid = 1000;
    };
  };

      # "path" : "/home/redm/.keepassnatmsg/run-proxy.sh",
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

  # Install firefox.
  programs.firefox.enable = true;

  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;

  # fileSystems = let
  #   mkRoSymBind = path: {
  #     device = path;
  #     fsType = "fuse.bindfs";
  #     options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
  #   };
  #   aggregatedIcons = pkgs.buildEnv {
  #     name = "system-icons";
  #     paths = with pkgs; [
  #       #libsForQt5.breeze-qt5  # for plasma
  #       gnome.gnome-themes-extra
  #     ];
  #     pathsToLink = [ "/share/icons" ];
  #   };
  #   aggregatedFonts = pkgs.buildEnv {
  #     name = "system-fonts";
  #     paths = config.fonts.packages;
  #     pathsToLink = [ "/share/fonts" ];
  #   };
  # in {
  #   "/usr/share/icons" = mkRoSymBind "${aggregatedIcons}/share/icons";
  #   "/usr/local/share/fonts" = mkRoSymBind "${aggregatedFonts}/share/fonts";
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alacritty
    unstable.neovim
    tmux
    rsync
    distrobox

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
    gnome.gnome-keyring
    wl-clipboard-x11
    coreutils-full
    procps
    certstrap
    libva-utils

    mono

    nvd
    dconf2nix

    libgcc
    clang_multi
    cmake
    glib
    glibc
    libglibutil

    python3

    coolercontrol.coolercontrold
    coolercontrol.coolercontrol-liqctld
    lact

    fprintd
    xwayland
    dbus

    os-prober
    kdePackages.breeze-grub

    gparted
    ntfs3g
    bindfs
    ventoy-full

    alsa-utils
    rnnoise-plugin
    wireplumber

    fontconfig

    nixos-anywhere

    virt-manager-qt
    # kdePackages
    kdePackages.kcalc
    kdePackages.kate
    kdePackages.sddm-kcm

    firmware-updater
    linuxKernel.packages.linux_6_11.it87
    linuxKernel.packages.linux_6_11.xpadneo
    linuxKernel.packages.linux_latest_libre.it87
    linuxKernel.packages.linux_latest_libre.xpadneo
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  boot = {
    # initrd.kernelModules = [ "amdgpu" ];

    kernelPackages = pkgs.linuxPackages_latest;

    kernelParams = [ "acpi_enforce_resources=lax" ];
    extraModulePackages = with config.boot.kernelPackages; [
      (it87.overrideAttrs (super: {
        postInstall = (super.postInstall or "") + ''
          find $out -name '*.ko' -exec xz {} \;
        '';
      })) # it87
      xpadneo
    ];
    kernelModules = with config.boot.kernelPackages; [
      "i2c-dev"
      "i2c-piix4"
      "jc42"

      "it87"
      "hid-xpadneo"
    ];
    extraModprobeConfig = ''
      options hid_xpadneo disable_deadzones=0 rumble_attenuation=0 trigger_rumble_mode=0 ff_connect_notify=1 disable_shift_mode=1
      options amdgpu ppfeaturemask=0xffffffff
      options it87 ignore_resource_conflict=1 mmio=1

      alias hid:b0005g*v0000045Ep000002E0 hid_xpadneo
      alias hid:b0005g*v0000045Ep000002FD hid_xpadneo
      alias hid:b0005g*v0000045Ep00000B05 hid_xpadneo
      alias hid:b0005g*v0000045Ep00000B13 hid_xpadneo
      alias hid:b0005g*v0000045Ep00000B20 hid_xpadneo
      alias hid:b0005g*v0000045Ep00000B22 hid_xpadneo

    '';
  };

  hardware = {
    amdgpu.initrd.enable = true;
    i2c.enable = true;
    bluetooth.enable = true;
    # xone.enable = true;
    xpadneo.enable = true;
    steam-hardware.enable = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  services = {
    udisks2.enable = true;

  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
