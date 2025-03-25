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
  version = "0.2.5";
  src = fetchFromGitHub rec {
    owner = "olekolek1000";
    repo = "${pname}";
    rev = "125900a3ca55a645ca297a216e52102452604cf9";
    hash = "sha256-5313JDxAVGamgNYpgnGY7Q4M9VMSQYqKP9wjWg02D8Q=";
  };
  sourceRoot = "${src.name}/src-tauri";

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "libmonado-1.3.1" = "sha256-HYYfpYhyo5VmbUdwMTJuAR+2dnMITIGZIPGX9Qsnc/g=";
      "keyvalues-parser-0.2.0" = "sha256-LT+WHhan/USzW0EOiuIBPG5j1r9qL4n7Z7ESDxO1xQQ=";
      "wayvr_ipc-0.1.0" = "sha256-ieQaY08Ogl/F3t/p825LBp1lAO3SWH1F8206IPXEgTc=";
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

