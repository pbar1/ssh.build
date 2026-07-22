{
  lib,
  stdenv,
  applyPatches,
  src,
  pkg-config,
  openssl,
  zlib,
  testOpenSsh ? null,
  patches ? [ ],
  withTests ? false,
}:

assert !withTests || testOpenSsh != null;

let
  version = "1.11.1";
  patchedSource =
    if patches == [ ] then
      src
    else
      applyPatches {
        name = "libssh2-${version}-patched-source";
        inherit src patches;
      };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "libssh2" + lib.optionalString withTests "-tests";
  inherit version;

  src = patchedSource;

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

  passthru = {
    inherit patchedSource patches;
  };
})
