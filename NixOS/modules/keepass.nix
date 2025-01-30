
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
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

