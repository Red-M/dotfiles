{
  alsa-lib,
  dbus,
  fetchFromGitHub,
  fontconfig,
  lib,
  libGL,
  libX11,
  libXext,
  libXrandr,
  libxkbcommon,
  makeWrapper,
  nix-update-script,
  openvr,
  openxr-loader,
  pipewire,
  pkg-config,
  pulseaudio,
  rustPlatform,
  shaderc,
  stdenv,
  testers,
  wayland,
  wlx-overlay-s,
  unstable,
}:

unstable.rustPlatform.buildRustPackage rec {
  pname = "wlx-overlay-s";
  version = "25.4.1-1";

  src = fetchFromGitHub {
    owner = "galister";
    repo = "wlx-overlay-s";
    # rev = "v${version}";
    rev = "5ca634b552f643d0670bd697e050765c7999bb2a";
    hash = "sha256-+q3mRi2DkGVxAacfevgfpknkY8ktyo8SdTO9KAF1Fe0=";
  };

  # useFetchCargoVendor = true;
  cargoHash = "sha256-AhASQ/5pqiPNNGQSZTdEsf1Uw4Mv5Nze1f+QaV4gaUo=";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    rustPlatform.bindgenHook
    shaderc
  ];

  buildInputs = [
    alsa-lib
    dbus
    fontconfig
    libGL
    libX11
    libXext
    libXrandr
    libxkbcommon
    openvr
    openxr-loader
    pipewire
    wayland
    shaderc
  ];

  env = {
    # LD_LIBRARY_PATH = lib.makeLibraryPath buildInputs;
    SHADERC_LIB_DIR = lib.makeLibraryPath [ shaderc ];
  };

  postPatch = ''
    substituteAllInPlace src/res/watch.yaml \
    --replace '"pactl"' '"${lib.getExe' pulseaudio "pactl"}"'

    # TODO: src/res/keyboard.yaml references 'whisper_stt'
  '';

  passthru = {
    tests.testVersion = testers.testVersion { package = wlx-overlay-s; };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Wayland/X11 desktop overlay for SteamVR and OpenXR, Vulkan edition";
    homepage = "https://github.com/galister/wlx-overlay-s";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Scrumplex ];
    platforms = lib.platforms.linux;
    broken = stdenv.hostPlatform.isAarch64;
    mainProgram = "wlx-overlay-s";
  };
}
