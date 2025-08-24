{
  lib,
  stdenv,
  fetchFromGitHub,
  python,
  makeWrapper,
  redexpect,

}:

stdenv.mkDerivation rec {
  name = "serial_portal";
  src = fetchFromGitHub {
    owner = "Red-M";
    repo = "Serial_portal";
    rev = "5022b013f5845d4728e80c110210449b296f07e3";
    hash = "sha256-iSK9bP700YTsQpo5VVuLBmWIQx4hIU4HP2vzey/gAmQ=";
  };
  version = "1.0-${src.rev}";

  nativeBuildInputs = [
    makeWrapper
  ];
  propagatedBuildInputs = [
    (python.withPackages (
      pythonPackages: with pythonPackages; [
        redexpect
        pyyaml
      ]
    ))
  ];
  preferLocalBuild = true;

  installPhase = ''
    install -Dm755 serial_portal.py $out/bin/serial_portal.py
  '';

}
