
{ config, lib, pkgs, unstable, inputs, ... }:

{
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  programs = {
    xwayland.enable = true;
  };

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "au";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];


  environment.systemPackages = with pkgs; [
    glxinfo

    # kdePackages
    kdePackages.kcalc
    kdePackages.kate
    kdePackages.sddm-kcm

  ];

  hardware = {
    bluetooth.enable = true;

    graphics = {
      ## radv: an open-source Vulkan driver from freedesktop
      enable32Bit = true;

      ## amdvlk: an open-source Vulkan driver from AMD
      extraPackages = [ unstable.amdvlk ];
      extraPackages32 = [ unstable.driversi686Linux.amdvlk ];
    };
  };

  services = {
    udisks2.enable = true;

  };

}

