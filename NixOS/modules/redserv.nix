
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ./patching/redserv.nix
  ];

  systemd.services.redserv = {
    enable = lib.mkDefault false;
    description = "RedServ";
    wants = ["multi-user.target"];
    after = [ config.systemd.services.dropbox.name ];
    serviceConfig = {
      ExecStart = "${lib.getBin pkgs.redserv}/bin/redserv /home/redm/Dropbox/webserv";
      KillMode = "control-group";
      Restart = "on-failure";
      PrivateTmp = true;
      ProtectSystem = "full";
      Nice = 5;
      User = "redm";
    };
  };

  users.users.redm = {
    packages = with pkgs; [
      redserv
    ];
  };

}

