
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ../ssh_server.nix
  ];

  services = {
    openssh.settings  = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
    sslh = {
      enable = true;
      settings = {
        transparent = true;
        protocols = [
          {
            host = "localhost";
            name = "ssh";
            port = "22";
            service = "ssh";
          }
          {
            host = "localhost";
            name = "openvpn";
            port = "1194";
          }
          {
            host = "localhost";
            name = "xmpp";
            port = "5222";
          }
          {
            host = "localhost";
            name = "http";
            port = "8081";
          }
          {
            host = "localhost";
            name = "tls";
            port = "8082";
          }
          {
            host = "localhost";
            name = "anyprot";
            port = "8082";
          }
        ];
      };
    };
  };

}

