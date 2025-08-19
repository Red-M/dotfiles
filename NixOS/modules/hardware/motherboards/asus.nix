
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ./amd.nix
  ];

  boot = {
    extraModulePackages = with config.boot.kernelPackages; [
      (nct6687d.overrideAttrs (super: {
        postInstall = (super.postInstall or "") + ''
          find $out -name '*.ko' -exec xz {} \;
        '';
      })) # nct6687d
    ];
    kernelModules = with config.boot.kernelPackages; [
      "nct6687"
      "nct6775"
      "lm78"
    ];
  };
}

