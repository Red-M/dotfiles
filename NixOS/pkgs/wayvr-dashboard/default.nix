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
  pname = "wayvr-dashboard";
  version = "0.2.1";
  src = fetchFromGitHub rec {
    owner = "olekolek1000";
    repo = "${pname}";
    rev = "9246f42ddb00301fbc46d3c2999736894b2ae615";
    hash = "sha256-EPpa6uJcim0DfgucxXEEQjqVyFDQUeoKZMsz7X6as0g=";
  };
  sourceRoot = "${src.name}/src-tauri";

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "keyvalues-parser-0.2.0" = "sha256-zbpgA6q2mIfFN6RoM0tauIQQFWT091TZ+6CCnBcYLa0=";
      "wayvr_ipc-0.1.0" = "sha256-o224e306Y0Rlmkci/jBQwCNsgeI7jlOpRkLuVveQP2E=";
    };
  };
  useFetchCargoVendor = true;

  frontend = buildNpmPackage {
		inherit version src;
		pname = "wayvr-dashboard-ui";

		npmDepsHash = "sha256-W2X9g0LFIgkLbZBdr4OqodeN7U/h3nVfl3mKV9dsZTg=";

		nativeBuildInputs = [
			autoPatchelfHook
		];

		dontAutoPatchelf = true;

		preBuild = ''
			autoPatchelf node_modules/sass-embedded-linux-x64/dart-sass/src/dart
		'';

		postBuild = ''
			cp -r dist/ $out
		'';
	};

	postPatch = ''
		substituteInPlace tauri.conf.json \
			--replace-warn '"frontendDist": "../dist"' '"frontendDist": "${frontend}"'
		substituteInPlace tauri.conf.json \
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

