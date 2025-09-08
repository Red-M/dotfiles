
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/hardware/cpu/amd_ucode.nix
    ../../modules/hardware/gpu/amdgpu_oc.nix
    ../../modules/hardware/motherboards/asus.nix

    ../../modules/decrypt_over_network.nix

    ../../modules/hardware/fans.nix
    ../../modules/hardware/fingerprint.nix
    ../../modules/hardware/firmware.nix
    ../../modules/hardware/mice.nix
    ../../modules/hardware/reeemiks.nix
    ../../modules/hardware/rgb.nix
    ../../modules/hardware/serial_devices.nix
    ../../modules/hardware/sound.nix
    ../../modules/hardware/vr.nix

    ../../modules/patching/qdoled.nix

    ../../modules/cad
    ../../modules/distrobox.nix
    ../../modules/dropbox.nix
    ../../modules/fonts.nix
    ../../modules/graphical_display.nix
    ../../modules/graphical_display_extras.nix
    ../../modules/bootloader_uefi.nix
    ../../modules/hm.nix
    ../../modules/keepass.nix
    ../../modules/kernel.nix
    ../../modules/kvm.nix
    ../../modules/langs
    ../../modules/linux.nix
    ../../modules/locale.nix
    ../../modules/messaging.nix
    ../../modules/my_user.nix
    ../../modules/my_user_extras.nix
    ../../modules/nix.nix
    ../../modules/obs.nix
    ../../modules/reverse_engineering.nix
    ../../modules/ssh_server.nix
    ../../modules/steam.nix
    ../../modules/zram.nix
  ];

  networking.hostName = "potato"; # Define your hostname.
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

  boot = {
    # kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    kernelParams = [];
    # kernelParams = [
    #   # "nvme_core.default_ps_max_latency_us=0"
    #   # "pcie_aspm=off"
    #   # "pcie_pm=off"
    # ];
    extraModulePackages = with config.boot.kernelPackages; [
    ];
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

}

