
{ config, lib, pkgs, nixbeta, unstable, nixmaster, inputs, ... }:

{
  users.users.redm = {
    packages = with pkgs; [
      (pkgs.wrapOBS { plugins = [
        obs-studio-plugins.obs-vkcapture
        obs-studio-plugins.input-overlay
        obs-studio-plugins.obs-backgroundremoval
        obs-studio-plugins.obs-tuna
        obs-studio-plugins.obs-vaapi
        # obs-studio-plugins.obs-ndi # broken on 24.11
        obs-studio-plugins.obs-teleport
        obs-studio-plugins.obs-source-clone
        obs-studio-plugins.obs-shaderfilter
        obs-studio-plugins.looking-glass-obs
        obs-studio-plugins.obs-pipewire-audio-capture
        obs-studio-plugins.wlrobs
      ]; }) # obs-studio and plugins
    ];
  };
}

