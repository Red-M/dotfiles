
{ config, lib, pkgs, nixbeta, unstable, nixmaster, inputs, ... }:

{
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

}

