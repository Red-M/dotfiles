
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{

  services = {
    mosquitto = {
      enable = true;
      listeners = [
        {
          port = 1883;
          acl = [ "pattern readwrite #" ];
          omitPasswordAuth = true;
          settings.allow_anonymous = true;
        }
      ];
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 1883 ];
  };

}

