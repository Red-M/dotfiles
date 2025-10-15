{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:
{
  imports = [ inputs.ucodenix.nixosModules.default ];

  hardware.cpu.amd.updateMicrocode = true;
  services.ucodenix = {
    enable = true;
    cpuModelId = "auto"; # Replace with your processor's model ID
  };
}
