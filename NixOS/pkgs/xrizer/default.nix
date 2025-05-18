{
  fetchFromGitHub,
  lib,
  libxkbcommon,
  nix-update-script,
  openxr-loader,
  pkg-config,
  rustPlatform,
  shaderc,
  vulkan-loader,
}:
rustPlatform.buildRustPackage rec {
  pname = "xrizer";
  version = "775e4e08602e97e3ae514f401e2ab52896544db0";

  src = fetchFromGitHub {
    owner = "RinLovesYou";
    repo = "xrizer";
    rev = version;
    hash = "sha256-AzW1a1795eaSrIBd7Q/q7hS67lrxtovYSAJ4Ngds5+o=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-87JcULH1tAA487VwKVBmXhYTXCdMoYM3gOQTkM53ehE=";

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
  '';

  postInstall = ''
    mkdir -p $out/lib/xrizer/bin/linux64
    ln -s "$out/lib/libxrizer.so" "$out/lib/xrizer/bin/linux64/vrclient.so"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "XR-ize your favorite OpenVR games";
    homepage = "https://github.com/Supreeeme/xrizer";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Scrumplex ];
    # TODO: support more systems
    # To do so, we need to map systems to the format openvr expects.
    # i.e. x86_64-linux -> linux64, aarch64-linux -> linuxarm64
    platforms = [ "x86_64-linux" ];
  };
}
