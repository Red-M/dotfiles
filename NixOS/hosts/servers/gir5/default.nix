
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect

    ../../servers
  ];

  networking.hostName = "gir5";
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
        ':::::'    ':::::'     / ___|_ _|  _ \ |  ___|
         \              /     | |  _ | || |_) ||_[___
          '.  _...--  .'      | |_| || ||  _ < ___)  )
            '._ __ _.'         \____|___|_| \_\\____/
                                .red-m.net
  '';

}

