{
  stdenv,
  lib,
  fetchFromGitLab,
  cmake,
  makeWrapper,
  pkg-config,
  SDL2,
  imgui,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "xrBinder";
  version = "aa1fd219196ef074a03f8a06c85b04d582ec663f";
  src = fetchFromGitLab {
    owner = "mittorn";
    repo = "xrBinder";
    hash = "sha256-xxsbqj6IJnszhfwNR4MDJlcJeUBdCIKSVhlIJc5F6V8=";
    rev = "${version}";
    fetchSubmodules = true;
  };

  buildInputs = [
    (SDL2.overrideAttrs (old: {
      dontDisableStatic = true;
    }))
    imgui
  ];
  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
    xorg.libX11.dev
    xorg.libXft
  ];

  installPhase = ''
    runHook preInstall
    cp -r ./XR_APILAYER_NOVENDOR_xr_binder $out/
    runHook postInstall
    '';

}
