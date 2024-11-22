{ config, lib, pkgs, nixbeta, unstable, nixmaster, inputs, ... }:
{
  imports = [ inputs.ucodenix.nixosModules.default ];

  services.ucodenix = {
    enable = true;
    cpuModelId = "auto"; # Replace with your processor's model ID
  };
}
