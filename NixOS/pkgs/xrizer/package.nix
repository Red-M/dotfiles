{
  lib,
  stdenv,
  fetchFromGitHub,
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
  version = "01ab72809f2bd5c6494fa77fb08e4229c886da7a";
  src = fetchFromGitHub {
    owner = "Supreeeme";
    repo = "xrizer";
    rev = finalAttrs.version;
    sha256 = "sha256-IRhLWlGHywp0kZe5aGmMHAF1zZwva3sGg68eG1E2K9A=";
  };

  cargoHash = "sha256-orfK5pwWv91hA7Ra3Kk+isFTR+qMHSZ0EYZTVbf0fO0=";

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
