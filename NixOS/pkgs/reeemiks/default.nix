{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libudev-zero,

}:

buildGoModule rec {
  name = "reeemiks";
  src = fetchFromGitHub {
    owner = "Red-M";
    repo = "ReeeMiks";
    rev = "78467ef2b5697fc9e1e3de2faed43a1745e50f80";
    hash = "sha256-cTefDOwpaMY9VKZTUM9MP1d7rZyo4ZAAk1e2X/V12wc=";
  };
  version = "${src.rev}";

  patches = [
  ];

  vendorHash = "sha256-9Mu70E+x4vpsV7srClJhdMtes7imJ+ENZRTJLRENtIw=";
  proxyVendor = true;
  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
    "-X main.Commit=${version}"
    "-X main.gitCommit=${version}"
    "-X main.versionTag=${version}"
    "-X main.buildType=release"
  ];

  buildInputs = [ libudev-zero ];
  subPackages = [ "pkg/reeemiks/cmd" ];
  installPhase = ''
    install -Dm755 $GOPATH/bin/cmd $out/bin/reeemiks
  '';

}
