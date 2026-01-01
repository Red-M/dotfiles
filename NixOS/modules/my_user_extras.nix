
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ./extractors.nix
  ];

  users.users.redm = {
    packages = with pkgs; [
      irssi_plugins
      mise
      proxychains
      rclone
      tmuxp
      yt-dlp
      sshfs
    ];
  };

}

