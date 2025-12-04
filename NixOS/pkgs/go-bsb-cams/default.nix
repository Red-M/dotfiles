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
    owner = "Banakin";
    repo = "go-bsb-cams-fast";
    rev = "153c0d0e1ccc859a563a01a233a0fb5147b9301c";
    hash = "sha256-YfVFH19B/EeSnyDL9vbEJCkZB+YTaddrdt9eViOpyCY=";
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
