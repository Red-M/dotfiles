
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{

  hardware = {
    i2c.enable = true;
  };

  boot = {
    kernelModules = with config.boot.kernelPackages; [
      "i2c-piix4"
    ];
  };
}

