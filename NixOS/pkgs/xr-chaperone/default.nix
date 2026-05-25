{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  autoPatchelfHook,
  pkg-config,
  openxr-loader,
  shaderc,
  libxkbcommon,
  libX11,
  libXcursor,
  libXi,
  libXrandr,
  libxcb,
  wayland,

}:

rustPlatform.buildRustPackage rec {
  pname = "xr-chaperone";
  version = "0.1";
  src = fetchFromGitHub rec {
    owner = "FrostyCoolSlug";
    repo = "xr-chaperone";
    rev = "694dc7cb652c6005235a6053f7b35e3d78fce5e5";
    hash = "sha256-Uqat+xyFqLfkZNVfbdia7+omC7aC9ntKCq6PvxbEKbk=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
    };
  };
  patches = [
    # ./diff.patch
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    pkg-config
  ];
  buildInputs = [
    libxkbcommon
    openxr-loader
    shaderc
    wayland
  ];

  runtimeDependencies = [
    libxkbcommon
    libX11
    libXcursor
    libXi
    libXrandr
    libxcb
    wayland
  ];

}
