# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

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
    ./modules/ucode.nix
  ];

  networking.hostName = "potato"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Australia/Brisbane";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_AU.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "en_AU.UTF-8";
      LC_IDENTIFICATION = "en_AU.UTF-8";
      LC_MEASUREMENT = "en_AU.UTF-8";
      LC_MONETARY = "en_AU.UTF-8";
      LC_NAME = "en_AU.UTF-8";
      LC_NUMERIC = "en_AU.UTF-8";
      LC_PAPER = "en_AU.UTF-8";
      LC_TELEPHONE = "en_AU.UTF-8";
      LC_TIME = "en_AU.UTF-8";
    };
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;
  services.envfs.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  programs = {
    # This fixes issues with libraries not being found to be more linux compatiable
    nix-ld = { enable = true; libraries = pkgs.steam-run.fhsenv.args.multiPkgs pkgs; };
    xwayland.enable = true;
    coolercontrol.enable = true;
    gamescope.enable = true;
    gamemode.enable = true;
    java.enable = true;
    steam = {
      enable = true;
      # gamescopeSession.enable = true;
      # protontricks.enable = true;
      # package = unstable.steam;
      package = pkgs.steam.override {
        extraPkgs = pkgs: with pkgs; [
          # mangohud
          # gamescope
          # gamemode
          # steamtinkerlaunch
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils
        ] ++ config.fonts.packages;
      };
      # extraPackages = config.fonts.packages;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };
  };

  services.udev.extraRules = ''
    KERNEL=="cpu_dma_latency", GROUP="gamemode"
  '';
  security = {
    sudo = {
      extraRules = [
        {
          groups = [
            "gamemode"
          ];
          commands = [
            {
              command = "${pkgs.gamemode}/bin/gamemoderun";
              options = [ "NOPASSWD" ];
            }
            {
              command = "${pkgs.gamemode}/libexec/cpugovctl";
              options = [ "NOPASSWD" ];
            }
            {
              command = "${pkgs.gamemode}/libexec/gpuclockctl";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];
    };

    pam = {
      # Higher resource limits. Used by Lutris/Wine.
      loginLimits = [
        { domain = "@gamemode"; item = "nofile"; type = "soft"; value = "1048576"; }
        { domain = "@gamemode"; item = "nofile"; type = "hard"; value = "1048576"; }
        { domain = "@gamemode"; type = "-"; item = "rtprio"; value = 98; }
        { domain = "@gamemode"; type = "-"; item = "memlock"; value = "unlimited"; }
        { domain = "@gamemode"; type = "-"; item = "nice"; value = -11; }
      ];
    };
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

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "au";
    variant = "";
  };
  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.fprintd.enable = true;
  services.hardware.openrgb.enable = false;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # This allows automatic noise reduction from microphones
    extraLv2Packages = [ pkgs.lsp-plugins ];
  };

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
      noto-fonts-cjk
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

  systemd.services.lact = {
    description = "AMDGPU Control Daemon";
    after = ["multi-user.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = "${pkgs.lact}/bin/lact daemon";
    };
    enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      auto-optimise-store = true;
      keep-outputs = true;
      keep-derivations = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than=7d";
    };
  };

  system = {
    autoUpgrade = {
      enable = true;
      dates = "02:00";
      randomizedDelaySec = "45min";
      persistent = true;
    };
    activationScripts.report-changes = ''
      PATH=$PATH:${lib.makeBinPath [ pkgs.nvd pkgs.nix ]}
      echo " ---  Changes since boot  ---"
      nvd diff /run/booted-system $(ls -dv /nix/var/nix/profiles/system-*-link | tail -1)
      echo " --- Changes from rebuild ---"
      nix --extra-experimental-features 'nix-command' store diff-closures /run/current-system "$systemConfig"
      nvd diff /run/current-system $(ls -dv /nix/var/nix/profiles/system-*-link | tail -1)
      echo " ____________________________"
    '';
  };

  boot = {
    loader = {
      # systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        devices = [ "nodev" ];
        # efiInstallAsRemovable = true;
        efiSupport = true;
        useOSProber = true;
        theme = "${pkgs.kdePackages.breeze-grub}/grub/themes/breeze";
      };
    };
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

  system.modulesTree = lib.mkForce [(
    (pkgs.aggregateModules
      ( config.boot.extraModulePackages ++ [ config.boot.kernelPackages.kernel ])
    ).overrideAttrs {
      # earlier items in the list above override the contents of later items
      ignoreCollisions = true;
    }
  )]; # Allows loading out-of-tree modules over the top of mainline modules

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
    fwupd.enable = true;
    udisks2.enable = true;

  };
  services.pipewire.extraConfig.pipewire = {
    "5-rates" = {
      "context.properties" = {
        "clock.force-rate" = 384000;
        "default.clock.rate" = 384000;
        "default.clock.allowed-rates" = [
          44100
          48000
          88200
          96000
          192000
          384000
        ];
      };
    };
    "5-rt" = {
      "context.modules" = [{
        "name" = "libpipewire-module-rtkit";
        "args" = {
          #nice.level   = -11
          #rt.prio      = 88
          #rt.time.soft = 200000
          #rt.time.hard = 200000
        };
        "flags" = [ "ifexists" "nofail" ];
      }];
    };
    "10-noise-cancel" = {
        "context.modules" = [{ # https://github.com/werman/noise-suppression-for-voice
        "name" = "libpipewire-module-filter-chain";
        "args" = {
          "node.description" = "Noise Canceling source";
            "media.name" = "Noise Canceling source";
            "filter.graph" = {
              "nodes" = [{
                "type" = "ladspa";
                "name" = "rnnoise";
                "plugin" = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
                "label" = "noise_suppressor_mono";
                "control" = {
                  "VAD Threshold (%)" = 50.0;
                  "VAD Grace Period (ms)" = 20;
                  "Retroactive VAD Grace (ms)" = 0;
                };
              }];
            };
          "capture.props" = {
            "node.name" = "capture.rnnoise_source";
            "node.passive" = true;
            "audio.rate" = 48000;
          };
          "playback.props" = {
            "node.name" = "rnnoise_source";
            "media.class" = "Audio/Source";
            "audio.rate" = 48000;
          };
        };
      }];
    };
    "10-virtual-groups" = {
      "context.modules" = [{
          "name" = "libpipewire-module-loopback";
          "args" = {
              "node.name" = "loopback_group_default";
              "node.description" = "Catch-all";
              "source_dont_move" = false;
              "remix" = false;
              "stream.dont-remix" = true;
              "node.passive" = true;
              "capture.props" = {
                  "device.intended-roles" = "Games";
                  "media.class" = "Audio/Sink";
                  "audio.position" = [ "FL" "FR" ];
              };
              "playback.props" = {
                  "audio.position" = [ "FL" "FR" ];
                  "node.passive" = true;
                  "node.dont-remix" = true;
              };
          };
      }{
          "name" = "libpipewire-module-loopback";
          "args" = {
              "node.name" = "loopback_group_music";
              "node.description" = "Music";
              "source_dont_move" = false;
              "remix" = false;
              "stream.dont-remix" = true;
              "node.passive" = true;
              "capture.props" = {
                  "device.intended-roles" = "Music";
                  "media.class" = "Audio/Sink";
                  "audio.position" = [ "FL" "FR" ];
              };
              "playback.props" = {
                  "audio.position" = [ "FL" "FR" ];
                  "node.passive" = true;
                  "node.dont-remix" = true;
              };
          };
      }{
          "name" = "libpipewire-module-loopback";
          "args" = {
              "node.name" = "loopback_group_voice";
              "node.description" = "Voice";
              "source_dont_move" = false;
              "remix" = false;
              "stream.dont-remix" = true;
              "node.passive" = true;
              "capture.props" = {
                  "device.intended-roles" = "Communication";
                  "media.class" = "Audio/Sink";
                  "audio.position" = [ "FL" "FR" ];
              };
              "playback.props" = {
                  "audio.position" = [ "FL" "FR" ];
                  "node.passive" = true;
                  "node.dont-remix" = true;
              };
          };
      }{
          "name" = "libpipewire-module-loopback";
          "args" = {
              "node.name" = "loopback_group_low_prio_games";
              "node.description" = "Low Priority";
              "source_dont_move" = false;
              "remix" = false;
              "stream.dont-remix" = true;
              "node.passive" = true;
              "capture.props" = {
                  "media.class" = "Audio/Sink";
                  "audio.position" = [ "FL" "FR" ];
              };
              "playback.props" = {
                  "audio.position" = [ "FL" "FR" ];
                  "node.passive" = true;
                  "node.dont-remix" = true;
              };
          };
      }];
    };
    "10-echo-cancel" = {
      "context.modules" = [{
        "name" = "libpipewire-module-echo-cancel";
        "args" = {
          "library.name" = "aec/libspa-aec-webrtc";
          "monitor.mode" = true;
          "aec.args" = {
            "webrtc.extended_filter" = true;
            "webrtc.delay_agnostic" = true;
            "webrtc.high_pass_filter" = true;
            "webrtc.noise_suppression" = true;
            "webrtc.voice_detection" = true;
            "webrtc.gain_control" = true;
            "webrtc.experimental_agc" = true;
            "webrtc.experimental_ns" = true;
          };
          "audio.channels" = 1;
            "source.props" = {
              "node.name" = "Echo Cancellation Source";
            };
          "sink.props" = {
            "node.name" = "Echo Cancellation Sink";
          };
        };
      }];
    };
  };

  services.pipewire.wireplumber.extraConfig = {
    "creative-soundcard" = {
      "alsa_monitor.rules" = [{
        "matches" = [
          { "node.name" = "*output.usb-Creative_Technology_Ltd_Sound_BlasterX_G6*"; }
        ];
        "apply_properties" = {
          "audio.rate" = 384000;
          "alsa.rate" = 384000;
          "alsa.resolution_bits" = 32;
          "node.max-latency" = "32768/384000";
          "audio.format" = "S32LE";
        };
      }];
    };
    "music-soundcard" = {
      "alsa_monitor.rules" = [{
        "matches" = [
          { "node.name" = "*usb-Creative_Technology_Ltd_Sound_BlasterX_G6_2C00*"; }
        ];
        "apply_properties" = {
          "node.description" = "Music SoundBlasterX G6";
        };
      }];
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
