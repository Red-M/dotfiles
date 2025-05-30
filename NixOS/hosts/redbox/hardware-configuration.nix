# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  boot.initrd.availableKernelModules = [ "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/24bc0cfd-8dcd-454a-a8f3-40da6870dc26";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-3ab1790b-aae4-40fd-ba88-6cc5812cb593".device = "/dev/disk/by-uuid/3ab1790b-aae4-40fd-ba88-6cc5812cb593";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/8097-A6AE";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/319c02d4-106b-4239-9f25-13ee5f5e3bb2";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-7c2e662d-dcee-4951-a53a-e20ef2a84911".device = "/dev/disk/by-uuid/7c2e662d-dcee-4951-a53a-e20ef2a84911";

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eth0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  virtualisation.hypervGuest.enable = true;
}
