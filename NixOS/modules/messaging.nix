
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
      telegram-desktop
      teamspeak_client
    ];
  };
}

