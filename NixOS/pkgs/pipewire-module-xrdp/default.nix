{ stdenv
, fetchFromGitHub
, lib
, pipewire
, autoreconfHook
, pkg-config
, nixosTests
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "pipewire-module-xrdp";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "neutrinolabs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7UspJxpxFy/W15Hz4mtLCIxx42t+vpnRxNJk67BmWJk=";
  };

# installPhase = ''
#   runHook preInstall
#
#   mkdir -p $out/lib/pulseaudio/modules $out/libexec/pulsaudio-xrdp-module $out/etc/xdg/autostart
#   install -m 755 src/.libs/*${pkgs.stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/pulseaudio/modules
#
#   install -m 755 instfiles/load_pa_modules.sh $out/libexec/pulsaudio-xrdp-module/pulseaudio_xrdp_init
#   substituteInPlace $out/libexec/pulsaudio-xrdp-module/pulseaudio_xrdp_init \
#     --replace pactl ${pkgs.pulseaudio}/bin/pactl
#
#   runHook postInstall
# '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config

  ];

  buildInputs = [
    pipewire
  ];

  makeFlags = [
    "prefix=${placeholder "out"}"
  ];
  outputs = [ "out" ];
  configureFlags = [
    "--with-module-dir=${placeholder "out"}/lib/pipewire-0.3"
    "--with-xdgautostart-dir=${placeholder "out"}/etc/xdg"
  ];

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
    tests = {
    };
  };

  meta = with lib; {
    description = "xrdp sink/source pipewire modules";
    homepage = "https://github.com/neutrinolabs/pipewire-module-xrdp";
    license = licenses.mit;
    maintainers = with maintainers; [  ];
    platforms = platforms.linux;
    sourceProvenance = [ sourceTypes.fromSource ];
    pkgConfigModules = [ "pipewire" ];
  };
}

