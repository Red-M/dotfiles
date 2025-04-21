
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  # services.pulseaudio.enable = false;
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

  # sound.mediaKeys.enable = true;

  environment.systemPackages = with pkgs; [
    qpwgraph
    alsa-utils
    rnnoise-plugin
    ladspaPlugins
    wireplumber
    coppwr
  ];


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
        "flags" = [ "ifexists" "nofail" ];
        "args" = {
          #nice.level   = -11
          #rt.prio      = 88
          #rt.time.soft = 200000
          #rt.time.hard = 200000
        };
      }];
    };
    "10-virtual-groups" = {
      "context.modules" = [{
        "name" = "libpipewire-module-loopback";
        "flags" = [ "ifexists" "nofail" ];
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
          "flags" = [ "ifexists" "nofail" ];
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
            "flags" = [ "ifexists" "nofail" ];
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
          "flags" = [ "ifexists" "nofail" ];
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
        }
      ];
    };
    "15-echo-cancel" = {
      "context.modules" = [{
        "name" = "libpipewire-module-echo-cancel";
        "flags" = [ "ifexists" "nofail" ];
        "args" = {
          "library.name" = "aec/libspa-aec-webrtc";
          # "monitor.mode" = true;
          "aec.args" = {
            "webrtc.high_pass_filter" = true;
            "webrtc.noise_suppression" = true;
            "webrtc.voice_detection" = true;
            "webrtc.extended_filter" = true;
            "webrtc.delay_agnostic" = true;
            "webrtc.gain_control" = false; # AGC seems to mess up with Agnostic Delay Detection, especially with speech, result in very poor performance, disable by default
            "webrtc.experimental_agc" = false;
            "webrtc.experimental_ns" = true;
          };
          "audio.channels" = 1;
          "source.props" = {
            "node.name" = "echo_cancel.echoless";
            "node.autoconnect" = false;
          };
          "sink.props" = {
            "node.name" = "echo_cancel.sink";
            "node.autoconnect" = false;
          };
          "playback.props" = {
            "node.autoconnect" = false;
          };
        };
      }];
    };
    "20-noise-cancel" = {
      "context.modules" = [{ # https://github.com/werman/noise-suppression-for-voice
        "name" = "libpipewire-module-filter-chain";
        "flags" = [ "ifexists" "nofail" ];
        "args" = {
          "node.description" = "Noise Canceling Source";
          "media.name" = "Noise Canceling Source";
          "filter.graph" = {
            "nodes" = [{
              "type" = "ladspa";
              "name" = "rnnoise";
              "plugin" = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
              "label" = "noise_suppressor_mono";
              "control" = {
                "VAD Threshold (%)" = 65.0;
                "VAD Grace Period (ms)" = 80;
                "Retroactive VAD Grace (ms)" = 30;
              };
            }];
          };
          "capture.props" = {
            # "node.name" = "capture.rnnoise_source";
            # "node.passive" = true;
            "audio.rate" = 48000;
            "node.name" = "noise_cancel.cancel";
            "node.description" = "Noise Cancel Capture";
            "target.object" = "echo_cancel.echoless";
          };
          "playback.props" = {
            "node.name" = "noise_cancel.playback";
            "node.description" = "Noise Cancel Playback";
            "media.class" = "Audio/Source";
            "audio.rate" = 48000;
            "node.autoconnect" = false;
          };
          "source.props" = {
            "node.name" = "noise_cancel.source";
            "node.description" = "Noise Cancel Source";
            "node.autoconnect" = false;
          };
          "sink.props" = {
            "node.name" = "noise_cancel.sink";
            "node.description" = "Noise Cancel Sink";
          };
        };
      }];
    };
    "25-auto-gain" = {
      "context.modules" = [{
        "name" = "libpipewire-module-echo-cancel";
        "flags" = [ "ifexists" "nofail" ];
        "args" = {
          "library.name" = "aec/libspa-aec-webrtc";
          # "monitor.mode" = true;
          "node.description" = "Auto Gain Source";
          "media.name" = "Auto Gain Source";
          "aec.args" = {
            "webrtc.high_pass_filter" = false;
            "webrtc.noise_suppression" = false;
            "webrtc.voice_detection" = false;
            "webrtc.extended_filter" = false;
            "webrtc.delay_agnostic" = false;
            "webrtc.gain_control" = true;
            "webrtc.experimental_agc" = true;
            "webrtc.experimental_ns" = false;
          };
          "audio.channels" = 1;
          "capture.props" = {
            # "node.name" = "capture.rnnoise_source";
            # "node.passive" = true;
            "node.name" = "auto_gain.auto_gain";
            "target.object" = "noise_cancel.playback";
            "node.description" = "Auto Gain Capture";
            # "node.autoconnect" = false;
          };
          "source.props" = {
            "node.name" = "auto_gain.source";
            "node.description" = "Auto Gain Source";
            "node.autoconnect" = false;
          };
          "sink.props" = {
            "node.name" = "auto_gain.sink";
            "node.description" = "Auto Gain Sink";
            "node.autoconnect" = false;
          };
          "playback.props" = {
            "node.name" = "auto_gain.playback";
            "node.description" = "Auto Gain Playback";
            "media.class" = "Audio/Source";
            "node.autoconnect" = false;
          };
        };
      }];
    };
    "30-compressor" = {
      "context.modules" = [{ # https://github.com/werman/noise-suppression-for-voice
        "name" = "libpipewire-module-filter-chain";
        "flags" = [ "ifexists" "nofail" ];
        "args" = {
          "node.description" = "Compressor Source";
          "media.name" = "Compressor Source";
          "filter.graph" = {
            "nodes" = [{
              "type" = "ladspa";
              "name" = "module-ladspa-sink";
              "plugin" = "${pkgs.ladspaPlugins}/lib/ladspa/sc4m_1916.so";
              "label" = "sc4m";
              "control" = { # https://github.com/swh/ladspa/blob/master/sc4m_1916.xml
                "RMS/peak" = 1;
                "Attack time (ms)" = 1.5;
                "Release time (ms)" = 401;
                "Threshold level (dB)" = -30;
                "Ratio (1:n)" = 20;
                "Knee radius (dB)" = 5;
                "Makeup gain (dB)" = 18;
                # "Amplitude (dB)" = 0;
                # "Gain reduction (dB)" = -10;
              };
            }];
          };
          "capture.props" = {
            # "node.name" = "capture.rnnoise_source";
            # "node.passive" = true;
            "audio.rate" = 48000;
            "node.name" = "compressor.compressed";
            "node.description" = "Compressor Capture";
            "target.object" = "auto_gain.source";
          };
          "playback.props" = {
            "node.name" = "compressor.playback";
            "node.description" = "Compressor Playback";
            "media.class" = "Audio/Source";
            "audio.rate" = 48000;
            "node.autoconnect" = false;
          };
          "source.props" = {
            "node.name" = "compressor.source";
            "node.description" = "Compressor Source";
            "node.autoconnect" = false;
          };
          "sink.props" = {
            "node.name" = "compressor.sink";
            "node.description" = "Compressor Sink";
          };
        };
      }];
    };
  };

  services.pipewire.wireplumber.extraConfig = {
    "10-creative-soundcard" = {
      "monitor.alsa.rules" = [{
        matches = [
          { "node.name" = "*output.usb-Creative_Technology_Ltd_Sound_BlasterX_G6*"; }
        ];
        actions = {
          update-props = {
            "audio.rate" = 384000;
            "alsa.rate" = 384000;
            "alsa.resolution_bits" = 32;
            "node.max-latency" = "32768/384000";
            "audio.format" = "S32LE";
          };
        };
      }];
    };
    "10-music-soundcard" = {
      "monitor.alsa.rules" = [{
        matches = [
          { "node.name" = "*usb-Creative_Technology_Ltd_Sound_BlasterX_G6_2C00*"; }
        ];
        actions = {
          update-props = {
            "node.description" = "Music SoundBlasterX G6";
          };
        };
      }];
    };
    # "10-bluez" = {
    #   "monitor.bluez.properties" = {
    #     "bluez5.enable-sbc-xq" = true;
    #     "bluez5.enable-msbc" = true;
    #     "bluez5.enable-hw-volume" = true;
    #     "bluez5.roles" = [
    #       "hsp_hs"
    #       "hsp_ag"
    #       "hfp_hf"
    #       "hfp_ag"
    #     ];
    #   };
    # };

    "99-discord" = {
      "monitor.alsa.rules" = [{
        matches = [
          { "node.name" = "alsa_output.*"; }
        ];
        actions = {
          update-props = {
            "session.suspend-timeout-seconds" = 0;
          };
        };
      }];
    };

    "99-disable-suspend" = {
      "monitor.alsa.rules" = [{
        matches = [
          { "node.name" = "alsa_output.*"; }
        ];
        actions = {
          update-props = {
            "session.suspend-timeout-seconds" = 0;
          };
        };
      }];
    };
  };
}

