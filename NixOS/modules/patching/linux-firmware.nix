
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  nixpkgs.overlays = [(pkgfinal: pkgprev:
    {
      linux-firmware = pkgprev.linux-firmware.overrideAttrs (old : {
        version = "20250509";
        src = pkgs.fetchzip {
          url = "https://cdn.kernel.org/pub/linux/kernel/firmware/linux-firmware-20250509.tar.xz";
          hash = "sha256-0FrhgJQyCeRCa3s0vu8UOoN0ZgVCahTQsSH0o6G6hhY=";
        };
      });
    }
  )];

}



