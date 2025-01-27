{ lib, ... }: {
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = [ "67.207.67.2"
 "67.207.67.3"
 "67.207.67.2"
 "67.207.67.3"
 "67.207.67.2"
 "67.207.67.3"
 ];
    defaultGateway = "142.93.32.1";
    defaultGateway6 = {
      address = "";
      interface = "eth0";
    };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address="142.93.45.28"; prefixLength=20; }
{ address="10.16.0.5"; prefixLength=16; }
        ];
        ipv6.addresses = [
          { address="fe80::684a:73ff:fe14:e2b6"; prefixLength=64; }
        ];
        ipv4.routes = [ { address = "142.93.32.1"; prefixLength = 32; } ];
        ipv6.routes = [ { address = ""; prefixLength = 128; } ];
      };
            eth1 = {
        ipv4.addresses = [
          { address="10.131.219.252"; prefixLength=16; }
        ];
        ipv6.addresses = [
          { address="fe80::701f:3fff:fe4c:e195"; prefixLength=64; }
        ];
        };
    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="6a:4a:73:14:e2:b6", NAME="eth0"
    ATTR{address}=="72:1f:3f:4c:e1:95", NAME="eth1"
  '';
}
