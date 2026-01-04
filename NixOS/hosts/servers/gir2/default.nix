
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect

    ../../servers
  ];

  networking.hostName = "gir2";
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
        ':::::'    ':::::'     / ___|_ _|  _ \ /__  \
         \              /     | |  _ | || |_) |  ,) /
          '.  _...--  .'      | |_| || ||  _ <  /  /__
            '._ __ _.'         \____|___|_| \_\|_____/
                                .red-m.net
  '';

}

