{
  lib,
  pkgsi686Linux,
  symlinkJoin,

  monado,
  multiarchOverrideAttrs ? { },
}:

let
  hostArchPkg = (monado.overrideAttrs multiarchOverrideAttrs);
in
symlinkJoin rec {
  pname = "monado_multiarch";
  version = lib.getAttr "version" hostArchPkg;

  paths = [
    hostArchPkg
    (
      (pkgsi686Linux.callPackage hostArchPkg.override {
        clientLibOnly = true;
      }).overrideAttrs
      multiarchOverrideAttrs
    )
  ];

  meta = {
    platforms = [
      "x86_64-linux"
    ];
  };
}
