
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  nixpkgs.overlays = [(final: prev: {
    cura-appimage = prev.cura-appimage.overrideAttrs rec {
      version = "5.13.0";
      pname = "cura-appimage";
      appimageBinName = "cura-appimage-tools-output";
      wrapperScriptName = "${pname}-wrapper-script";

      src = pkgs.fetchurl {
        url = "https://github.com/Ultimaker/Cura/releases/download/${version}/Ultimaker-Cura-${version}-linux-X64.AppImage";
        hash = "sha256-EA8GgSeyWYFn8Auk2w4Gmd7UWt+Xu6stIv8XGh4ezEA=";
      };
      appimageContents = pkgs.appimageTools.extract {
        inherit pname version src;
      };
      curaAppimageToolsWrapped = pkgs.appimageTools.wrapType2 {
        inherit src;
        # For `appimageTools.wrapType2`, `pname` determines the binary's name in `bin/`.
        pname = appimageBinName;
        inherit version;
        extraPkgs = _: [ ];
      };
      script = pkgs.writeScriptBin wrapperScriptName ''
        #!${pkgs.stdenv.shell}
        # AppImage version of Cura loses current working directory and treats all paths relateive to $HOME.
        # So we convert each of the files passed as argument to an absolute path.
        # This fixes use cases like `cd /path/to/my/files; cura mymodel.stl anothermodel.stl`.

        args=()
        for a in "$@"; do
          if [ -e "$a" ]; then
            a="$(realpath "$a")"
          fi
          args+=("$a")
        done
        QT_QPA_PLATFORM=xcb GTK_USE_PORTAL=1 exec "${curaAppimageToolsWrapped}/bin/${appimageBinName}" "''${args[@]}"
      '';
      installPhase = ''
        runHook preInstall

        mkdir -p $out/bin
        cp ${script}/bin/${wrapperScriptName} $out/bin/cura

        mkdir -p $out/share/applications $out/share/icons/hicolor/128x128/apps
        install -Dm644 ${appimageContents}/usr/share/icons/hicolor/128x128/apps/cura-icon.png $out/share/icons/hicolor/128x128/apps/cura-icon.png

        runHook postInstall
      '';
    };
  })];

}

