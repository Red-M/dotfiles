
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{

  services = {
    home-assistant = {
      enable = true;
      openFirewall = true;
      extraComponents = [
        "airq"
        "bluetooth"
        "bluetooth_adapters"
        "bluetooth_le_tracker"
        "bluetooth_tracker"
        "broadlink"
        "button"
        "calendar"
        "climate"
        "configurator"
        "default_config"
        "esphome"
        "fan"
        "ffmpeg"
        "ffmpeg_motion"
        "ffmpeg_noise"
        "flock"
        "group"
        "history"
        "history_stats"
        "homeassistant_alerts"
        "html5"
        "http"
        "hue"
        "input_boolean"
        "input_button"
        "input_datetime"
        "input_number"
        "input_select"
        "input_text"
        "integration"
        "iperf3"
        "iss"
        "jellyfin"
        "kitchen_sink"
        "lawn_mower"
        "lidarr"
        "light"
        "local_calendar"
        "local_file"
        "local_ip"
        "local_todo"
        "locative"
        "lock"
        "logbook"
        "logentries"
        "logger"
        "lovelace"
        "luci"
        "manual"
        "manual_mqtt"
        "media_player"
        "media_source"
        "mediaroom"
        "met"
        "mikrotik"
        "minecraft_server"
        "mqtt"
        "mqtt_eventstream"
        "mqtt_json"
        "mqtt_room"
        "mqtt_statestream"
        "persistent_notification"
        "person"
        "profiler"
        "qrcode"
        "radarr"
        "radio_browser"
        "recorder"
        "recovery_mode"
        "remote_rpi_gpio"
        "rflink"
        "sabnzbd"
        "scene"
        "schedule"
        "sensor"
        "serial"
        "serial_pm"
        "shodan"
        "speedtestdotnet"
        "spotify"
        "sun"
        "supervisord"
        "switch"
        "tcp"
        "usb"
        "vacuum"
        "version"
        "webdav"
        "webhook"
        "zha"
        "zone"
        "zwave_js"
        "zwave_me"
      ];
      extraPackages = python3Packages: with python3Packages; [
        psycopg2
      ];
    };

    # nginx = {
    #   enable = true;
    #   recommendedGzipSettings = false;
    #   recommendedOptimisation = true;
    #   recommendedProxySettings = true;
    #   recommendedTlsSettings = true;
    #   virtualHosts."redhass.red-m.net" = {
    #     forceSSL = true;
    #     sslCertificate = "/var/www/cert/cert.pem";
    #     sslCertificateKey = "/var/www/cert/privkey.pem";
    #     sslTrustedCertificate = "/var/www/cert/chain.pem";
    #     locations."/" = {
    #       proxyPass = "http://unix:/run/gitlab/gitlab-workhorse.socket";
    #       extraConfig = ''
    #         add_header X-Forwarded-Proto "https";
    #         add_header X-Forwarded-Ssl "on";
    #       '';
    #     };
    #   };
    # };
  };

}

