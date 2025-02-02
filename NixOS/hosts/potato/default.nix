
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/amd_ucode.nix
    ../../modules/amdgpu.nix
    ../../modules/amdgpu_oc.nix
    ../../modules/cad
    ../../modules/distrobox.nix
    ../../modules/dropbox.nix
    ../../modules/fans.nix
    ../../modules/fingerprint.nix
    ../../modules/firmware.nix
    ../../modules/fonts.nix
    ../../modules/graphical_display.nix
    ../../modules/graphical_display_extras.nix
    ../../modules/grub.nix
    ../../modules/keepass.nix
    ../../modules/kernel.nix
    ../../modules/kvm.nix
    ../../modules/langs
    ../../modules/linux.nix
    ../../modules/locale.nix
    ../../modules/messaging.nix
    ../../modules/my_user.nix
    ../../modules/nix.nix
    ../../modules/obs.nix
    ../../modules/patching/qdoled.nix
    ../../modules/reverse_engineering.nix
    ../../modules/rgb.nix
    ../../modules/serial_devices.nix
    ../../modules/sound.nix
    ../../modules/ssh_server.nix
    ../../modules/steam.nix
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
    kernelParams = [ "acpi_enforce_resources=lax" ];
    extraModulePackages = with config.boot.kernelPackages; [
      (it87.overrideAttrs (super: {
        postInstall = (super.postInstall or "") + ''
          find $out -name '*.ko' -exec xz {} \;
        '';
      })) # it87
    ];
    kernelModules = with config.boot.kernelPackages; [
      "it87"
    ];
    extraModprobeConfig = ''
      options it87 ignore_resource_conflict=1 mmio=1
    '';
  };

  hardware = {
    i2c.enable = true;
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

