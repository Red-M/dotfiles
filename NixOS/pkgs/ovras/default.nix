{
  stdenv,
  lib,
  fetchFromGitHub,
  gcc,
  clang,
  qtbase,
  qmake,
  qtmultimedia,
  qtwebsockets,
  pulseaudio,
  libxt,
  libxtst,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "OVRAS";
  version = "v5.8.11";
  src = fetchFromGitHub {
    owner = "OpenVR-Advanced-Settings";
    repo = "OpenVR-AdvancedSettings";
    tag = "${version}";
    hash = "sha256-I409MD70W5+H3CD0WqmrAJRHx3ETEcmWZOJLAhhsysQ=";
  };

  buildInputs = [
    qtbase
    qtmultimedia
    qtwebsockets
    pulseaudio
    libxt
    libxtst
  ];
  nativeBuildInputs = [
    wrapQtAppsHook
    qmake
    gcc
    clang
  ];
  patches = [
    ./compiler_gcc.patch
  ];

}
