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
    defaultGateway = "104.248.240.1";
    defaultGateway6 = {
      address = "";
      interface = "eth0";
    };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address="104.248.244.148"; prefixLength=20; }
{ address="10.19.0.5"; prefixLength=16; }
        ];
        ipv6.addresses = [
          { address="fe80::c867:22ff:fef0:79c5"; prefixLength=64; }
        ];
        ipv4.routes = [ { address = "104.248.240.1"; prefixLength = 32; } ];
        ipv6.routes = [ { address = ""; prefixLength = 128; } ];
      };
            eth1 = {
        ipv4.addresses = [
          { address="10.135.0.2"; prefixLength=16; }
        ];
        ipv6.addresses = [
          { address="fe80::6058:66ff:fe60:5e6c"; prefixLength=64; }
        ];
        };
    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="ca:67:22:f0:79:c5", NAME="eth0"
    ATTR{address}=="62:58:66:60:5e:6c", NAME="eth1"
  '';
}
