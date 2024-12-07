
{ config, lib, pkgs, nixalt, unstable, nixmaster, inputs, ... }:

{
  users.users.redm = {
    isNormalUser = true;
    description = "Red_M";
    group = "redm";
    extraGroups = [ "networkmanager" "wheel" ];
    initialPassword = "a"; # Very secure :^)
    packages = with pkgs; [
      unstable.neovim

      google-chrome

      python3
      rclone
      curl
      mise
      complete-alias
      unixtools.xxd
      xorg.xwininfo
      xdotool
      xclip
      wget
      deluge
      remmina
      neofetch
      inetutils
    ];
  };

  users.groups = {
    redm = {
      gid = 1000;
    };
  };

  environment.etc."opt/chrome/native-messaging-hosts/org.keepassxc.keepassxc_browser.json".text = ''
    {
      "name": "org.keepassxc.keepassxc_browser",
      "description": "KeepassXC integration with Native Messaging support",
      "path" : "${pkgs.keeweb}/share/keeweb-desktop/keeweb-native-messaging-host",
      "type": "stdio",
      "allowed_origins": [
        "chrome-extension://pikpfmjfkekaeinceagbebpfkmkdlcjk/",
        "chrome-extension://dphoaaiomekdhacmfoblfblmncpnbahm/",
        "chrome-extension://iopaggbpplllidnfmcghoonnokmjoicf/",
        "chrome-extension://oboonakemofpalcgghocfoadofidjkkk/",
        "chrome-extension://pdffhmdngciaglkoonimfcmckehcpafo/"
      ]
    }
  '';

}

