
{ config, lib, pkgs, nixalt, unstable, nixmaster, outoftree, inputs, ... }:

{
  users.users.redm = {
    isNormalUser = true;
    description = "Red_M";
    group = "redm";
    extraGroups = [ "networkmanager" "wheel" ];
    initialPassword = "a"; # Very secure :^)
    packages = with pkgs; [
      unstable.neovim

      rclone
      curl
      mise
      complete-alias
      unixtools.xxd
      xorg.xwininfo
      xdotool
      xclip
      wget
      neofetch
      inetutils
      ipcalc
    ];
  };

  users.groups = {
    redm = {
      gid = 1000;
    };
  };

}

