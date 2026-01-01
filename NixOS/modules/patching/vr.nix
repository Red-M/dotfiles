
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  nixpkgs.overlays = [(final: prev: {
    monado_patched = final.monado.overrideAttrs (old : {
      version = old.version+"1337";
      __intentionallyOverridingVersion = true;
      # src = pkgs.fetchgit {
      #   url = "https://gitlab.freedesktop.org/monado/monado.git";
      #   rev = "3eda5cbf1efcf075d5a0594991944639541b5dfa";
      #   fetchSubmodules = false;
      #   deepClone = false;
      #   leaveDotGit = false;
      #   sparseCheckout = [ ];
      #   sha256 = "sha256-NSOvFqIOo7QLya9ipGAdO/Vm9ryEQiPfP6ptxSfmpLc=";
      # };
      cmakeFlags = old.cmakeFlags ++ [
        (lib.cmakeBool "XRT_HAVE_OPENCV" false)
      ];
      nativeBuildInputs = old.nativeBuildInputs ++ [
        final.opencv4
      ];
      patches = (old.patches or []) ++ [
        # ./patches/monado/2253.patch # solarxr
        # ./patches/monado/2426.patch # index brightness
        # ./patches/monado/2522.patch # regession fix for 2509
        # ./patches/monado/up_client_max.patch
        ./patches/monado/2685.patch
      ];
    });
    monado_matrix = final.monado.overrideAttrs (old : {
      version = old.version+"1337";
      __intentionallyOverridingVersion = true;
      src = pkgs.fetchgit {
        url = "https://tangled.org/@matrixfurry.com/monado";
        rev = "b3fa7b3599c327ba393578d35f7fbd8061de9aca";
        fetchSubmodules = false;
        deepClone = false;
        leaveDotGit = false;
        sparseCheckout = [ ];
        sha256 = "sha256-+Y6Y3J+UDa7UuYAlEMPwlhl2+FRxu7diXdBr5m8TIYs=";
      };
      # cmakeFlags = old.cmakeFlags ++ [
      #   (lib.cmakeBool "XRT_HAVE_OPENCV" false)
      # ];
      # nativeBuildInputs = old.nativeBuildInputs ++ [
      #   final.opencv4
      # ];
      patches = (old.patches or []) ++ [
        # ./patches/monado/2253.patch # solarxr
        # ./patches/monado/2426.patch # index brightness
        # ./patches/monado/2522.patch # regession fix for 2509
        # ./patches/monado/up_client_max.patch
        ./patches/monado/2685.patch
      ];
    });
    monado_multiarch_oot = outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.monado_multiarch.override {
      # multiarchOverrideAttrs = {
      #   version = final.monado_patched.version;
      #   __intentionallyOverridingVersion = true;
      #   src = final.monado_patched.src;
      #   patches = final.monado_patched.patches;
      # };
    };

    wlx-overlay-s_patched = final.wlx-overlay-s.overrideAttrs rec {
      src = pkgs.fetchgit {
        url = "https://github.com/galister/wlx-overlay-s.git";
        fetchSubmodules = false;
        deepClone = false;
        leaveDotGit = false;
        sparseCheckout = [ ];
        rev = "3ed4313a3617b4a7f9632828b697abeffdf5b060";
        sha256 = "sha256-46sX8BzbNui8RN9E2GAB3h36bzOkPTFaw64t/Tv6XrY=";
      };
      cargoHash = "";
      postPatch = "";
    };

    wlx-overlay-s_patched2 = outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.wlx-overlay-s.overrideAttrs rec {
      src = pkgs.fetchgit {
        url = "https://github.com/galister/wlx-overlay-s.git";
        fetchSubmodules = false;
        deepClone = false;
        leaveDotGit = false;
        sparseCheckout = [ ];
        rev = "3ed4313a3617b4a7f9632828b697abeffdf5b060";
        sha256 = "sha256-46sX8BzbNui8RN9E2GAB3h36bzOkPTFaw64t/Tv6XrY=";
      };
      cargoHash = "";
      postPatch = "";
    };

    xrizer-patched = final.xrizer.overrideAttrs (old : {
      version = old.version+"1337";
      src = pkgs.fetchgit {
        url = "https://github.com/ImSapphire/xrizer.git";
        fetchSubmodules = false;
        deepClone = false;
        leaveDotGit = false;
        sparseCheckout = [ ];
        rev = "0046aae8bab66a6a7ad69d5dac481ea294e0a803";
        sha256 = "sha256-NnNYzoekeZeNQVoy8phcnWkyORFvxizDVkWGArg316g=";
      };
      patches = (old.patches or []) ++ [
        # ./patching/patches/xrizer/68.patch
        # ./patching/patches/xrizer/69.patch
        # ./patching/patches/xrizer/82.patch
        # ./patching/patches/xrizer/funny_serial_numbers.patch
        # ./patching/patches/xrizer/rin_experimental2_funny_serials.patch
      ];
      doCheck = false;
      # target = "i686-unknown-linux-gnu";
      # target = "x86_64-unknown-linux-gnu";
    });

    xrizer-patched2 = outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.xrizer.overrideAttrs rec {
      nativeBuildInputs = with pkgs; [
        inputs.fenix.packages.${pkgs.stdenv.hostPlatform.system}.default.toolchain
      ] ++ outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.xrizer.nativeBuildInputs;
      patches = [
      ] ++ outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.xrizer.patches;
      doCheck = false;
    };

    xrizer_multiarch_oot = outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.xrizer_multiarch.override {
      multiarchOverrideAttrs = {
        version = final.xrizer-patched.version;
        __intentionallyOverridingVersion = true;
        src = final.xrizer-patched.src;
        # cmakeFlags = old.cmakeFlags ++ [
        #   (lib.cmakeBool "XRT_HAVE_OPENCV" false)
        # ];
        # nativeBuildInputs = old.nativeBuildInputs ++ [
        #   final.opencv4
        # ];
        patches = final.xrizer-patched.patches;
      };
    };

    go-bsb-cams = outoftree.pkgs.${pkgs.stdenv.hostPlatform.system}.go-bsb-cams.overrideAttrs (old : {
      version = old.version+"1337";
      __intentionallyOverridingVersion = true;
      src = pkgs.fetchFromGitHub {
        owner = "Red-M";
        repo = "go-bsb-cams";
        rev = "8a2728ccf20d1a1a2a51c9ad9ebf364aa18e78cb";
        sha256 = "sha256-iExK4l0eHX2Lm27vs84NDuHEoA50t7NB8aRE9kyidtk=";
      };
      vendorHash = "sha256-qFe8doA3L/77XsmIhZsqsjlCFxmlsZfvqwTPtBHgOHA=";
    });
  })];

}

