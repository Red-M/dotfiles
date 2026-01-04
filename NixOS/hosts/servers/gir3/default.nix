
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect

    ../../servers
  ];

  networking.hostName = "gir3";
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
       :::::::::  :::::::::     ____ ___ ____   _____
        ':::::'    ':::::'     / ___|_ _|  _ \ /____ \
         \              /     | |  _ | || |_) |   .>  >
          '.  _...--  .'      | |_| || ||  _ < ____>  >
            '._ __ _.'         \____|___|_| \_\\_____/
                                .red-m.net
  '';

}

