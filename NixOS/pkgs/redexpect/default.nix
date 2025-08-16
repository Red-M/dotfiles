{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  redssh,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "redexpect";
  version = "2.0.3-3";

  src = fetchFromGitHub {
    owner = "Red-M";
    repo = "RedExpect";
    rev = "c96ab7361bd5cad79a3b9fd96e006b3ca068a60c";
    hash = "sha256-XFw+WFj8B1I1W8bp6I+D/bgmJGbexmv0lAtU2V4sSXM=";
  };

  build-system = [
    setuptools
  ];
  pyproject = true;
  patches = [
    ./version.patch
  ];

  dependencies = [
    redssh
  ];

  pythonImportsCheck = [ "redssh" ];

  # nativeCheckInputs = [
  #   unittestCheckHook
  # ];

}

