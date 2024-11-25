
{ config, lib, pkgs, nixalt, unstable, nixmaster, inputs, ... }:

{
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

}

