{ config, lib, pkgs, nixalt, unstable, nixmaster, inputs, ... }:
{
  imports = [ inputs.ucodenix.nixosModules.default ];

  services.ucodenix = {
    enable = true;
    cpuModelId = "auto"; # Replace with your processor's model ID
  };
}
