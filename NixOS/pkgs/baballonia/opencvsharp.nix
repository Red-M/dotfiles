# SPDX-FileCopyrightText: 2025 ShyAssassin <ShyAssassin@assassin.dev>
#
# SPDX-License-Identifier: MIT
{
  lib,
  stdenv,
  cmake,
  opencv,
  fetchFromGitHub,

}:
stdenv.mkDerivation rec {
  pname = "opencvsharp";
  version = "4b7e1345bdc8229293c9ebaea37ef900ff2fbff4";
  src = fetchFromGitHub {
    owner = "shimat";
    repo = "opencvsharp";
    rev = "4b7e1345bdc8229293c9ebaea37ef900ff2fbff4";
    fetchSubmodules = false;
    sha256 = "sha256-aEzlqp5TSmfIp4A3wYXFBbFWmOlmK31qUVRy3+PpavY=";
  };
  date = "2025-08-17";

  buildInputs = [ opencv ];
  nativeBuildInputs = [ cmake ];
  sourceRoot = "${src.name}/src";

  cmakeFlags = [ (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5") ];

}

