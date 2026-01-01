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
        inherit (pkgsi686Linux.gst_all_1) gstreamer gst-plugins-base;
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
