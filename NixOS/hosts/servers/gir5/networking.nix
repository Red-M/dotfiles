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
    defaultGateway = "104.236.192.1";
    defaultGateway6 = {
      address = "";
      interface = "eth0";
    };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address="104.236.236.74"; prefixLength=18; }
          { address="10.17.0.5"; prefixLength=16; }
        ];
        ipv6.addresses = [
          { address="fe80::10c9:5ff:fea0:5414"; prefixLength=64; }
        ];
        ipv4.routes = [ { address = "104.236.192.1"; prefixLength = 32; } ];
        ipv6.routes = [ { address = ""; prefixLength = 128; } ];
      };
            eth1 = {
        ipv4.addresses = [
          { address="10.108.0.2"; prefixLength=20; }
        ];
        ipv6.addresses = [
          { address="fe80::3489:21ff:fef0:3e29"; prefixLength=64; }
        ];
        };
    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="12:c9:05:a0:54:14", NAME="eth0"
    ATTR{address}=="36:89:21:f0:3e:29", NAME="eth1"
  '';
}
