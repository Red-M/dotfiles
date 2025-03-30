{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  pkg-config,
  libusb1,

}:

stdenv.mkDerivation rec {
  pname = "argbColors";
  version = "55c87df89020cab9ccb3ba64b1640d4d9f5ff922";
  src = fetchFromGitHub rec {
      name = pname;
      owner = "developersu";
      repo = pname;
      rev = version;
      hash = "sha256-R7CeHflHHvQXarBvu7zpD+ao39h+15ZDZSXgM5VnfzU=";
    };

  buildInputs = [
    libusb1
  ];

  nativeBuildInputs = [ makeWrapper pkg-config ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -r ./bin/* $out/bin/
    runHook postInstall
  '';
}

