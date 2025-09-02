
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/distrobox.nix
    ../../modules/hardware/fingerprint.nix
    ../../modules/hardware/firmware.nix
    ../../modules/fonts.nix
    ../../modules/graphical_display.nix
    ../../modules/bootloader.nix
    ../../modules/hyperv.nix
    ../../modules/kernel.nix
    ../../modules/kvm.nix
    ../../modules/hardware/laptop.nix
    ../../modules/langs
    ../../modules/linux.nix
    ../../modules/locale.nix
    ../../modules/my_user.nix
    ../../modules/my_user_extras.nix
    ../../modules/nix.nix
    ../../modules/obs.nix
    ../../modules/hardware/serial_devices.nix
    ../../modules/hardware/sound.nix
    ../../modules/ssh_server.nix
  ];

  networking.hostName = "redbox"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nftables
    iptables
    cryptsetup
  ];

  networking.firewall.allowedTCPPorts = [
    22
  ];
  # networking.nftables.enable = true;

  services.twingate.enable = true;
  programs = {
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "redm" ];
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  hardware = {
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}

