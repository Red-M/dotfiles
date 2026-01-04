
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      # This allows automatic noise reduction from microphones
      extraLv2Packages = [ pkgs.lsp-plugins ];
    };
  };

  environment.systemPackages = with pkgs; [
    qpwgraph
    alsa-utils
    rnnoise-plugin
    ladspaPlugins
    wireplumber
    coppwr
    # raysession
  ];


  services.pipewire.extraConfig.pipewire = {
    "5-rates" = {
      "context.properties" = {
        "default.clock.min-quantum" = 16;
        "default.clock.max-quantum" = 16384;
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
      }];
    };
    "15-echo-cancel" = {
      "context.modules" = [{
        "name" = "libpipewire-module-echo-cancel";
        "flags" = [ "ifexists" "nofail" ];
        "args" = {
          "library.name" = "aec/libspa-aec-webrtc";
          "monitor.mode" = true;
          "aec.args" = {
            "webrtc.high_pass_filter" = true;
            "webrtc.noise_suppression" = true;
            "webrtc.voice_detection" = true;
            "webrtc.extended_filter" = true;
            "webrtc.delay_agnostic" = true;
            "webrtc.experimental_ns" = true;
            "webrtc.gain_control" = false; # AGC seems to mess up with Agnostic Delay Detection, especially with speech, result in very poor performance, disable by default
            "webrtc.experimental_agc" = false;
          };
          "source.props" = {
            "node.name" = "echo_cancel.echoless";
            "node.description" = "Echo-Cancel Source";
            "node.autoconnect" = false;
            "target.object" = "noise_cancel.playback";
            "audio.channels" = 1;
          };
          "playback.props" = {
            "node.name" = "echo_cancel.playback";
            "node.description" = "Echo Cancel Playback";
            "media.class" = "Audio/Source";
            "node.autoconnect" = true;
            "audio.channels" = 1;
          };
          "sink.props" = {
            "node.name" = "echo_cancel.sink";
            "node.description" = "Echo Cancel Sink";
            "node.autoconnect" = true;
            "audio.channels" = 2;
          };
        };
      }];
    };
    "20-noise-cancel" = {
      "context.modules" = [{
        "name" = "libpipewire-module-filter-chain";
        "flags" = [ "ifexists" "nofail" ];
        "args" = {
          "node.description" = "Noise Canceling Source";
          "media.name" = "Noise Canceling Source";
          "filter.graph" = {
            # "nodes" = [{
            #   "type" = "ladspa";
            #   "name" = "DeepFilter Mono";
            #   "plugin" = "${pkgs.deepfilternet}/lib/ladspa/libdeep_filter_ladspa.so";
            #   "label" = "deep_filter_mono";
            #   "control" = {
            #     "Attenuation Limit (dB)" = 100;
            #   };
            # }];
            "nodes" = [{
              "type" = "ladspa";
              "name" = "rnnoise";
              "plugin" = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
              "label" = "noise_suppressor_mono";
              "control" = {
                "VAD Threshold (%)" = 90.0;
                "VAD Grace Period (ms)" = 250;
                "Retroactive VAD Grace (ms)" = 0;
              };
            }];
          };
          "audio.rate" = 48000;
          "audio.channels" = 1;
          "capture.props" = {
            "node.passive" = true;
            "node.name" = "noise_cancel.cancel";
            "node.description" = "Noise Cancel Capture";
            "target.object" = "echo_cancel.echoless";
          };
          "playback.props" = {
            "node.name" = "noise_cancel.playback";
            "node.description" = "Noise Cancel Playback";
            "media.class" = "Audio/Source";
            "node.autoconnect" = false;
          };
        };
      }];
    };
    "25-compressor" = {
      "context.modules" = [{
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
                "Threshold level (dB)" = -10;
                "Ratio (1:n)" = 10;
                "Knee radius (dB)" = 10;
                "Makeup gain (dB)" = 20;
                # "Amplitude (dB)" = 0;
                # "Gain reduction (dB)" = -10;
              };
            }];
          };
          "capture.props" = {
            # "node.name" = "capture.rnnoise_source";
            # "node.passive" = true;
            # "audio.rate" = 48000;
            "node.name" = "compressor.compressed";
            "node.description" = "Compressor Capture";
            "target.object" = "noise_cancel.playback";
          };
          "playback.props" = {
            "node.name" = "compressor.playback";
            "node.description" = "Compressor Playback";
            "media.class" = "Audio/Source";
            "node.autoconnect" = false;
            "audio.rate" = 48000;
            "audio.channels" = 1;
          };
          "source.props" = {
            "node.name" = "compressor.source";
            "node.description" = "Compressor Source";
            "node.autoconnect" = false;
            "audio.channels" = 1;
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
    "10-hifi" = {
      "monitor.alsa.rules" = [{
        matches = [
          { "node.name" = "~alsa_output.usb-FIIO_FiiO_K11-01*"; }
          { "node.name" = "~alsa_output.usb-Creative_Technology_Ltd_Sound_BlasterX_G6*"; }
        ];
        actions = {
          update-props = {
            "audio.rate" = 384000;
          };
        };
      }];
    };

  };
}

