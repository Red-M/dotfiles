
{ config, lib, pkgs, unstable, inputs, ... }:

{
  systemd.services.lact = {
    description = "AMDGPU Control Daemon";
    after = ["multi-user.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = "${pkgs.lact}/bin/lact daemon";
    };
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    lact
  ];

  boot = {
    extraModprobeConfig = ''
      options amdgpu ppfeaturemask=0xffffffff
    '';
  };
}

