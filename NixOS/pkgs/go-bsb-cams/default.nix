{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  libusb1,

}:

buildGoModule rec {
  name = "go-bsb-cams";
  src = fetchFromGitHub {
    owner = "LilliaElaine";
    repo = "go-bsb-cams";
    rev = "4c2912ce1d77ba8739f86708966794f2c57912f9";
    hash = "sha256-/ce9ye+lVd20UB9l0w7jIx/kEYf48GG6Y+oHin/iY9w=";
  };
  version = "${src.rev}";

  patches = [
  ];

  vendorHash = "sha256-U5B8QJRLSb4S1N0veMPodWfxRZuk/RkCjSd/RAzow78=";
  # proxyVendor = true;
  ldflags = [
    "-s"
    "-w"
    "-X main.gitVersion=${version}"
  ];

  buildInputs = [ libusb1 ];
  nativeBuildInputs = [ pkg-config ];
  installPhase = ''
    install -Dm755 $GOPATH/bin/go-bsb-cams $out/bin/go-bsb-cams
  '';

}
