
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{

  users.users.redm = {
    extraGroups = [ "zigbee2mqtt" ];
    packages = with pkgs; [
      outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.serial_portal
      socat
    ];
  };

  systemd.services = {
    zigbee2mqtt = {
      after = [ "network.target" "serial_portal.service" ];
      upheldBy = [ "serial_portal.service" ];
      preStart = lib.mkForce '''';
      serviceConfig = {
        ExecStartPre = lib.mkForce '''';
        ExecStartPreEx = lib.mkForce '''';
      };
    };
    serial_portal = {
      enable = true;
      description = "Serial Portal";
      wantedBy = ["multi-user.target"];
      after = [ "network.target" ];
      path = [ pkgs.bash pkgs.socat ];
      serviceConfig = {
        ExecStart = "${lib.getBin outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.serial_portal}/bin/serial_portal.py";
        WorkingDirectory = "/home/redm/raspbee";
        ProtectHome = false;
        PrivateTmp = false;
        KillMode = "control-group";
        Restart = "on-failure";
        ProtectSystem = "full";
        Nice = 5;
        User = "redm";
        Group = "redm";
        StandardOutput = "journal";
        StandardError = "journal";
        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    8099
  ];

  services = {

    zigbee2mqtt = {
      enable = true;
      # settings = {
      #   groups = "groups.yaml";
      #   devices = "devices.yaml";
      #   device_options = {
      #     retain = true;
      #   };
      #   frontend = {
      #     enabled = true;
      #     port = 8099;
      #   };
      #   homeassistant = {
      #     enabled = true;
      #     discovery_topic = "homeassistant";
      #   };
      #   mqtt = {
      #     server = "mqtt://192.168.0.172:1883";
      #     keepalive = 10;
      #     reject_unauthorized = true;
      #     version = 4;
      #     include_device_information = true;
      #     client_id = "zigbee2mqtt";
      #   };
      #   serial = {
      #     port = "tcp://127.0.0.1:6667";
      #     adapter = "zstack";
      #     # baudrate = 115200;
      #     disable_led = false;
      #     rtscts = false;
      #   };
      # };
    };

    nginx = {
      enable = false;
      defaultSSLListenPort = 8123;
      clientMaxBodySize = "256m";
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts."redhass.red-m.net" = {
        forceSSL = true;
        extraConfig = ''
          proxy_buffering off;
        '';
        sslCertificate = "/var/www/cert/cert.pem";
        sslCertificateKey = "/var/www/cert/privkey.pem";
        sslTrustedCertificate = "/var/www/cert/chain.pem";
        locations."/" = {
          proxyPass = "http://[::1]:8122";
          proxyWebsockets = true;
        };
      };
    };

  };

}

