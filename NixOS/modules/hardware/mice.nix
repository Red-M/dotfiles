
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  services.ratbagd.enable = true;
  users.users.redm = {
    packages = with pkgs; [
      piper
    ];
  };

}

