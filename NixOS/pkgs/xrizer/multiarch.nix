{
  lib,
  pkgsi686Linux,
  symlinkJoin,

  xrizer,
  multiarchOverrideAttrs ? { },
}:

let
  hostArchPkg = (xrizer.overrideAttrs multiarchOverrideAttrs);
in
symlinkJoin rec {
  pname = "xrizer_multiarch";
  version = lib.getAttr "version" hostArchPkg;

  paths = [
    hostArchPkg
    ((pkgsi686Linux.callPackage hostArchPkg.override { }).overrideAttrs multiarchOverrideAttrs)
  ];

  meta = {
    platforms = [
      "x86_64-linux"
    ];
  };
}
