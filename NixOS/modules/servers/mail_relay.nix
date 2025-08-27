
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{

  networking.firewall.allowedTCPPorts = [
    25
    587
  ];

  services = {
    postfix = {
      settings = {
        master = {
        };
        main = {
          default_process_limit = 300;
          smtpd_client_connection_count_limit = 150;
          inet_interfaces = null;
          smtp_bind_address = null;
          smtp_bind_address6 = null;
          relayhost = null;
          mydestination = [];
          smtpd_tls_security_level = "may";
          smtpd_client_restrictions = [ "permit_mynetworks" ];
          mynetworks = [
            "127.0.0.0/8"
            # TODO add dynamically generated file of safe havens
          ];
          virtual_alias_domains = "pcre:/etc/postfix/virtual";
          virtual_mailbox_maps = "pcre:/etc/postfix/virtual";
          recipient_delimiter = "+";
        };
      };
      mapFiles = {
        # virtual_domains = (pkgs.writeText "virtual_domains" ''
        #   /red\-m\.net/ a
        #   /bubble\-berry/ a
        #   /baphomet\.moe/ a
        #   /.+\.red\-m\.net/ a
        #   /.+\.bubble\-berry/ a
        #   /.+\.baphomet\.moe/ a
        # '');
      };
      virtualMapType = "pcre";
      virtual =''
        /(.+@(.+\.|)|)red\-m\.net/    mail_relay''\@''\wiznerd.net
        /(.+@(.+\.|)|)bubble\-berry/    mail_relay''\@''\wiznerd.net
        /(.+@(.+\.|)|)baphomet\.moe/    mail_relay''\@''\wiznerd.net
      '';
    };
  };

}

