
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ./amd.nix
  ];

  boot = {
    kernelParams = [ "acpi_enforce_resources=lax" ];
    extraModulePackages = with config.boot.kernelPackages; [
      # (it87.overrideAttrs (super: {
      #   postInstall = (super.postInstall or "") + ''
      #     find $out -name '*.ko' -exec xz {} \;
      #   '';
      # })) # it87
      (outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.it87.overrideAttrs (super: { # Updates to newer version, needed by X870E aorus master mobo https://github.com/NixOS/nixpkgs/pull/399927
        postInstall = (super.postInstall or "") + ''
          find $out -name '*.ko' -exec xz {} \;
        '';
      })) # it87
    ];
    kernelModules = with config.boot.kernelPackages; [
      "it87"
    ];
    extraModprobeConfig = ''
      options it87 ignore_resource_conflict=1 mmio=1
    '';
  };

  # X870E Master
  services.udev.extraRules = ''
    SUBSYSTEM=="input", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="048d", ATTRS{idProduct}=="5711", MODE="0666"
  '';
}

