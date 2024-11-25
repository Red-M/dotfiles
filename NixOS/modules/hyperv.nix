
{ config, lib, pkgs, nixalt, unstable, nixmaster, inputs, ... }:

{
  boot = {
    initrd.kernelModules = [
      "hv_balloon"
      "hv_netvsc"
      "hv_storvsc"
      "hv_utils"
      "hv_vmbus"
    ];
    initrd.availableKernelModules = [ "hyperv_keyboard" ];
    blacklistedKernelModules = [ "hyperv_fb" ]; # workaround to use hyperv_drm
    extraModulePackages = with config.boot.kernelPackages; [ "hyperv-daemons" ];
    kernelModules = [ "hv_sock" ];
  };

  environment.systemPackages = [
    config.boot.kernelPackages.hyperv-daemons.bin
  ];

  virtualisation.hypervGuest.enable = true;

  services = {
    xrdp = {
      enable = true;
      package = (pkgs.xrdp.overrideAttrs (super: {
        config.systemd.services.xrdp.serviceConfig.ExecStart = "${pkgs.xrdp}/bin/xrdp --nodaemon --port vsock://-1:3389 --config ${confDir}/xrdp.ini"; # https://github.com/NixOS/nixpkgs/pull/300418
      }));
      defaultWindowManager = "startplasma-x11";
      openFirewall = true;
      audio.enable = true;
      extraConfDirCommands = ''
        substituteInPlace $out/xrdp.ini \
          --replace-fail security_layer=negotiate security_layer=rdp \
          --replace-fail crypt_level=high crypt_level=none \
          --replace-fail bitmap_compression=true bitmap_compression=false
        substituteInPlace $out/sesman.ini \
          --replace-fail FuseMountName=thinclient_drives FuseMountName=shared-drives
      '';
    };
  };
  systemd.packages = [ config.boot.kernelPackages.hyperv-daemons.lib ];

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          )
        )
      {
        return polkit.Result.YES;
      }
    });
  '';

}

