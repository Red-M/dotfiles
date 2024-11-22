
{ config, lib, pkgs, nixbeta, unstable, nixmaster, inputs, ... }:

{
  services.hardware.openrgb.enable = true;
  users.users.redm = {
    packages = with pkgs; [
      (keepass.override {
        plugins = [
          keepass-keeagent
          keepass-keepasshttp
          keepass-keepassrpc
        ];
      })
      keeweb
    ];
  };
}

