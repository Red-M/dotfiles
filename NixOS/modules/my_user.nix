
{ config, lib, pkgs, unstable, inputs, ... }:

{
  users.users.redm = {
    isNormalUser = true;
    description = "Red_M";
    group = "redm";
    extraGroups = [ "networkmanager" "wheel" "kvm" ];
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
      wget
      deluge
      remmina
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

