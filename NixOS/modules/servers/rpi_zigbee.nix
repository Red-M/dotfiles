
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
  ];

  users.users.zigbee = {
    isNormalUser = true;
    description = "";
    # group = "pi";
    extraGroups = [ "dialout" ];
    initialPassword = "a"; # Very secure :^)
    packages = with pkgs; [
      socat
      ser2net
    ];
    openssh.authorizedKeys.keys = [
      ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAEAQDQcF7fW8GjmRxQRkZfeB+UPe1o+UyZBdGSdscnAUbhjoy8kaLNlhDZRLfix2C/iQCR5I8zWi0I2JuU36nXhPDfxy1VO6l4+r331AXH4jrZNdM3JK8P271DdYqqTq0p9AGNk9jRZLXA9HZ+nR0co6s+n9YxA+9hIZZ0emt09jsKbZTa2DFGOspcL8fpwqcCj4Kjj9yq9Yf9RS/ULhr+8S2Kiamti2+XWLtPCPrS2bEqBG4S42xkVllKNVezxAFXkXrBQ8BeOlaFFrEIyGvImaR+0H3OKL2oz+tOdb/vEEHkiwOlZa6w/M+321F5dDAReje1+CE4vFbLp2/jvPxYjAv9cX5pZXu3QUKIZb5nFzm1dN2UQPJCShDzj3TaQBKyUtJ5XS5vmzpPaGCyuaM81ePrglhPNrBzvbTiApxQ14ox9rt8WWjpn3DIKHoGoVHDIN8DeXi+8f4o6lUvnz1h6Pr2TKJGrAxbMID53miPMcVLSp2voDLPdkt2Xs4CS938EoR4wTY2EOugni4PZZCu+WOPVIzjmW+/nHye3P8UaL7vsHIauT0y11jsTbD0npcgW0AyXL5bOGXZyqLvlQFvWxF8DZmDa9hOd3BTbLQSbTxYSI7UNnb38BcklhhxbKUA1TqizGdqetwopuF5LwQFEJTkHxfEX8TaXYknVMGYJgAPbFZlq6zPabIc6s7EhwOj1RzS7zK0pjIDrDqL+28XLY584IvJnlAh10L8fY+ctIVLRMplRUm2mVhNq4UlqLBH+hfWUI0bDgGLNrh6456Exsonc++ow8dmCHGKwL8SlvWsVtk6XuDICJbxs4lNMfQCz1lYjQeRHi7K0JyMarUV0bHkLMNb6VT51347O0aa+6/aI779M5PN/nTrrLYK/dtzUX2d9euLevaiJoNYqW5NRxr+mmbicLEGUt3Hsw7rsu7+Iidu8DxN3XRRXckypjdxA91jzeG3tycjlxn4Myvwn7uASBdm7MhjVseLCyPuLeslVI97W/CMWTJZwA8PRI0inp41vrAxGOAiNmoiEufoRU6UKhAnoipIdrHxTTdhxj0kenMCU2d+03/nMKpwfiW9KkQcE1ChfuZdf+fSv4eO4EMIQb7xKL+hn4qNFDVFZUCFebJ+GObQ3bR1LjxJL+24DYwyNZ075pXJdASPWir4iZBnKoWZXUxWZPdD9jjTt4Fv2gZXm88iBkHkaforYtFqO2uD3xSe/LishOVOlEYS0VwiYf3Hg6d+Kz3fS+NS8J004iS1uqTOw6sMNtXlHn/V2nILzDaZHBtSemAsFE3/ckB4elaxFns+4iKQttOISfB6MFbxfgirv/UTwstPgJF7+OTZHOKy3ggpEQhOmJnXA7eh redm@home-assistant''
    ] ++ (config.users.users.redm.openssh.authorizedKeys.keys or []);
  };

}

