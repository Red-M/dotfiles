
{ config, lib, pkgs, unstable, inputs, ... }:

{
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

}

