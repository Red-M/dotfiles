{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cython,
  openssl,
  zlib,
  libssh,
}:

buildPythonPackage rec {
  pname = "redlibssh";
  version = "2.0.9-1";

  src = fetchFromGitHub {
    owner = "Red-M";
    repo = "Redlibssh";
    rev = "55519af19e2a35eb3b11ba9fd1af9d3fba851d3e";
    hash = "sha256-cm2/YLS/nCLJeObI4Ge1BIx2DUfN5D+X4Xzp/OSvUNM=";
  };

  build-system = [ setuptools ];
  pyproject = true;
  nativeBuildInputs = [
    cython
  ];
  buildInputs = [
    openssl
    zlib
    libssh
  ];

  env = {
    SYSTEM_LIBSSH = true;
  };

  pythonImportsCheck = [ "ssh" ];


}
