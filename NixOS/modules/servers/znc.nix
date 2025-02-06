
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  services.znc = {
    enable = true;
    dataDir = "/home/redm/.znc";
    user = "redm";
    group = "redm";
    modulePackages = with pkgs.zncModules; [
      playback
      privmsg
      ignore
      clientbuffer
      backlog
      clientaway
    ];
  };

}

