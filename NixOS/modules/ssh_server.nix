
{ config, lib, pkgs, nixalt, unstable, nixmaster, outoftree, inputs, ... }:

{
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  programs.ssh.package = pkgs.openssh_hpn;
  services.openssh.package = pkgs.openssh_hpn;

}

