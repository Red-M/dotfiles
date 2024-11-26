
{ config, lib, pkgs, nixalt, unstable, nixmaster, inputs, ... }:

{
  boot = {
    initrd.kernelModules = [
      "hv_balloon"
      "hv_netvsc"
      "hv_storvsc"
      "hv_utils"
      "hv_vmbus"
    ];
    initrd.availableKernelModules = [ "hyperv_keyboard" ];
    blacklistedKernelModules = [ "hyperv_fb" ]; # workaround to use hyperv_drm
    extraModulePackages = with config.boot.kernelPackages; [ hyperv-daemons ];
    kernelModules = [ "hv_sock" ];
  };

  environment.systemPackages = [
    config.boot.kernelPackages.hyperv-daemons.bin
    pkgs.pulseaudio-module-xrdp

    # (pkgs.stdenv.mkDerivation {
    #   pname = "pipewire-module-xrdp";
    #   version = "0.2";
    #
    #   src = fetchFromGitHub {
    #     owner = "neutrinolabs";
    #     repo = pname;
    #     rev = "v${version}";
    #     hash = "";
    #   };
    #
    #   preConfigure = ''
    #     tar -xvf ${pkgs.pulseaudio.src}
    #     mv pulseaudio-* pulseaudio-src
    #     chmod +w -Rv pulseaudio-src
    #     cp ${pkgs.pulseaudio.dev}/include/pulse/config.h pulseaudio-src
    #     configureFlags="$configureFlags PULSE_DIR=$(realpath ./pulseaudio-src)"
    #   '';
    #
    #   installPhase = ''
    #     runHook preInstall
    #
    #     mkdir -p $out/lib/pulseaudio/modules $out/libexec/pulsaudio-xrdp-module $out/etc/xdg/autostart
    #     install -m 755 src/.libs/*${pkgs.stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/pulseaudio/modules
    #
    #     install -m 755 instfiles/load_pa_modules.sh $out/libexec/pulsaudio-xrdp-module/pulseaudio_xrdp_init
    #     substituteInPlace $out/libexec/pulsaudio-xrdp-module/pulseaudio_xrdp_init \
    #       --replace pactl ${pkgs.pulseaudio}/bin/pactl
    #
    #     runHook postInstall
    #   '';
    #
    #   nativeBuildInputs = [
    #     pkgs.autoreconfHook
    #     pkgs.pkg-config
    #     pkgs.pipewire.dev
    #   ];
    #
    #   passthru = {
    #     updateScript = gitUpdater { rev-prefix = "v"; };
    #     tests = {
    #       inherit (nixosTests) xrdp-with-audio-pulseaudio;
    #     };
    #   };
    #
    #   meta = with lib; {
    #     description = "xrdp sink/source pipewire modules";
    #     homepage = "https://github.com/neutrinolabs/pipewire-module-xrdp";
    #     license = licenses.mit;
    #     maintainers = with maintainers; [  ];
    #     platforms = platforms.linux;
    #     sourceProvenance = [ sourceTypes.fromSource ];
    #   };
    # })

  ];

  systemd.packages = [ config.boot.kernelPackages.hyperv-daemons.lib ];

  virtualisation.hypervGuest.enable = true;

  services = {
    xrdp = {
      enable = true;
      defaultWindowManager = "startplasma-x11";
      openFirewall = true;
      audio.enable = true;
      extraConfDirCommands = ''
        substituteInPlace $out/xrdp.ini \
          --replace-fail security_layer=negotiate security_layer=rdp \
          --replace-fail crypt_level=high crypt_level=none \
          --replace-fail bitmap_compression=true bitmap_compression=false
        substituteInPlace $out/sesman.ini \
          --replace-fail FuseMountName=thinclient_drives FuseMountName=shared-drives
      '';
    };
  };
  systemd.services.xrdp.serviceConfig.ExecStart = lib.mkForce "${pkgs.xrdp.outPath}/bin/xrdp --nodaemon --port vsock://-1:3389 --config /etc/xrdp/xrdp.ini";

  services.pipewire.extraConfig.pipewire = {
    "80-xrdp" = {
      "context.modules" = [{
        "name" = "libpipewire-module-xrdp";
        "args" = {
          "sink.node.latency" = 2048;
          "sink.stream.props" = {
            "node.name" = "xrdp-sink";
          };
          "source.stream.props" = {
            "node.name" = "xrdp-source";
          };
          #nice.level   = -11
          #rt.prio      = 88
          #rt.time.soft = 200000
          #rt.time.hard = 200000
        };
        "flags" = [ "ifexists" "nofail" ];
      }];
    };
  };

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          )
        )
      {
        return polkit.Result.YES;
      }
    });
  '';

}

