
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  users.users.redm = {
    packages = with pkgs; [
      (unstable.discord.override {
        withOpenASAR = false;
        withVencord = true;
      })
      (unstable.discord-ptb.override {
        withOpenASAR = false;
        withVencord = true;
      })
      (unstable.discord-canary.override {
        withOpenASAR = false;
        withVencord = true;
      })
      betterdiscordctl
      unstable.telegram-desktop
      teamspeak_client
    ];
  };

  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ]; # For the bitlbee libpurple matrix plugin

  services.bitlbee = {
    enable = true;
    plugins = with pkgs; [
      bitlbee-facebook
      bitlbee-mastodon
    ];
    libpurple_plugins = with pkgs; [
      pidginPackages.purple-matrix
      pidginPackages.purple-signald
    ];
  };

}

