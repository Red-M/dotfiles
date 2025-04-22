{
  stdenv,
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  msbuild,
  makeWrapper,
  mono,

}:

buildDotnetModule rec {
  pname = "vrcadvert";
  version = "1.0.1";
  src = fetchFromGitHub {
    owner = "galister";
    repo = "VrcAdvert";
    rev = "7bb83a1ef2cb20a05d6d80463aecb973064dcc3d";
    hash = "sha256-ZUu+Xw7wMHNupT8enHy6wOtflV2ok6/gLd9jdmhit3s=";
  };

  # nativeBuildInputs = [
  #   msbuild
  #   makeWrapper
  # ];

  projectFile = "VrcAdvert.sln";
  nugetDeps = ./deps.nix;

  dotnet-sdk = dotnetCorePackages.dotnet_8.sdk;
  dotnet-runtime = dotnetCorePackages.dotnet_8.runtime;

  executables = [ "VrcAdvert" ];

}
