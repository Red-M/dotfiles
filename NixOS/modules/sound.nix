
{ config, lib, pkgs, unstable, inputs, ... }:

{
  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # This allows automatic noise reduction from microphones
    extraLv2Packages = [ pkgs.lsp-plugins ];
  };

  services.pipewire.extraConfig.pipewire = {
    "5-rates" = {
      "context.properties" = {
        "clock.force-rate" = 384000;
        "default.clock.rate" = 384000;
        "default.clock.allowed-rates" = [
          44100
          48000
          88200
          96000
          192000
          384000
        ];
      };
    };
    "5-rt" = {
      "context.modules" = [{
        "name" = "libpipewire-module-rtkit";
        "args" = {
          #nice.level   = -11
          #rt.prio      = 88
          #rt.time.soft = 200000
          #rt.time.hard = 200000
        };
        "flags" = [ "ifexists" "nofail" ];
      }];
    };
    "10-noise-cancel" = {
        "context.modules" = [{ # https://github.com/werman/noise-suppression-for-voice
        "name" = "libpipewire-module-filter-chain";
        "args" = {
          "node.description" = "Noise Canceling source";
            "media.name" = "Noise Canceling source";
            "filter.graph" = {
              "nodes" = [{
                "type" = "ladspa";
                "name" = "rnnoise";
                "plugin" = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
                "label" = "noise_suppressor_mono";
                "control" = {
                  "VAD Threshold (%)" = 50.0;
                  "VAD Grace Period (ms)" = 20;
                  "Retroactive VAD Grace (ms)" = 0;
                };
              }];
            };
          "capture.props" = {
            "node.name" = "capture.rnnoise_source";
            "node.passive" = true;
            "audio.rate" = 48000;
          };
          "playback.props" = {
            "node.name" = "rnnoise_source";
            "media.class" = "Audio/Source";
            "audio.rate" = 48000;
          };
        };
      }];
    };
    "10-virtual-groups" = {
      "context.modules" = [{
          "name" = "libpipewire-module-loopback";
          "args" = {
              "node.name" = "loopback_group_default";
              "node.description" = "Catch-all";
              "source_dont_move" = false;
              "remix" = false;
              "stream.dont-remix" = true;
              "node.passive" = true;
              "capture.props" = {
                  "device.intended-roles" = "Games";
                  "media.class" = "Audio/Sink";
                  "audio.position" = [ "FL" "FR" ];
              };
              "playback.props" = {
                  "audio.position" = [ "FL" "FR" ];
                  "node.passive" = true;
                  "node.dont-remix" = true;
              };
          };
      }{
          "name" = "libpipewire-module-loopback";
          "args" = {
              "node.name" = "loopback_group_music";
              "node.description" = "Music";
              "source_dont_move" = false;
              "remix" = false;
              "stream.dont-remix" = true;
              "node.passive" = true;
              "capture.props" = {
                  "device.intended-roles" = "Music";
                  "media.class" = "Audio/Sink";
                  "audio.position" = [ "FL" "FR" ];
              };
              "playback.props" = {
                  "audio.position" = [ "FL" "FR" ];
                  "node.passive" = true;
                  "node.dont-remix" = true;
              };
          };
      }{
          "name" = "libpipewire-module-loopback";
          "args" = {
              "node.name" = "loopback_group_voice";
              "node.description" = "Voice";
              "source_dont_move" = false;
              "remix" = false;
              "stream.dont-remix" = true;
              "node.passive" = true;
              "capture.props" = {
                  "device.intended-roles" = "Communication";
                  "media.class" = "Audio/Sink";
                  "audio.position" = [ "FL" "FR" ];
              };
              "playback.props" = {
                  "audio.position" = [ "FL" "FR" ];
                  "node.passive" = true;
                  "node.dont-remix" = true;
              };
          };
      }{
          "name" = "libpipewire-module-loopback";
          "args" = {
              "node.name" = "loopback_group_low_prio_games";
              "node.description" = "Low Priority";
              "source_dont_move" = false;
              "remix" = false;
              "stream.dont-remix" = true;
              "node.passive" = true;
              "capture.props" = {
                  "media.class" = "Audio/Sink";
                  "audio.position" = [ "FL" "FR" ];
              };
              "playback.props" = {
                  "audio.position" = [ "FL" "FR" ];
                  "node.passive" = true;
                  "node.dont-remix" = true;
              };
          };
      }];
    };
    "10-echo-cancel" = {
      "context.modules" = [{
        "name" = "libpipewire-module-echo-cancel";
        "args" = {
          "library.name" = "aec/libspa-aec-webrtc";
          "monitor.mode" = true;
          "aec.args" = {
            "webrtc.extended_filter" = true;
            "webrtc.delay_agnostic" = true;
            "webrtc.high_pass_filter" = true;
            "webrtc.noise_suppression" = true;
            "webrtc.voice_detection" = true;
            "webrtc.gain_control" = true;
            "webrtc.experimental_agc" = true;
            "webrtc.experimental_ns" = true;
          };
          "audio.channels" = 1;
            "source.props" = {
              "node.name" = "Echo Cancellation Source";
            };
          "sink.props" = {
            "node.name" = "Echo Cancellation Sink";
          };
        };
      }];
    };
  };

  services.pipewire.wireplumber.extraConfig = {
    "creative-soundcard" = {
      "alsa_monitor.rules" = [{
        "matches" = [
          { "node.name" = "*output.usb-Creative_Technology_Ltd_Sound_BlasterX_G6*"; }
        ];
        "apply_properties" = {
          "audio.rate" = 384000;
          "alsa.rate" = 384000;
          "alsa.resolution_bits" = 32;
          "node.max-latency" = "32768/384000";
          "audio.format" = "S32LE";
        };
      }];
    };
    "music-soundcard" = {
      "alsa_monitor.rules" = [{
        "matches" = [
          { "node.name" = "*usb-Creative_Technology_Ltd_Sound_BlasterX_G6_2C00*"; }
        ];
        "apply_properties" = {
          "node.description" = "Music SoundBlasterX G6";
        };
      }];
    };
  };
}

