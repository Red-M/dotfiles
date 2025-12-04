# SPDX-FileCopyrightText: 2025 ShyAssassin <ShyAssassin@assassin.dev>
#
# SPDX-License-Identifier: MIT
{
  cmake,
  opencv,
  udev,
  libjpeg,
  libGL,
  fontconfig,
  xorg,
  callPackage,
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  onnxruntime,
}:
let
  internal = builtins.fetchurl {
    url = "http://217.154.52.44:7771/builds/trainer/1.0.0.0.zip";
    sha256 = "sha256:0cfc1r1nwcrkihmi9xn4higybyawy465qa6kpls2bjh9wbl5ys82";
  };

  dotnet = dotnetCorePackages.dotnet_8;

  baballoniaPrograms = [
    cmake
    opencv
    udev
    libjpeg
    libGL
    fontconfig
    xorg.libX11
    xorg.libSM
    xorg.libICE
    (callPackage ./onnxruntime.nix { rocmSupport = true; })
    (callPackage ./opencvsharp.nix { })
  ];
in
buildDotnetModule (finalAttrs: {
  pname = "baballonia";
  src = fetchFromGitHub {
    owner = "leon-costa";
    repo = "Baballonia";
    rev = "2ffac2ca4a4f57c1e786d02949f26b4968637efb";
    fetchSubmodules = true;
    sha256 = "sha256-9cP7koRCfqoNum3wVqgRX3jn9cWzOJa7LUwjoLYFu8Q=";
  };
  date = "2025-10-22";
  # NOTE: We cannot use the git revision as the version as
  #       that will cause dotnet to fail
  version = "0.0.0";

  patches = [ ./0001-disable-auto-updating.patch ];

  buildInputs = baballoniaPrograms;

  dotnetSdk = dotnet.sdk;
  nugetDeps = ./deps.json;
  dotnetRuntime = dotnet.runtime;
  projectFile = "src/Baballonia.Desktop/Baballonia.Desktop.csproj";

  runtimeDeps = baballoniaPrograms;

  makeWrapperArgs = [
    "--chdir"
    "${placeholder "out"}/lib/baballonia"
  ];

  postUnpack = ''
    cp ${internal} $sourceRoot/src/Baballonia.Desktop/_internal.zip
    # For some reason submodule perms get messed up
    find $sourceRoot/src -type d -exec chmod 755 {} \;
    find $sourceRoot/src -type f -exec chmod 644 {} \;
  '';

  postFixup = ''
    mkdir -p $out/lib/baballonia/Modules
    mv $out/bin/Baballonia.Desktop $out/bin/baballonia
    mv $out/lib/baballonia/Baballonia.VFTCapture.dll $out/lib/baballonia/Modules/
    mv $out/lib/baballonia/Baballonia.VFTCapture.pdb $out/lib/baballonia/Modules/
    mv $out/lib/baballonia/Baballonia.OpenCVCapture.dll $out/lib/baballonia/Modules/
    mv $out/lib/baballonia/Baballonia.OpenCVCapture.pdb $out/lib/baballonia/Modules/
    mv $out/lib/baballonia/Baballonia.IPCameraCapture.dll $out/lib/baballonia/Modules/
    mv $out/lib/baballonia/Baballonia.IPCameraCapture.pdb $out/lib/baballonia/Modules/
    mv $out/lib/baballonia/Baballonia.SerialCameraCapture.dll $out/lib/baballonia/Modules/
    mv $out/lib/baballonia/Baballonia.SerialCameraCapture.pdb $out/lib/baballonia/Modules/
  '';

})

