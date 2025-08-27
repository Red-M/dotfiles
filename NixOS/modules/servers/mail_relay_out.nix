
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    mailutils
  ];

  services = {
    postfix = {
      enable = true;
      rootAlias = "mail-relay"+"@"+"wiznerd.net";
      settings = {
        master = {
        };
        main = {
          inet_interfaces = lib.mkDefault [ "loopback-only" ];
          relayhost = lib.mkDefault [ "[mail-relay.red-m.net]" "[mail-relay2.red-m.net]" ];
          mydestination = [];
          mynetworks = lib.mkDefault [
            "127.0.0.0/8"
          ];
          myorigin = "${config.networking.hostName}.${config.networking.domain}";
          myhostname = "${config.networking.hostName}.${config.networking.domain}";
        };
      };
    };
  };

}

