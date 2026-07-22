{
  lib,
  stdenv,
  src,
  pkg-config,
  openssl,
  zlib,
  testOpenSsh ? null,
  patches ? [ ],
  withTests ? false,
}:

assert !withTests || testOpenSsh != null;

stdenv.mkDerivation (finalAttrs: {
  pname = "libssh2" + lib.optionalString withTests "-tests";
  version = "1.11.1";

  inherit src patches;

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
  ] ++ lib.optional withTests testOpenSsh;

  buildInputs = [
    openssl
    zlib
  ];

  configureFlags = [
    "--with-crypto=openssl"
    "--with-libz"
    "--disable-docker-tests"
    "--disable-examples-build"
    "--disable-docs"
  ];

  enableParallelBuilding = true;

  doCheck = withTests;
  enableParallelChecking = false;
  checkTarget = "check";
  preCheck = ''
    export USER="$(id -un)"
    export LOGNAME="$USER"
  '';

  meta = {
    description = "Client-side C library implementing the SSH2 protocol";
    homepage = "https://libssh2.org/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
})
