{ lib, ... }: {
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = [ "67.207.67.3"
 "67.207.67.2"
 "67.207.67.3"
 "67.207.67.2"
 "67.207.67.3"
 "67.207.67.2"
 ];
    defaultGateway = "178.62.192.1";
    defaultGateway6 = {
      address = "";
      interface = "eth0";
    };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address="178.62.245.177"; prefixLength=18; }
{ address="10.18.0.5"; prefixLength=16; }
        ];
        ipv6.addresses = [
          { address="fe80::600a:fff:fe2d:5513"; prefixLength=64; }
        ];
        ipv4.routes = [ { address = "178.62.192.1"; prefixLength = 32; } ];
        ipv6.routes = [ { address = ""; prefixLength = 128; } ];
      };
            eth1 = {
        ipv4.addresses = [
          { address="10.110.0.2"; prefixLength=20; }
        ];
        ipv6.addresses = [
          { address="fe80::f032:deff:fec4:96cf"; prefixLength=64; }
        ];
        };
    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="62:0a:0f:2d:55:13", NAME="eth0"
    ATTR{address}=="f2:32:de:c4:96:cf", NAME="eth1"
  '';
}
