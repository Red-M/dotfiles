
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{

  #users.users.git.uid = config.users.users.gitlab.uid;
  services = {
    gitlab = {
      enable = true;
      databaseCreateLocally = false; # we need to do this ourselves
      databasePasswordFile = "/var/keys/gitlab/db_password";
      initialRootPasswordFile = "/var/keys/gitlab/root_password";
      https = true;
      # host = "gitlab.bubble-berry";
      port = 443;
      user = "git";
      group = "git";
      databaseUsername = "gitlab";
      smtp = {
        enable = true;
        address = "mail-relay.red-m.net";
        port = 25;
        authentication = "none";
        domain = config.services.gitlab.host;
      };
      secrets = {
        dbFile = "/var/keys/gitlab/db";
        secretFile = "/var/keys/gitlab/secret";
        otpFile = "/var/keys/gitlab/otp";
        jwsFile = "/var/keys/gitlab/jws";
        activeRecordSaltFile = "/var/keys/gitlab/db_record_salts";
        activeRecordPrimaryKeyFile = "/var/keys/gitlab/db_pk";
        activeRecordDeterministicKeyFile = "/var/keys/gitlab/db_deterministic";
      };
      packages = {
        gitlab = pkgs.gitlab-ee;
      };
      extraConfig = {
        gitlab = {
          email_from = "gitlab@${config.services.gitlab.host}";
          email_display_name = "Personal Gitlab";
          email_reply_to = "noreply@${config.services.gitlab.host}";
        };
        gitlab_rails = {
          db_username = config.services.gitlab.databaseUsername;
        };
      };
    };

    nginx = {
      enable = true;
      recommendedGzipSettings = false;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts."${config.services.gitlab.host}" = {
        forceSSL = true;
        sslCertificate = "/var/www/cert/cert.pem";
        sslCertificateKey = "/var/www/cert/privkey.pem";
        sslTrustedCertificate = "/var/www/cert/chain.pem";
        locations."/" = {
          proxyPass = "http://unix:/run/gitlab/gitlab-workhorse.socket";
          extraConfig = ''
            add_header X-Forwarded-Proto "https";
            add_header X-Forwarded-Ssl "on";
          '';
        };
      };
    };

    postgresql = {
      enable = true;
      identMap = ''
        gitlab postgres postgres
        gitlab git gitlab
      '';
      authentication = ''
        local all all     peer map=gitlab
      '';
    };

    openssh.enable = true;

  };

  systemd.services = {
    gitlab-postgresql = { # /var/lib/postgresql# sudo -u postgres pg_upgrade -b "$(nix build --no-link --print-out-paths nixpkgs#postgresql_17.out)/bin" -B /run/current-system/sw/bin -d /var/lib/postgresql/17 -D /var/lib/postgresql/18
      after = [ "postgresql.service" ];
      bindsTo = [ "postgresql.service" ];
      wantedBy = [ "gitlab.target" ];
      partOf = [ "gitlab.target" ];
      path = [
        config.services.postgresql.package
        pkgs.util-linux
      ];
      script = ''
        set -eu

        PSQL() {
          psql --port=${toString config.services.postgresql.settings.port} "$@"
        }

        PSQL -tAc "SELECT 1 FROM pg_database WHERE datname = '${config.services.gitlab.databaseName}'" | grep -q 1 || PSQL -tAc 'CREATE DATABASE "${config.services.gitlab.databaseName}" OWNER "${config.services.gitlab.databaseUsername}"'
        current_owner=$(PSQL -tAc "SELECT pg_catalog.pg_get_userbyid(datdba) FROM pg_catalog.pg_database WHERE datname = '${config.services.gitlab.databaseName}'")
        if [[ "$current_owner" != "${config.services.gitlab.databaseUsername}" ]]; then
          PSQL -tAc 'ALTER DATABASE "${config.services.gitlab.databaseName}" OWNER TO "${config.services.gitlab.databaseUsername}"'
          if [[ -e "${config.services.postgresql.dataDir}/.reassigning_${config.services.gitlab.databaseName}" ]]; then
            echo "Reassigning ownership of database ${config.services.gitlab.databaseName} to user ${config.services.gitlab.databaseUsername} failed on last boot. Failing..."
            exit 1
          fi
          touch "${config.services.postgresql.dataDir}/.reassigning_${config.services.gitlab.databaseName}"
          PSQL "${config.services.gitlab.databaseName}" -tAc "REASSIGN OWNED BY \"$current_owner\" TO \"${config.services.gitlab.databaseUsername}\""
          rm "${config.services.postgresql.dataDir}/.reassigning_${config.services.gitlab.databaseName}"
        fi
        PSQL '${config.services.gitlab.databaseName}' -tAc "CREATE EXTENSION IF NOT EXISTS pg_trgm"
        PSQL '${config.services.gitlab.databaseName}' -tAc "CREATE EXTENSION IF NOT EXISTS btree_gist;"
      '';

      serviceConfig = {
        Slice = "system-gitlab.slice";
        User = config.services.postgresql.superUser;
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };
    gitlab-backup.environment.BACKUP = "dump";
  };

}

