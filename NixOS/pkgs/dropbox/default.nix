{
  stdenv,
  lib,
  buildFHSEnv,
  writeScript,
}:

let
  platforms = [
    "i686-linux"
    "x86_64-linux"
  ];
in

assert lib.elem stdenv.hostPlatform.system platforms;

# Dropbox client to bootstrap installation.
# The client is self-updating, so the actual version may be newer.
let
  version = "206.3.6386";

  arch =
    {
      x86_64-linux = "x86_64";
      i686-linux = "x86";
    }
    .${stdenv.hostPlatform.system};

  installer = "https://clientupdates.dropboxstatic.com/dbx-releng/client/dropbox-lnx.${arch}-${version}.tar.gz";

in

buildFHSEnv {
  name = "dropbox";

  # The dropbox-cli command `dropbox start` starts the dropbox daemon in a
  # separate session, and wants the daemon to outlive the launcher.  Enabling
  # `--die-with-parent` defeats this and causes the daemon to exit when
  # dropbox-cli exits.
  dieWithParent = false;

  # dropbox-cli (i.e. nautilus-dropbox) needs the PID to confirm dropbox is running.
  # Dropbox's internal limit-to-one-instance check also relies on the PID.
  unsharePid = false;

  targetPkgs =
    pkgs: with pkgs; [
      curl
      dbus
      procps
      zlib
    ];

  runScript = writeScript "install-and-start-dropbox" ''
    # export BROWSER=firefox
    export DISPLAY=

    set -e

    do_install=
    if ! [ -d "$HOME/.dropbox-dist" ]; then
        do_install=1
    else
        installed_version=$(cat "$HOME/.dropbox-dist/VERSION")
        latest_version=$(printf "${version}\n$installed_version\n" | sort -rV | head -n 1)
        if [ "x$installed_version" != "x$latest_version" ]; then
            do_install=1
        fi
    fi

    if [ -n "$do_install" ]; then
        installer=$(mktemp)
        # Dropbox is not installed.
        # Download and unpack the client. If a newer version is available,
        # the client will update itself when run.
        curl '${installer}' >"$installer"
        pkill dropbox || true
        rm -fr "$HOME/.dropbox-dist"
        tar -C "$HOME" -x -z -f "$installer"
        rm "$installer"
    fi

    exec "$HOME/.dropbox-dist/dropboxd" "$@"
  '';

  meta = with lib; {
    description = "Online stored folders (daemon version)";
    homepage = "http://www.dropbox.com/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ttuegel ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    mainProgram = "dropbox";
  };
}
