
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    mailutils
  ];

  services = {
    postfix = {
      enable = true;
      relayHost = "mail-relay.red-m.net";
      relayPort = 25;
      destination = [ "" ];
      origin = "${config.networking.hostName}.red-m.net";
      hostname = "${config.networking.hostName}.red-m.net";
    };
  };

}

