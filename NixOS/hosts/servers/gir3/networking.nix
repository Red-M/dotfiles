{ lib, ... }: {
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = [
      "67.207.67.3"
      "67.207.67.2"
      "67.207.67.3"
      "67.207.67.2"
      "67.207.67.3"
      "67.207.67.2"
    ];
    defaultGateway = "143.198.224.1";
    defaultGateway6 = {
      address = "";
      interface = "eth0";
    };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address="143.198.236.196"; prefixLength=20; }
          { address="10.48.0.5"; prefixLength=16; }
        ];
        ipv6.addresses = [
          { address="fe80::78de:cbff:fe5a:93c1"; prefixLength=64; }
        ];
        ipv4.routes = [ { address = "143.198.224.1"; prefixLength = 32; } ];
        ipv6.routes = [ { address = ""; prefixLength = 128; } ];
      };
            eth1 = {
        ipv4.addresses = [
          { address="10.124.0.2"; prefixLength=20; }
        ];
        ipv6.addresses = [
          { address="fe80::103b:c8ff:fe4e:9fc7"; prefixLength=64; }
        ];
        };
    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="7a:de:cb:5a:93:c1", NAME="eth0"
    ATTR{address}=="12:3b:c8:4e:9f:c7", NAME="eth1"
  '';
}
