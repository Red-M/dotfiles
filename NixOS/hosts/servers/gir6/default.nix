
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect

    ../../servers
  ];

  networking.hostName = "gir6";
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
       :::::::::  :::::::::     ____ ___ ____   ___
        ':::::'    ':::::'     / ___|_ _|  _ \ / __\
         \              /     | |  _ | || |_) | |__
          '.  _...--  .'      | |_| || ||  _ <|  O )
            '._ __ _.'         \____|___|_| \_\\___/
                                .red-m.net
  '';

}

