
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect

    ../../servers
    ../../../modules/servers/mail_relay.nix
  ];

  networking.hostName = "gir8";
  system.stateVersion = "24.11";

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
       :::::::::  :::::::::     ____ ___ ____   ____
        ':::::'    ':::::'     / ___|_ _|  _ \ |    |
         \              /     | |  _ | || |_) || [] |
          '.  _...--  .'      | |_| || ||  _ < | [] |
            '._ __ _.'         \____|___|_| \_\|____|
                                .red-m.net
  '';

}

