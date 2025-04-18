
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  users.users.redm = {
    packages = with pkgs; [
      outoftree.pkgs.${pkgs.system}.dropbox
      outoftree.pkgs.${pkgs.system}.dropbox-cli
    ];
  };

  systemd.services.dropbox = {
    enable = lib.mkDefault false;
    description = "Dropbox";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = "${lib.getBin outoftree.pkgs.${pkgs.system}.dropbox}/bin/dropbox";
      KillMode = "control-group";
      Restart = "on-failure";
      PrivateTmp = true;
      ProtectSystem = "full";
      Nice = 10;
      User = "redm";
    };
  };

}

