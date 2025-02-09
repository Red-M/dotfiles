
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  services.znc = {
    enable = false;
    dataDir = "/home/redm/.znc";
    user = "redm";
    group = "redm";
    modulePackages = with pkgs.zncModules; [
      playback
      privmsg
      ignore
      clientbuffer
      backlog
      clientaway
    ];
  };

  users.users.redm = {
    packages = with pkgs; [
      znc
    ];
  };
  # networking.firewall.allowedTCPPorts = [ 9001 9002 9003 9004 ];

  systemd.services.znc = {
    enable = lib.mkDefault false;
    description = "ZNC Server";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    serviceConfig = {
      User = config.services.znc.user;
      Group = config.services.znc.group;
      Restart = "always";
      ExecStart = "${pkgs.znc}/bin/znc --foreground --datadir ${config.services.znc.dataDir} ${lib.escapeShellArgs config.services.znc.extraFlags}";
      ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      ExecStop = "${pkgs.coreutils}/bin/kill -INT $MAINPID";
      CapabilityBoundingSet = [ "" ];
      DevicePolicy = "closed";
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      PrivateDevices = true;
      PrivateTmp = true;
      PrivateUsers = true;
      ProcSubset = "pid";
      ProtectClock = true;
      ProtectControlGroups = true;
      # ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      ProtectSystem = "strict";
      ReadWritePaths = [ config.services.znc.dataDir ];
      RemoveIPC = true;
      RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = [ "@system-service" "~@privileged" "~@resources" ];
      UMask = "0027";
    };
    preStart = ''
      # Ensure essential files exist.
      if [[ ! -f ${config.services.znc.dataDir}/configs/znc.conf ]]; then
          echo "No znc.conf file found in ${config.services.znc.dataDir}."
          ls -alh ${config.services.znc.dataDir}
          exit 1
      fi

      if [[ ! -f ${config.services.znc.dataDir}/znc.pem ]]; then
        echo "No znc.pem file found in ${config.services.znc.dataDir}. Creating one now."
        ${pkgs.znc}/bin/znc --makepem --datadir ${config.services.znc.dataDir}
      fi

      # Symlink modules
      rm ${config.services.znc.dataDir}/modules || true
      ln -fs ${pkgs.buildEnv { name = "znc-modules"; paths = config.services.znc.modulePackages; }}/lib/znc ${config.services.znc.dataDir}/modules
    '';
  };

}

