{
  fetchgit,
  lib,
  stdenv,
  cmake,
  vulkan-headers,
  vulkan-loader
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "monado-vulkan-layers";
  version = "ae43cdcbd25c56e3481bbc8a0ce2bfcebba9f7c2";
  src = fetchgit {
    url = "https://gitlab.freedesktop.org/monado/utilities/vulkan-layers.git";
    rev = "ae43cdcbd25c56e3481bbc8a0ce2bfcebba9f7c2";
    fetchSubmodules = false;
    deepClone = false;
    leaveDotGit = false;
    sparseCheckout = [ ];
    sha256 = "sha256-QabYVKcenW+LQ+QSjUoQOLOQAVHdjE0YXd+1WsdzNPc=";
  };

  patches = [
    ./absolute-layer-path.patch
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    vulkan-headers
    vulkan-loader
  ];

  meta = with lib; {
    description = "Vulkan Layers for Monado";
    homepage = "https://gitlab.freedesktop.org/monado/utilities/vulkan-layers";
    platforms = platforms.linux;
    license = licenses.boost;
    maintainers = with maintainers; [ scrumplex passivelemon ];
    sourceProvenance = with sourceTypes; [ fromSource ];
  };
})
