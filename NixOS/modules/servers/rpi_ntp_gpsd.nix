
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
  ];

  # boot.kernelParams = lib.mkForce [];
  systemd.services = {
    "serial-getty@".enable = lib.mkForce false;
  };


  hardware.raspberry-pi.config.all.dt-overlays = {
    pps-gpio = {
      enable = true;
      params = {
        gpiopin = {
          enable = true;
          value = "18";
        };
      };
    };
  };

  services = {
    udev.extraRules = ''
      SUBSYSTEM=="tty", KERNEL=="${builtins.elemAt (builtins.elemAt (builtins.split "/dev/(.*)" (builtins.elemAt config.services.gpsd.devices 0)) 1) 0}", OWNER="root", GROUP="tty", NAME="${builtins.elemAt (builtins.elemAt (builtins.split "/dev/(.*)" (builtins.elemAt config.services.gpsd.devices 0)) 1) 0}", SYMLINK+="gps0", TAG="systemd"
      # KERNEL=="ttyAMA0", OWNER="root", GROUP="tty", MODE="0660", SYMLINK+="gpsd0"
      # KERNEL=="pps2", OWNER="root", GROUP="tty", MODE="0660", SYMLINK+="gpspps0"
    '';
    ntp = {
      enable = true;
      extraConfig = ''
        # We allow up to 20 peers. This is more than the default, and ntpsec will
        # only care about the 'best' 4 (minclock 4, below), but in case of network
        # peering outages, you'll have a good chance of surviving with SOME peers
        # still accessible

        tos maxclock 20
        tos minclock 4 minsane 3

        # GPS Serial data reference (NTP0)
        server 127.127.46.0 minpoll 0 maxpoll 4 prefer
        fudge 127.127.46.0 time2 0.32226 refid GPS

        # GPS PPS reference (NTP1)
        server 127.127.22.0 minpoll 0 maxpoll 4 prefer
        fudge 127.127.22.0 time1 0.001500 flag3 1 refid PPS

        # local PTP reference (NTP2)
        # server 127.127.28.2
        # fudge 127.127.28.2 refid PTP

        # ntpsec only
        # refclock pps unit 0 refid PPS minpoll 0 maxpoll 4 flag2 0 flag3 1 flag4 1
        # refclock shm unit 0 refid GPS minpoll 0 maxpoll 4 time1 0.1315 stratum 1 prefer
      '';
    };

    gpsd = {
      enable = true;
      # devices = [ # This should get set in the rpi model's default group
      #   "/dev/ttyS0"
      # ];
      extraArgs = [
        "-r"
        "-F"
        "/run/gpsd.sock"
      ];
      readonly = false;
      nowait = true;
    };

  };

  environment.systemPackages = with pkgs; [
    gpsd
    pps-tools
  ];

  systemd.services.ntpd = {
    after = [ "gpsd.service" ];
    serviceConfig = {
      PrivateDevices = lib.mkForce false; # Fixes not being able to use the gpsd driver in ntpd because of security that I didn't ask for nor need, this requires access to /dev
      PrivateIPC = lib.mkForce false;
    };
  };

}

