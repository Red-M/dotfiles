
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  services.hardware.openrgb.enable = true;
  users.users.redm = {
    packages = with pkgs; [
      openrgb-with-all-plugins
      outoftree.pkgs.${pkgs.system}.argbColors # https://gitlab.com/CalcProgrammer1/OpenRGB/-/issues/4306
    ];
  };

  boot.kernelModules = with config.boot.kernelPackages; [
    "i2c-dev"
  ];
  environment.systemPackages = with pkgs; [
    i2c-tools
  ];


  # X870E Master
  services.udev.extraRules = ''
    SUBSYSTEM=="input", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="048d", ATTRS{idProduct}=="5711", MODE="0666"
  '';

}

