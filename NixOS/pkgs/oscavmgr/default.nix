{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openxr-loader,
  openssl,

}:

rustPlatform.buildRustPackage rec {
  pname = "oscavmgr";
  version = "25.2";
  src = fetchFromGitHub rec {
    owner = "galister";
    repo = "oscavmgr";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-592qj0dHn0fbIFt4Y+1TESIOUpwXcJ2tnlKNcYuxriQ=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "openxr-0.19.0" = "sha256-kbEYoN4UvUEaZA9LJWEKx1X1r+l91GjTWs1hNXhr7cw=";
      "alvr_common-20.12.1" = "sha256-T7KyGZwnJ9t4Bh8KFy190IV3igWCG+yn+OW9a6mgmYI=";
      "settings-schema-0.2.0" = "sha256-luEdAKDTq76dMeo5kA+QDTHpRMFUg3n0qvyQ7DkId0k=";
    };
  };
  buildNoDefaultFeatures = true;
  buildFeatures = [
    "openxr"
    "babble"
  ]; # ALVR has a nasty bug (which doesn't swear, but its pretty aggressive), nixpkgs won't pull submodules down in cargo deps....

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    openxr-loader
    openssl
  ];

}
