
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ../../modules/kernel.nix
    ../../modules/linux.nix
    ../../modules/locale.nix
    ../../modules/my_user.nix
    ../../modules/nix.nix
    ../../modules/ssh_server.nix
    ../../modules/langs/python.nix
    ../../modules/dropbox.nix
    ../../modules/redserv.nix
  ];

  environment.systemPackages = with pkgs; [
  ];

  services.openssh.settings  = {
    PasswordAuthentication = false;
    PermitRootLogin = "prohibit-password";
  };

  systemd.services.dropbox.enable = true;
  systemd.services.redserv.enable = true;

}

