{
  lib,
  stdenv,
  fetchgit,
  nix-update-script,
  libxkbcommon,
  openxr-loader,
  pkg-config,
  rustPlatform,
  shaderc,
  vulkan-loader,
  libGL,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xrizer";
  version = "fc9b0cc2a1047adc9b7edffd68fa0c288965090a";
  src = fetchgit {
    url = "https://github.com/Supreeeme/xrizer.git";
    fetchSubmodules = false;
    deepClone = false;
    leaveDotGit = false;
    sparseCheckout = [ ];
    rev = finalAttrs.version;
    sha256 = "sha256-gBHMIocIIa5u2kJyxZ+h0xgoY3MRERHYpoQ+E82EEBU=";
  };

  cargoHash = "sha256-QPS5r4r8el2Rm0VVeuy6gtcQFpDmAqzf70+Ww2pXeoA=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    shaderc
  ];

  buildInputs = [
    libxkbcommon
    vulkan-loader
    openxr-loader
  ];

  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail 'features = ["static"]' 'features = ["linked"]'
    substituteInPlace src/graphics_backends/gl.rs \
      --replace-fail 'libGLX.so.0' '${lib.getLib libGL}/lib/libGLX.so.0'
  '';

  platformPath =
    {
      "aarch64-linux" = "bin/linuxarm64";
      "i686-linux" = "bin";
      "x86_64-linux" = "bin/linux64";
    }
    ."${stdenv.hostPlatform.system}";

  postInstall = ''
    mkdir -p $out/lib/xrizer/$platformPath
    mv "$out/lib/libxrizer.so" "$out/lib/xrizer/$platformPath/vrclient.so"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "XR-ize your favorite OpenVR games";
    homepage = "https://github.com/Supreeeme/xrizer";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Scrumplex ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
      "aarch64-linux"
    ];
  };
})
