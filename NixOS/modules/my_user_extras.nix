
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
  ];

  users.users.redm = {
    packages = with pkgs; [
      irssi_plugins
      mise
      proxychains
      rclone
      tmuxp
    ];
  };

}

