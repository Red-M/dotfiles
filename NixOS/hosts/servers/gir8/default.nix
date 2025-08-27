
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect

    ../../servers
  ];

  networking.hostName = "gir8";
  system.stateVersion = "24.11";

  # TODO fix me <3
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
       :::::::::  :::::::::     ____ ___ ____  _  _
        ':::::'    ':::::'     / ___|_ _|  _ \| || |
         \              /     | |  _ | || |_) | || |_
          '.  _...--  .'      | |_| || ||  _ <|__   _|
            '._ __ _.'         \____|___|_| \_\  |_|
                                .red-m.net
  '';

}

