{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchNpmDeps,
  rustPlatform,
  buildNpmPackage,
  npmHooks,
  wrapGAppsHook4,
  autoPatchelfHook,
  nodejs,
  rustc,
  cargo,
  cargo-tauri,
  pkg-config,
  openssl,
  alsa-lib,
  gdk-pixbuf,
  atk,
  cairo,
  pango,
  glib-networking,
  webkitgtk_4_1,

}:

rustPlatform.buildRustPackage rec {
  pname = "Resolute";
  version = "0.8.3";
  src = fetchFromGitHub rec {
    owner = "Gawdl3y";
    repo = "${pname}";
    rev = "ac79045d50581832323adadded9d2d1f90e19419";
    hash = "sha256-OdWdHFwmLSnELz0xn5goqKbMBAwTb4bwkV0jWlxtlm8=";
  };
  # sourceRoot = "${src.name}/src-tauri";

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
    };
  };
  useFetchCargoVendor = true;

  frontend = buildNpmPackage {
		inherit version src;
		pname = "Resolute-ui";

		npmDepsHash = "sha256-X+mTF7Fc4FL/Nyt8ejvsWLwmNWIDXyYKCg00mdyEWhA=";

		nativeBuildInputs = [
			autoPatchelfHook
		];

		dontAutoPatchelf = true;

		preBuild = ''
			autoPatchelf node_modules/sass-embedded-linux-x64/dart-sass/src/dart
		'';

		postBuild = ''
			cp -r ./ui/dist/ $out
		'';
	};

	postPatch = ''
		substituteInPlace crates/tauri-app/tauri.conf.json \
			--replace-warn '"frontendDist": "../../ui/dist"' '"frontendDist": "${frontend}"'
		substituteInPlace crates/tauri-app/tauri.conf.json \
			--replace-warn '"npm run build"' '""'
	'';

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    wrapGAppsHook4
    pkg-config
  ];

  buildInputs = [
    openssl
    alsa-lib

    gdk-pixbuf
    atk
    cairo
    pango
    glib-networking
    webkitgtk_4_1
  ];
  # cargoRoot = "src-tauri";
  # buildAndTestSubdir = cargoRoot;

}

