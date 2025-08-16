{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  redlibssh,
  redlibssh2,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "redssh";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "Red-M";
    repo = "RedSSH";
    rev = "fc789cf4994ccd0499d86fe554187d6af8c6d5e5";
    hash = "sha256-fRkfxCGBADu+LQuQ2DwdTNSqGN0jN7ECsl2kXag6J+4=";
  };

  build-system = [
    setuptools
  ];
  pyproject = true;
  patches = [
    ./version.patch
  ];

  dependencies = [
    redlibssh
    redlibssh2
  ];

  pythonImportsCheck = [ "redssh" ];

  # nativeCheckInputs = [
  #   unittestCheckHook
  # ];

}

