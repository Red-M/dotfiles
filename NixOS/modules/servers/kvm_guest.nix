
{ config, lib, pkgs, modulesPath, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    (modulesPath + "/virtualisation/qemu-guest-agent.nix")
  ];

  services.qemuGuest.enable = true;
}

