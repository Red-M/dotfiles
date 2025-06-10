
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.disko.nixosModules.disko

    ../../homelab
    ../../../modules/servers/gitlab.nix
  ];

  networking.hostName = "gitlab";
  system.stateVersion = "25.11";

  systemd.services = {
  };


  # disko.devices = {
  #   disk.disk1 = {
  #     device = lib.mkDefault "/dev/sda";
  #     type = "disk";
  #     content = {
  #       type = "gpt";
  #       partitions = {
  #         boot = {
  #           name = "boot";
  #           size = "1M";
  #           type = "EF02";
  #         };
  #         esp = {
  #           name = "ESP";
  #           size = "4G";
  #           type = "EF00";
  #           content = {
  #             type = "filesystem";
  #             format = "vfat";
  #             mountpoint = "/boot";
  #             mountOptions = [ "umask=0077" ];
  #           };
  #         };
  #         luks = {
  #           size = "100%";
  #           content = {
  #             type = "luks";
  #             name = "OS-crypted";
  #             extraOpenArgs = [ ];
  #             askPassword = true;
  #             settings = {
  #               allowDiscards = true;
  #             };
  #             content = {
  #               type = "filesystem";
  #               format = "ext4";
  #               mountpoint = "/";
  #             };
  #           };
  #         };
  #       };
  #     };
  #   };
  # };

}

