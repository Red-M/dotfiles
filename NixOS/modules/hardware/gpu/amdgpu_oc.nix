
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  imports = [
    ./amdgpu.nix
  ];

  hardware.amdgpu = {
    overdrive = {
      enable = true;
      ppfeaturemask = "0xffffffff";
    };
  };

  services.lact = {
    enable = true;
    package = pkgs.lact_patched; # Needs patches for newer kernel
  };
  nixpkgs.overlays = [(final: prev: {
    lact_patched = final.lact.overrideAttrs (finalAttrs: prevAttrs: {
      version = prevAttrs.version+"1337";
      __intentionallyOverridingVersion = true;
      src = pkgs.fetchFromGitHub {
        owner = "ilya-zlobintsev";
        repo = "LACT";
        rev = "1e9ed8b81f8fe46ab4606c71f859d4738a6d7b27";
        hash = "sha256-1dq6oKJigRntIXwxXVFIQGoRiVkX0OUHl16gA75OHYQ=";
      };
      buildInputs = (prevAttrs.buildInputs or []) ++ [
        pkgs.libdisplay-info
      ];

      doCheck = false;
      cargoHash = "sha256-XV37VRbCaxySMgEqXmIA0TUpI9uR+6jGOzdMlEfWxDw=";
      cargoDeps = prevAttrs.cargoDeps.overrideAttrs (old: {
        vendorStaging = old.vendorStaging.overrideAttrs {
          inherit (finalAttrs) src;
          outputHash = "sha256-XV37VRbCaxySMgEqXmIA0TUpI9uR+6jGOzdMlEfWxDw=";
        };
      });
    });
  })];

  # programs.corectrl.enable = true;
  # users.users.redm = {
  #   extraGroups = [ "corectrl" ];
  # };
}

