
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ../../../modules/ssh_server.nix
  ];

  services.openssh.settings.PermitRootLogin = lib.mkForce "prohibit-password";

  boot.loader.raspberryPi.bootloader = "kernel";
  system.nixos.tags = let
    cfg = config.boot.loader.raspberryPi;
  in [
    "raspberry-pi-${cfg.variant}"
    cfg.bootloader
    config.boot.kernelPackages.kernel.version
  ];

}

