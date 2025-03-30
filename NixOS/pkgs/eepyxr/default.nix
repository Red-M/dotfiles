{
  lib,
  fetchFromGitHub,
  stdenv,
  zig,
  pkg-config,
  sdl3,
  openxr-loader,
  callPackage,
}:
stdenv.mkDerivation rec {
  pname = "eepyxr";
  version = "b826495d60b297d4a7a38c3c10203c919209fc3d";
  src = fetchFromGitHub {
    owner = "Beyley";
    repo = pname;
    rev = "b826495d60b297d4a7a38c3c10203c919209fc3d";
    hash = "sha256-eDGIE/Mbc+52qAqjU+N5yrR23BO7PXLJTsZFG66qoqE=";
  };

  nativeBuildInputs = [
    zig.hook
  ];

  buildInputs = [
    pkg-config
    # openxr-loader
    (sdl3.overrideAttrs {
      src = fetchFromGitHub {
        owner = "Beyley";
        repo = "SDL";
        rev = "f516f2011668f6b8c9deacdaee1287620ca6b8bc";
        hash = "sha256-RvOwh5BDnl7aHc8pNGQAaLQD1ShhwSqvxUFY4Ec+YpA=";
      };
    })
  ];

  postPatch = ''
    ln -s ${callPackage ./deps.nix { }} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  zigBuildFlags = [ "-Doptimize=ReleaseSafe" ];

  dontUseZigCheck = true;
}

