
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect

    ../../servers
  ];

  networking.hostName = "gir7";
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
       :::::::::  :::::::::     ____ ___ ____  ______
        ':::::'    ':::::'     / ___|_ _|  _ \|____  |
         \              /     | |  _ | || |_) |   / /
          '.  _...--  .'      | |_| || ||  _ <   / /
            '._ __ _.'         \____|___|_| \_\ |_/
                                .red-m.net
  '';

}

