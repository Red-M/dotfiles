
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  nixpkgs.config.permittedInsecurePackages = [ # https://github.com/NixOS/nixpkgs/issues/513122
    "openssl-1.1.1w"
  ];
  users.users.redm = {
    packages = with pkgs; [
      (discord.override {
        withOpenASAR = false;
        withVencord = true;
      })
      (discord-ptb.override {
        withOpenASAR = false;
        withVencord = true;
      })
      (discord-canary.override {
        withOpenASAR = false;
        withVencord = true;
      })
      betterdiscordctl
      telegram-desktop
      # teamspeak_client
    ];
  };

  # nixpkgs.config.permittedInsecurePackages = [
  #   "olm-3.2.16"
  # ]; # For the bitlbee libpurple matrix plugin

  services.bitlbee = {
    # enable = true;
    plugins = with pkgs; [
      bitlbee-facebook
      bitlbee-mastodon
    ];
    libpurple_plugins = with pkgs; [
      #pidginPackages.purple-matrix
      # pidginPackages.purple-signald
    ];
  };

}

