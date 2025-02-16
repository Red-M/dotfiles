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
  pname = "AdGoBye";
  version = "4.0.2";
  src = fetchFromGitHub {
    name = pname;
    owner = "AdGoBye";
    repo = pname;
    # tag = "v${version}+v4IsBrokenPullMe";
    rev = "9ef438f4bffdc032ea7dc7d1fa7c01f5527ce21b";
    fetchSubmodules = true;
    # hash = "sha256-YDrSmLNQti6Jk6uljpN47f3GirtStcGuPc0GCz9OTBA=";
    hash = "sha256-96WEFSWe1YaCAs702md5UTmgovx6FjiFUfr6wnQXnv4=";
  };

  # projectFile = "AdGoBye.sln";
  projectFile = "AdGoBye/AdGoBye.csproj";
  nugetDeps = ./deps.nix;

  dotnet-sdk = dotnetCorePackages.dotnet_8.sdk;
  dotnet-runtime = dotnetCorePackages.dotnet_8.runtime;

  executables = [ "AdGoBye" ];



}

