
{ config, lib, pkgs, nixalt, unstable, nixmaster, outoftree, inputs, ... }:

{
  users.users.redm = {
    packages = with pkgs; [
      (lib.mkIf (config.services.displayManager.sddm.wayland.enable == true) freecad-wayland)
      (lib.mkIf (config.services.displayManager.sddm.wayland.enable == false) freecad)
    ];
  };
}

