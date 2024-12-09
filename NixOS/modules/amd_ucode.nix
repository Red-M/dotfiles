{ config, lib, pkgs, nixalt, unstable, nixmaster, outoftree, inputs, ... }:
{
  imports = [ inputs.ucodenix.nixosModules.default ];

  services.ucodenix = {
    enable = true;
    cpuModelId = "auto"; # Replace with your processor's model ID
  };
}
