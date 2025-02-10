{ lib
, stdenv
, fetchurl
, cmake
, pkg-config
, icu
, openssl
, withArgon2 ? true, libargon2
, withI18N ?  true, boost, gettext
, withPerl ? false, perl
, withPython ? false, python3
, withTcl ? false, tcl
, withCyrus ? true, cyrus_sasl
, withZlib ? true, zlib
, withIPv6 ? true
}:

let
  inherit (lib)
    cmakeBool
  ;
in

stdenv.mkDerivation rec {
  pname = "znc";
  version = "1.9.1";

  src = fetchurl {
    url = "https://znc.in/releases/archive/${pname}-${version}.tar.gz";
    sha256 = "sha256-6KfPgOGarVELTigur2G1a8MN+I6i4PZPrc3TA8SJTzw=";
  };

  patches = [
    ./module_builds.patch
  ];

  postPatch = ''
    substituteInPlace znc.pc.cmake.in \
      --replace-fail '$'{exec_prefix}/@CMAKE_INSTALL_BINDIR@ @CMAKE_INSTALL_FULL_BINDIR@ \
      --replace-fail '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace-fail '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
    substituteInPlace znc-buildmod-old.cmake.in \
      --replace-fail '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@ \
      --replace-fail @prefix@ $out \
      --replace-fail @openssl@ ${openssl} \
      --replace-fail @icu@ ${icu}
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    icu
    openssl
  ] ++ lib.optional withArgon2 libargon2
    ++ lib.optionals withI18N [ boost gettext ]
    ++ lib.optional withPerl perl
    ++ lib.optional withPython python3
    ++ lib.optional withTcl tcl
    ++ lib.optional withCyrus cyrus_sasl
    ++ lib.optional withZlib zlib;

  cmakeFlags = [
    (cmakeBool "WANT_ARGON" withArgon2)
    (cmakeBool "WANT_I18N" withI18N)
    (cmakeBool "WANT_PERL" withPerl)
    (cmakeBool "WANT_PYTHON" withPython)
    (cmakeBool "WANT_TCL" withTcl)
    (cmakeBool "WANT_CYRUS" withCyrus)
    (cmakeBool "WANT_ZLIB" withZlib)
    (cmakeBool "WANT_IPV6" withIPv6)
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    changelog = "https://github.com/znc/znc/blob/znc-${version}/ChangeLog.md";
    description = "Advanced IRC bouncer";
    homepage = "https://wiki.znc.in/ZNC";
    maintainers = with maintainers; [ schneefux lnl7 ];
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}

