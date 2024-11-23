
{ config, lib, pkgs, nixbeta, unstable, nixmaster, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.disko.nixosModules.disko

    ../../modules/amd_ucode.nix
    ../../modules/cad.nix
    ../../modules/distrobox.nix
    ../../modules/fans.nix
    ../../modules/fingerprint.nix
    ../../modules/firmware.nix
    ../../modules/fonts.nix
    ../../modules/graphical_display.nix
    ../../modules/grub.nix
    ../../modules/keepass.nix
    ../../modules/kernel.nix
    ../../modules/kvm.nix
    ../../modules/laptop.nix
    ../../modules/linux.nix
    ../../modules/locale.nix
    ../../modules/messaging.nix
    ../../modules/my_user.nix
    ../../modules/nix.nix
    ../../modules/obs.nix
    ../../modules/rgb.nix
    ../../modules/serial_devices.nix
    ../../modules/sound.nix
    ../../modules/ssh_server.nix
    ../../modules/steam.nix
  ];

  networking.hostName = "redm"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  hardware = {
    amdgpu.initrd.enable = true;
  };

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
