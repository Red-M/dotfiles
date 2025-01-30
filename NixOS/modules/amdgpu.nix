
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  hardware = {
    amdgpu.initrd.enable = true;
  };

}

