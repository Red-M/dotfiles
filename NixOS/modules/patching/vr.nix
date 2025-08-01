
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  nixpkgs.overlays = [(final: prev: {
      monado_patched = final.monado.overrideAttrs (old : {
        # version = old.version+"3";
        # src = pkgs.fetchgit {
        #   url = "https://gitlab.freedesktop.org/monado/monado.git";
        #   rev = "3eda5cbf1efcf075d5a0594991944639541b5dfa";
        #   fetchSubmodules = false;
        #   deepClone = false;
        #   leaveDotGit = false;
        #   sparseCheckout = [ ];
        #   sha256 = "sha256-NSOvFqIOo7QLya9ipGAdO/Vm9ryEQiPfP6ptxSfmpLc=";
        # };
        # src = pkgs.fetchgit {
        #   url = "https://gitlab.freedesktop.org/monado/monado.git";
        #   rev = "1d37e1d6c8c0fa7c86f8cea029c5d12ee43d3f12";
        #   fetchSubmodules = false;
        #   deepClone = false;
        #   leaveDotGit = false;
        #   sparseCheckout = [ ];
        #   sha256 = "sha256-4iQjNpPyH423Z07YohWEvvE/VX6bCcZ4GafL5KST9gg=";
        # };
        patches = (old.patches or []) ++ [
          # ./patches/monado/2253.patch # solarxr
          # ./patches/monado/2426.patch # index brightness
          # ./patches/monado/2522.patch # regession fix for 2509
          ./patches/monado/up_client_max.patch
        ];
      });

    wlx-overlay-s_patched = final.wlx-overlay-s.overrideAttrs rec {
      nativeBuildInputs = with pkgs; [
        inputs.fenix.packages.${pkgs.system}.default.toolchain
      ] ++ final.wlx-overlay-s.nativeBuildInputs;
    };

    wlx-overlay-s_patched2 = outoftree.pkgs.${pkgs.system}.wlx-overlay-s.overrideAttrs rec {
      nativeBuildInputs = with pkgs; [
        inputs.fenix.packages.${pkgs.system}.default.toolchain
      ] ++ outoftree.pkgs.${pkgs.system}.wlx-overlay-s.nativeBuildInputs;
    };

    xrizer-patched = final.xrizer.overrideAttrs rec {
      src = pkgs.fetchgit {
        url = "https://github.com/Supreeeme/xrizer.git";
        fetchSubmodules = false;
        deepClone = false;
        leaveDotGit = false;
        sparseCheckout = [ ];
        rev = "74c3462d27ce3bdeeee70011746c9cfdf83cb49b";
        sha256 = "sha256-Up4Qk3IvppjdT11VG0LBsn2EJo+TGPM6j2h/VLjJBxs=";
      };
      nativeBuildInputs = with pkgs; [
        inputs.fenix.packages.${pkgs.system}.default.toolchain
      ] ++ final.xrizer.nativeBuildInputs;
      patches = [
        # ./patching/patches/xrizer/68.patch
        # ./patching/patches/xrizer/69.patch
        # ./patching/patches/xrizer/82.patch
        # ./patching/patches/xrizer/funny_serial_numbers.patch
        # ./patching/patches/xrizer/rin_experimental2_funny_serials.patch
      ] ++ outoftree.pkgs.${pkgs.system}.xrizer.patches;
      doCheck = false;
      # target = "i686-unknown-linux-gnu";
      # target = "x86_64-unknown-linux-gnu";
    };

    xrizer-patched2 = outoftree.pkgs.${pkgs.system}.xrizer.overrideAttrs rec {
      nativeBuildInputs = with pkgs; [
        inputs.fenix.packages.${pkgs.system}.default.toolchain
      ] ++ outoftree.pkgs.${pkgs.system}.xrizer.nativeBuildInputs;
      patches = [
      ] ++ outoftree.pkgs.${pkgs.system}.xrizer.patches;
      doCheck = false;
    };
  })];

}

