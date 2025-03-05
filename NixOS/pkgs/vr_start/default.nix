{
  stdenv,
  lib,
  fetchFromGitHub,
  symlinkJoin,
  writeShellApplication,
  toybox,
  job-security,
  openxr-loader,
  vrcadvert,
  oscavmgr,
  motoc,
  lovr-playspace,
  wlx-overlay-s,
  adgobye,
  index_camera_passthrough,

}:

writeShellApplication {
  name = "vr_start";

  runtimeInputs = [
    toybox
    job-security
    openxr-loader
    vrcadvert
    oscavmgr
    motoc
    lovr-playspace
    wlx-overlay-s
    adgobye
    index_camera_passthrough
  ];

  text = ''
    export AMD_VULKAN_ICD="RADV"

    function clean_up() {
      echo "exiting"
      jobs -p | xargs kill
      systemctl --user stop monado.service
      echo "bye!"
    }
    export -f clean_up

    # stop VrcAdvert after OscAvMgr quits
    trap clean_up EXIT

    VrcAdvert OscAvMgr 9402 9002 --tracking &

    # If using WiVRn (disabled for now)
    oscavmgr openxr &

    ## If using ALVR
    #./oscavmgr alvr

    ## If using Project Babble and/or EyeTrackVR
    #./oscavmgr babble

    motoc monitor &> /dev/null &
    lovr-playspace &
    wlx-overlay-s &
    # AdGoBye &
    index_camera_passthrough

  '';
}

