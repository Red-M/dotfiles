
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{

  systemd.user.services.reeemiks = {
    Unit = {
      Description = "Reeemiks";
    };
    Install = {
      WantedBy = [ "default.target" ];
      Wants = [ "pipewire.service" ];
    };
    Service = {
      ExecStart = "${lib.getBin outoftree.pkgs.${pkgs.system}.reeemiks}/bin/reeemiks";
      KillMode = "control-group";
      Restart = "on-failure";
      PrivateTmp = true;
      ProtectSystem = "full";
      Nice = 5;
      StandardOutput = "journal";
      StandardError = "journal";
    };
  };

}

