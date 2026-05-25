{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  autoPatchelfHook,
  pkg-config,
  libgcc,
  dbus,

}:

rustPlatform.buildRustPackage rec {
  pname = "vr-lighthouse";
  version = "0.1";
  src = fetchFromGitHub rec {
    owner = "ShayBox";
    repo = "Lighthouse";
    rev = "6c5e080dac852e82c18655d1214765d45aabedc9";
    hash = "sha256-Ai+d7BKA1o98iOhQ7VXltnWHW/knw122xLZHhFM6gZ0=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {};
  };

  nativeBuildInputs = [
    autoPatchelfHook
    pkg-config
  ];
  buildInputs = [
    dbus
    libgcc
  ];

}
