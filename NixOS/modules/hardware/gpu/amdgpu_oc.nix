
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ./amdgpu.nix
  ];

  # systemd.services.lact = {
  #   description = "AMDGPU Control Daemon";
  #   after = ["multi-user.target"];
  #   wantedBy = ["multi-user.target"];
  #   serviceConfig = {
  #     ExecStart = "${pkgs.lact}/bin/lact daemon";
  #   };
  #   enable = true;
  # };
  #
  # environment.systemPackages = with pkgs; [
  #   lact
  # ];
  #
  # boot = {
  #   extraModprobeConfig = ''
  #     options amdgpu ppfeaturemask=0xffffffff
  #   '';
  # };

  hardware.amdgpu = {
    overdrive = {
      enable = true;
      ppfeaturemask = "0xffffffff";
    };
  };

  programs.corectrl.enable = true;

  users.users.redm = {
    extraGroups = [ "corectrl" ];
  };
}

