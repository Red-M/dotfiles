
{ config, lib, pkgs, nixalt, unstable, nixmaster, inputs, ... }:

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
    kernelModules = with config.boot.kernelPackages; [
      "i2c-dev"
      "i2c-piix4"
      "jc42"
    ]; # fans, etc
    extraModprobeConfig = ''
      options amdgpu ppfeaturemask=0xffffffff
    '';
  };
}

