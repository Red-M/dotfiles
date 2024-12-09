
{ config, lib, pkgs, nixalt, unstable, nixmaster, outoftree, inputs, ... }:

{
  hardware = {
    amdgpu.initrd.enable = true;
  };

}

