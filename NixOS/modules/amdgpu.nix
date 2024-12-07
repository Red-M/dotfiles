
{ config, lib, pkgs, nixalt, unstable, nixmaster, inputs, ... }:

{
  hardware = {
    amdgpu.initrd.enable = true;
  };

}

