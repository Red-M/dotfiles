
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    # ../../modules/decrypt_over_network.nix
    ../../modules/hardware/cpu/amd_ucode.nix
    ../../modules/hardware/gpu/amdgpu.nix
    ../../modules/distrobox.nix
    ../../modules/hardware/fans.nix
    ../../modules/hardware/fingerprint.nix
    ../../modules/hardware/firmware.nix
    ../../modules/fonts.nix
    ../../modules/graphical_display.nix
    ../../modules/graphical_display_extras.nix
    ../../modules/bootloader_uefi.nix
    ../../modules/keepass.nix
    ../../modules/kernel.nix
    ../../modules/kvm.nix
    ../../modules/hardware/laptop.nix
    ../../modules/langs
    ../../modules/linux.nix
    ../../modules/locale.nix
    ../../modules/messaging.nix
    ../../modules/hardware/mice.nix
    ../../modules/my_user.nix
    ../../modules/my_user_extras.nix
    ../../modules/extractors.nix
    ../../modules/compilers.nix
    ../../modules/nix.nix
    ../../modules/nix_utils.nix
    ../../modules/obs.nix
    ../../modules/reverse_engineering.nix
    ../../modules/hardware/serial_devices.nix
    ../../modules/hardware/sound.nix
    ../../modules/ssh_server.nix
    ../../modules/steam.nix
    ../../modules/zram.nix
  ];

  networking.hostName = "redm"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  ];

  services.pipewire.extraConfig.pipewire = {
    "5-rates" = {
      "context.properties" = {
        "default.clock.max-quantum" = lib.mkForce 4096;
      };
    };
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  # disko.devices = {
  #   disk.disk1 = {
  #     device = lib.mkDefault "/dev/nvme0n1";
  #     type = "disk";
  #     content = {
  #       type = "gpt";
  #       partitions = {
  #         boot = {
  #           name = "boot";
  #           size = "1M";
  #           type = "EF02";
  #         };
  #         esp = {
  #           name = "ESP";
  #           size = "4G";
  #           type = "EF00";
  #           content = {
  #             type = "filesystem";
  #             format = "vfat";
  #             mountpoint = "/boot";
  #             mountOptions = [ "umask=0077" ];
  #           };
  #         };
  #         luks = {
  #           size = "75G";
  #           content = {
  #             type = "luks";
  #             name = "OS-crypted";
  #             extraOpenArgs = [ ];
  #             askPassword = true;
  #             settings = {
  #               allowDiscards = true;
  #             };
  #             content = {
  #               type = "filesystem";
  #               format = "ext4";
  #               mountpoint = "/";
  #             };
  #           };
  #         };
  #         luks2 = {
  #           size = "75G";
  #           content = {
  #             type = "luks";
  #             name = "OS2-crypted";
  #             extraOpenArgs = [ ];
  #             askPassword = true;
  #             initrdUnlock = false;
  #             settings = {
  #               allowDiscards = true;
  #             };
  #             content = {
  #               type = "filesystem";
  #               format = "ext4";
  #             };
  #           };
  #         };
  #         home = {
  #           size = "100%";
  #           content = {
  #             type = "luks";
  #             name = "home-crypted";
  #             extraOpenArgs = [ ];
  #             askPassword = true;
  #             settings = {
  #               allowDiscards = true;
  #             };
  #             content = {
  #               type = "filesystem";
  #               format = "ext4";
  #               mountpoint = "/home";
  #             };
  #           };
  #         };
  #       };
  #     };
  #   };
  # };
}

