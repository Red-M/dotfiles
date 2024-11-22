
{ config, lib, pkgs, nixbeta, unstable, nixmaster, inputs, ... }:

{
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
  };

  environment.systemPackages = with pkgs; [
    os-prober
    kdePackages.breeze-grub
  ];

}

