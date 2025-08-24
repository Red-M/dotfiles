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
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "Red-M";
    repo = "RedExpect";
    rev = "1f7a3edebacf590555e79db8868ad9c5a7a157e2";
    hash = "sha256-qOSdKODzA+wnLx4fBZZ4N0iIgNZTZ/s8+gfXMgfEE+A=";
  };

  build-system = [
    setuptools
  ];
  pyproject = true;

  dependencies = [
    redssh
  ];

  pythonImportsCheck = [ "redssh" ];

  # nativeCheckInputs = [
  #   unittestCheckHook
  # ];

}

