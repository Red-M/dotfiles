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
  libxcb,
  glib,
  cairo,
  gtk3,
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
    rev = "17165123b97d95d12093aa1f43fa96905058e2a9";
    hash = "sha256-o3Nie97o7LJp7e7O6NrtJhMa9DrNyBGQBD8E4vWBn1k=";
  };

  # useFetchCargoVendor = true;
  cargoHash = "sha256-ISKsYwIC1R4nMzakStKrCEtOxJfne8H6TCQLpNG6owE=";

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
    libxcb
    glib
    cairo
    gtk3
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

  # postPatch = ''
  #   substituteAllInPlace src/res/watch.yaml \
  #   --replace '"pactl"' '"${lib.getExe' pulseaudio "pactl"}"'
  #
  #   # TODO: src/res/keyboard.yaml references 'whisper_stt'
  # '';

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
