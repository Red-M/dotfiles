
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  boot = {
    loader = {
      grub = {
        enable = true;
        devices = [ "nodev" ];
        useOSProber = true;
        theme = "${pkgs.kdePackages.breeze-grub}/grub/themes/breeze";
        zfsSupport = true;
        enableCryptodisk = true;
        efiSupport = lib.mkDefault true;
        efiInstallAsRemovable = lib.mkDefault true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    os-prober
    kdePackages.breeze-grub
  ];

}

