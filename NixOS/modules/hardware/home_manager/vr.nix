
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{

  home.file.".local/share/monado/hand-tracking-models".source = pkgs.fetchgit {
    url = "https://gitlab.freedesktop.org/monado/utilities/hand-tracking-models";
    sha256 = "x/X4HyyHdQUxn3CdMbWj5cfLvV7UyQe1D01H93UCk+M=";
    fetchLFS = true;
  };

  # https://github.com/yshui/index_camera_passthrough
  # xdg.configFile."index_camera_passthrough/index_camera_passthrough.toml".text = ''
  #   ## This is the configuration file for index_camera_passthrough.
  #   ## This file should live at ~/.config/index_camera_passthrough/index_camera_passthrough.toml
  #
  #   ## This is your selected backend
  #   ## possible values: "openxr" | "openvr"
  #   backend="openxr"
  #
  #   ## camera device to use. auto detect if not set
  #   # camera_device = "/dev/video0"
  #
  #   ## which button should toggle the overlay visibility. press things
  #   ## button on both controllers to toggle the overlay.
  #   ## possible values: "Menu" | "Grip" | "Trigger" | "A" | "B"
  #   toggle_button = "Menu"
  #
  #   ## how long does the button need to be held before the overlay open,
  #   ## closing the overlay is always instantaneous
  #   open_delay = "0s"
  #
  #   [overlay.position]
  #   ## how will the overlay be positioned.
  #   ## possible values:
  #   ##   - "Hmd":      stay in front of your Hmd
  #   ##   - "Sticky":   will remain in place upon the location of activation
  #   ##   - "Absolute": fixed place in VR space
  #   mode = "Hmd"
  #
  #   ## how far away should the overlay be placed
  #   ## only meaningful if mode is "Hmd"
  #   distance = 0.7
  #
  #   ## transformation matrix for absolute position, column-major
  #   ## only meaningful if mode is "Absolute"
  #   # transform = [ [1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1] ]
  #
  #   [display_mode]
  #   ## the display mode.
  #   ## possible values:
  #   ##   - "Stereo": show a 3D image, how much you can see is limited by how
  #   ##               big the overlay is in your field of view.
  #   ##   - "Flat":   show a flat image
  #   mode = "Stereo"
  #
  #   ## which camera's image to display in Flat mode
  #   ## only meaningful if mode is "Flat"
  #   # eye = "Left"
  #
  #   ## Because your eyes and the cameras are at different physical locations, it is impossible
  #   ## to project camera view into VR space perfectly. There are trade offs approximating
  #   ## this projection.
  #   ##
  #   ## possible values:
  #   ## (a smaller viewing range here means things too close to you will give you double vision).
  #   ##
  #   ##   - "FromCamera": in this mode, we assume your eyes are at the cameras' physical location. this mode
  #   ##                   has larger viewing range, but everything will look smaller to you.
  #   ##   - "FromEye":    in this mode, we assume your cameras are at your eyes' physical location. everything will
  #   ##                   have the right scale in this mode, but the viewing range is smaller.
  #   ##
  #   ## only available if mode is "Stereo"
  #   projection_mode = "FromEye"
  # '';

  xdg.configFile."openxr/opencomposite".source = "${pkgs.opencomposite-vendored}";
  xdg.configFile."openxr/xrizer".source = "${pkgs.xrizer}";
  # xdg.configFile."openxr/xrizer".source = "${pkgs.xrizer-patched}";
  # xdg.configFile."openxr/xrizer".source = "${pkgs.xrizer-patched2}";
  # xdg.configFile."openxr/1/active_runtime.json".source = "${pkgs.monado_patched}/share/openxr/1/openxr_monado.json";
  xdg.configFile."openxr/1/active_runtime.json".source = "${pkgs.monado_matrix}/share/openxr/1/openxr_monado.json";
  # xdg.configFile."openxr/1/active_runtime.json".source = "${pkgs.monado}/share/openxr/1/openxr_monado.json";
  # xdg.dataFile."openxr/1/api_layers/implicit.d/XR_APILAYER_NOVENDOR_xr_binder.json".source = "${outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.xrbinder}/manifest.json";
  # xdg.dataFile."openxr/1/api_layers/implicit.d/libxrBinder_module.so".source = "${outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.xrbinder}/libxrBinder_module.so";

  xdg.configFile."openvr/openvrpaths.vrpath".text = ''
    {
      "config": [
        "${config.xdg.dataHome}/Steam/config"
      ],
      "external_drivers": null,
      "jsonid": "vrpathreg",
      "log": [
        "${config.xdg.dataHome}/Steam/logs"
      ],
      "runtime": [
        "${config.xdg.configHome}/openxr/xrizer/lib/xrizer",
        "${config.home.homeDirectory}/.local/share/Steam/steamapps/common/SteamVR"
      ],
      "version": 1
    }
  '';

}

