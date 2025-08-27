
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../servers
    ../../../modules/servers/znc.nix
  ];

  networking.hostName = "gir";
  system.stateVersion = "24.11";

  systemd.services = {
    znc.enable = true;
  };

  users.motd = ''
               .-
                 /
                 )
         __....--'--...__
        |                |
        |                |
        |.:::.      .:::.|
       .':::::'.  .:::::::.
       :::::::::  :::::::::
       :::::::::  :::::::::     ____ ___ ____
        ':::::'    ':::::'     / ___|_ _|  _ \
         \              /     | |  _ | || |_) |
          '.  _...--  .'      | |_| || ||  _ <
            '._ __ _.'         \____|___|_| \_\
                                .red-m.net
  '';

}

