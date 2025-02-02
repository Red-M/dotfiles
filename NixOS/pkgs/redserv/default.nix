{
  lib,
  stdenv,
  fetchFromGitHub,
  python312,
  makeWrapper,

}:

stdenv.mkDerivation rec {
  name = "redserv";
  src = fetchFromGitHub {
    owner = "Red-M";
    repo = "RedServ";
    rev = "c176e0ae47d12e5988da965b8b2cbb51057784b5";
    hash = "sha256-pcuFgZ1iGMkRe1elkVDXsr4D70fUcUli1VAwvb4DLL8=";
  };
  version = "1.0-${src.rev}";

  patches = [
    ./rel_path.patch
  ];

  nativeBuildInputs = [ makeWrapper ];
  propagatedBuildInputs = [
    (python312.withPackages (pythonPackages: with pythonPackages; [
      cherrypy
      requests
      watchdog
      psutil

      pexpect
      # ipaddress
      distro
    ]))
  ];
  preferLocalBuild = true;

  installPhase = ''
    install -Dm755 webserver3.py $out/bin/redserv
    '';

}

