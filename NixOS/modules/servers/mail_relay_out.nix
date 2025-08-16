
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    mailutils
  ];

  services = {
    postfix = {
      enable = true;
      settings.main= {
        relayhost = [
          "mail-relay.red-m.net:25"
        ];
        destination = [ "" ];
        origin = "${config.networking.hostName}.${config.networking.domain}";
        hostname = "${config.networking.hostName}.${config.networking.domain}";
      };
    };
  };

}

