{
  stdenv,
  lib,
  fetchFromGitHub,
  symlinkJoin,
  writeTextFile,
  bash,
  lovr,

}:

symlinkJoin rec {
  pname = "lovr-playspace";
  version = "0.1.0";
  paths = [
    lovr
    (stdenv.mkDerivation {
      pname = "${pname}-unwrapped";
      version = "${version}";
      src = fetchFromGitHub {
        name = pname;
        owner = "SpookySkeletons";
        repo = pname;
        tag = "${version}";
        fetchSubmodules = true;
        hash = "sha256-nW4hyEf35NlfqljKKy47NC2pr3EuCKb4HbsFh8+CGRQ=";
      };

      dontUseCmakeConfigure = true;

      installPhase = ''
        runHook preInstall
        mkdir -p $out/lovr-playspace $out/lovr-playspace/json
        cp -r ./*.lua $out/lovr-playspace/
        cp -r ./json/*.lua $out/lovr-playspace/json/
        runHook postInstall
      '';
    })
    (writeTextFile {
      name = "lovr-playspace-script";
      executable = true;
      destination = "/bin/lovr-playspace";
      text = ''
        #!${bash}/bin/bash
        ${lovr}/bin/lovr ${builtins.elemAt paths 1}/lovr-playspace
      '';
    })
  ];
}

