{ lib, ... }: {
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = [
      "8.8.8.8"
      "8.8.4.4"
    ];
    defaultGateway = {
      address = "172.16.0.1";
      interface = "ens3";
    };
    defaultGateway6 = {
      address = "fd00:172:16::1";
      interface = "ens3";
    };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce true;
    interfaces = {
      ens3 = {
        ipv4.addresses = [
          { address="103.25.58.97"; prefixLength=32; }
        ];
        ipv6.addresses = [
          { address="2406:d500:7:2::c8"; prefixLength=128; }
          { address="2406:d500:7:c6::"; prefixLength=64; }
        ];
        # ipv4.routes = [ { address = ""; prefixLength = 32; } ];
        # ipv6.routes = [ { address = ""; prefixLength = 128; } ];
      };
    };
  };
  # services.udev.extraRules = ''
  #   ATTR{address}=="7a:de:cb:5a:93:c1", NAME="eth0"
  # '';
}
