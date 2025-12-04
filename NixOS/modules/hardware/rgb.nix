
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  services.hardware.openrgb.enable = true;
  users.users.redm = {
    packages = with pkgs; [
      openrgb-with-all-plugins
      outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.argbColors # https://gitlab.com/CalcProgrammer1/OpenRGB/-/issues/4306
    ];
  };

  boot.kernelModules = with config.boot.kernelPackages; [
    "i2c-dev"
  ];
  environment.systemPackages = with pkgs; [
    i2c-tools
  ];

  # ASUS AURA
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="0b05", ATTRS{idProduct}=="1aa6", MODE="0660", TAG+="uaccess", GROUP="wheel"
  '';

}

