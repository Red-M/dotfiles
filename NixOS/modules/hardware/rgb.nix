
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ../patching/openrgb.nix
  ];
  # services.hardware.openrgb = {
  #   enable = true;
  #   # package = pkgs.openrgb-with-all-plugins;
  # };
  users.users.redm = {
    packages = with pkgs; [
      # outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.argbColors # https://gitlab.com/CalcProgrammer1/OpenRGB/-/issues/4306
    ];
  };

  boot.kernelModules = with config.boot.kernelPackages; [
    "i2c-dev"
  ];
  environment.systemPackages = with pkgs; [
    openrgb_1_0
    i2c-tools
  ];
  services.udev.packages = with pkgs; [
    openrgb_1_0
  ];

  # ASUS AURA
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="0b05", ATTRS{idProduct}=="1aa6", MODE="0660", TAG+="uaccess", GROUP="wheel"
  '';

}

