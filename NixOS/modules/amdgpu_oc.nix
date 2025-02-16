
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
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
  programs.corectrl = {
    enable = true;
    gpuOverclock = {
      enable = true;
      ppfeaturemask = "0xffffffff";
    };
  };

  users.users.redm = {
    extraGroups = [ "corectrl" ];
  };
}

