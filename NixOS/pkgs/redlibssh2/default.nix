{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cython,
  openssl,
  zlib,
  libssh2,
}:

buildPythonPackage rec {
  pname = "redlibssh2";
  version = "2.1.5-1";

  src = fetchFromGitHub {
    owner = "Red-M";
    repo = "Redlibssh2";
    rev = "d44e891a78b2ff74af10939b56e0f5139955e715";
    hash = "sha256-08e73GGA4rkClifRO1de2tZkR6r+rx+I6HOrZPqha2M=";
  };

  build-system = [ setuptools ];
  pyproject = true;
  nativeBuildInputs = [
    cython
  ];
  buildInputs = [
    openssl
    zlib
    libssh2
  ];

  env = {
    SYSTEM_LIBSSH2 = true;
  };

  pythonImportsCheck = [ "ssh2" ];

}
