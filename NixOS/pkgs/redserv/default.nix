{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  makeWrapper,
  openssl_3,

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

  nativeBuildInputs = [
    makeWrapper
    openssl_3
  ];
  propagatedBuildInputs = [
    (python3.withPackages (
      pythonPackages: with pythonPackages; [
        cherrypy
        requests
        watchdog
        psutil

        pexpect
        # ipaddress
        distro
        pyopenssl
        pycrypto
        mako
        jinja2
      ]
    ))
  ];
  preferLocalBuild = true;

  installPhase = ''
    install -Dm755 webserver3.py $out/bin/redserv
    install -Dm755 util/__init__.py $out/bin/util/__init__.py
    install -Dm755 util/ssl_fix.py $out/bin/util/ssl_fix.py
    install -Dm755 util/ssl_fix3.py $out/bin/util/ssl_fix3.py
    install -Dm755 util/ssl_pyopenssl.py $out/bin/util/ssl_pyopenssl.py
  '';

}
