
{ config, lib, pkgs, nixbeta, unstable, nixmaster, inputs, ... }:

{
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  programs = {
    xwayland.enable = true;
  };

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

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };


  environment.systemPackages = with pkgs; [
    glxinfo

    # kdePackages
    kdePackages.kcalc
    kdePackages.kate
    kdePackages.sddm-kcm

    libglibutil
  ];

  hardware = {
    bluetooth.enable = true;

    graphics = {
      enable = true;
      ## radv: an open-source Vulkan driver from freedesktop
      enable32Bit = true;

      ## amdvlk: an open-source Vulkan driver from AMD
      # extraPackages = [ unstable.amdvlk ];
      # extraPackages32 = [ unstable.driversi686Linux.amdvlk ];
    };
    amdgpu.amdvlk = {
      enable = true;
      support32Bit.enable = true;
    };
  };

  services = {
    udisks2.enable = true;

  };
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (subject.isInGroup("wheel")) {
        if (action.id.startsWith("org.freedesktop.udisks2.")) {
          return polkit.Result.YES;
        }
      }
    });
  '';
}

