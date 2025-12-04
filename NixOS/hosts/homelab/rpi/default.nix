
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    inputs.disko.nixosModules.disko

    # ../../../modules/kernel.nix
    ../../../modules/linux.nix
    ../../../modules/locale.nix
    ../../../modules/my_user.nix
    ../../../modules/nix.nix
    ../../../modules/zram.nix

    ../../../modules/ssh_server.nix
    ../../../modules/decrypt_over_network.nix
    ../../../modules/servers/mail_relay_out.nix
  ];

  boot = {
    initrd = {
      secrets = lib.mkForce ({ # These keys are never used anywhere else, treat them as if they are snakeoil and don't expect them to do anything except allow decryption over a local network
        "/etc/ssh/initrd_ssh_host_rsa_key" = ./network_decrypt/initrd_ssh_host_rsa_key;
        "/etc/ssh/initrd_ssh_host_rsa_key.pub" = ./network_decrypt/initrd_ssh_host_rsa_key.pub;
        "/etc/ssh/initrd_ssh_host_ed25519_key" = ./network_decrypt/initrd_ssh_host_ed25519_key;
        "/etc/ssh/initrd_ssh_host_ed25519_key.pub" = ./network_decrypt/initrd_ssh_host_ed25519_key.pub;
      });
    };
    loader = {
      grub.enable = lib.mkForce false;
      raspberryPi.bootloader = "kernel";
    };
  };
  system.nixos.tags = let
    cfg = config.boot.loader.raspberryPi;
  in [
    "raspberry-pi-${cfg.variant}"
    cfg.bootloader
    config.boot.kernelPackages.kernel.version
  ];



  networking.domain = "baphomet.moe";

  environment.systemPackages = with pkgs; [
    ipset
  ];

  services = {
    scx.enable = false;
    journald = {
      extraConfig = ''
        SystemMaxUse=256M
      '';
    };
  };

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  system.autoUpgrade.enable = true;

  networking = {
    firewall = {
      allowedTCPPorts = [
        80
        443
      ];
    };

    nftables = {
      enable = true;
      # ruleset = ''
      # '';
    };
  };

  disko.devices = let
    firmwarePartition = lib.recursiveUpdate {
      # label = "FIRMWARE";
      priority = 1;

      type = "0700";  # Microsoft basic data
      attributes = [
        0 # Required Partition
      ];

      size = "1024M";
      content = {
        type = "filesystem";
        format = "vfat";
        # mountpoint = "/boot/firmware";
        mountOptions = [
          "noatime"
          "noauto"
          "x-systemd.automount"
          "x-systemd.idle-timeout=1min"
        ];
      };
    };

    espPartition = lib.recursiveUpdate {
      # label = "ESP";

      type = "EF00";  # EFI System Partition (ESP)
      attributes = [
        2 # Legacy BIOS Bootable, for U-Boot to find extlinux config
      ];

      size = "1024M";
      content = {
        type = "filesystem";
        format = "vfat";
        # mountpoint = "/boot";
        mountOptions = [
          "noatime"
          "noauto"
          "x-systemd.automount"
          "x-systemd.idle-timeout=1min"
          "umask=0077"
        ];
      };
    };
  in {
    disk.disk1 = {
      device = lib.mkDefault "/dev/mmcblk0";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          FIRMWARE = firmwarePartition {
            label = "FIRMWARE";
            content.mountpoint = "/boot/firmware";
          };

          ESP = espPartition {
            label = "ESP";
            content.mountpoint = "/boot";
          };

          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "OS-crypted";
              extraOpenArgs = [ ];
              askPassword = true;
              settings = {
                allowDiscards = true;
              };
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };

}

