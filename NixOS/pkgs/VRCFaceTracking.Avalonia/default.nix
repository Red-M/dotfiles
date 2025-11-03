{
  cmake,
  opencv,
  udev,
  libjpeg,
  libGL,
  pkg-config,
  fontconfig,
  xorg,
  callPackage,
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
}:
buildDotnetModule rec {
  version = "1.1.0.0";
  pname = "vrchatfacetracking";
  src = ./.;

  buildInputs = [
    pkg-config
    fontconfig
    openssl
    icu
    krb5
    xorg.libX11
    xorg.libSM
    xorg.libICE
    (pkgs.callPackage ./simpleosc.nix { })
  ];
  runtimeDependencies = [
    vulkan-loader
    (pkgs.callPackage ./nix/simpleosc.nix { })
  ];
  nativeBuildInputs = [ autoPatchelfHook ];


  postUnpack = ''
    cp -r ${vrcft} $sourceRoot/src/VRCFaceTracking
    cp -r ${hyperText} $sourceRoot/src/HyperText.Avalonia
    cp -r ${desktopNotifications} $sourceRoot/src/DesktopNotifications

    # Fix permissions cause nix is dumb and doesnt set them correctly
    find $sourceRoot/src -type d -exec chmod 755 {} \;
    find $sourceRoot/src -type f -exec chmod 644 {} \;
  '';

  postFixup = ''
    mv $out/bin/VRCFaceTracking.Avalonia.Desktop $out/bin/vrchatfacetracking
    wrapProgram $out/bin/vrchatfacetracking --set LD_LIBRARY_PATH ${nixpkgs.lib.makeLibraryPath runtimeDependencies}
  '';

  dotnetSdk = dotnet.sdk;
  # Nuget deps is borked :/
  nugetDeps = ./nix/deps.json;
  dotnetRuntime = dotnet.runtime;
  dotnetInstallFlags = [ "--framework net8.0" ];
  executables = [ "VRCFaceTracking.Avalonia.Desktop" ];
  projectFile = "src/VRCFaceTracking.Avalonia.Desktop/VRCFaceTracking.Avalonia.Desktop.csproj";

}


