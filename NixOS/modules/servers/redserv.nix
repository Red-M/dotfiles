
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ../patching/redserv.nix
  ];

  systemd.services.redserv = {
    enable = lib.mkDefault false;
    description = "RedServ";
    wantedBy = ["multi-user.target"];
    after = [ "network.target" config.systemd.services.sslh.name config.systemd.services.dropbox.name ];
    serviceConfig = {
      ExecStart = "${lib.getBin pkgs.redserv}/bin/redserv /home/redm/Dropbox/webserv";
      KillMode = "control-group";
      Restart = "on-failure";
      PrivateTmp = true;
      ProtectSystem = "full";
      Nice = 5;
      User = "redm";
      Group = "redm";
      StandardOutput = "journal";
      StandardError = "journal";
      AmbientCapabilities = "CAP_NET_BIND_SERVICE";
    };
  };

  users.users.redm = {
    packages = with pkgs; [
      redserv
    ];
  };

}

