
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  nix = {
    buildMachines = [
      (lib.mkIf (config.networking.hostName != "rpi4-0") {
        hostName = "rpi4-0";
        system = "aarch64-linux";
        protocol = "ssh";
      })
      (lib.mkIf (config.networking.hostName != "rpi4-1") {
        hostName = "rpi4-1";
        system = "aarch64-linux";
        protocol = "ssh";
      })
      (lib.mkIf (config.networking.hostName != "rpi5-0") {
        hostName = "rpi5-0";
        system = "aarch64-linux";
        protocol = "ssh";
      })
      (lib.mkIf (config.networking.hostName != "rpi5-1") {
        hostName = "rpi5-1";
        system = "aarch64-linux";
        protocol = "ssh";
      })
      (lib.mkIf (config.networking.hostName != "rpi5-2") {
        hostName = "rpi5-2";
        system = "aarch64-linux";
        protocol = "ssh";
      })
      (lib.mkIf (config.networking.hostName != "rpi5-3") {
        hostName = "rpi5-3";
        system = "aarch64-linux";
        protocol = "ssh";
      })
    ];
    distributedBuilds = true;
    extraOptions = ''
      builders-use-substitutes = true
    '';
    settings = {
      connect-timeout = 5;
      extra-substituters = [
        (lib.mkIf (config.networking.hostName != "rpi4-0") "ssh://rpi4-0")
        (lib.mkIf (config.networking.hostName != "rpi4-1") "ssh://rpi4-1")
        (lib.mkIf (config.networking.hostName != "rpi5-0") "ssh://rpi5-0")
        (lib.mkIf (config.networking.hostName != "rpi5-1") "ssh://rpi5-1")
        (lib.mkIf (config.networking.hostName != "rpi5-2") "ssh://rpi5-2")
        (lib.mkIf (config.networking.hostName != "rpi5-3") "ssh://rpi5-3")
      ];
      fallback = true;
    };
  };
}

