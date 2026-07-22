{
  lib,
  stdenv,
  applyPatches,
  src,
  pkg-config,
  openssl,
  zlib,
  mandoc,
  patches ? [
    ./patches/enable-none-cipher.patch
    ./patches/enable-none-mac.patch
  ],
  withTests ? false,
}:

let
  version = "10.4p1";
  patchedSource =
    if patches == [ ] then
      src
    else
      applyPatches {
        name = "openssh-${version}-patched-source";
        inherit src patches;
      };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "openssh" + lib.optionalString withTests "-tests";
  inherit version;

  src = patchedSource;

  outputs = [
    "out"
    "man"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
  ] ++ lib.optional stdenv.hostPlatform.isDarwin mandoc;

  buildInputs = [
    openssl
    zlib
  ];

  postPatch = ''
    substituteInPlace Makefile.in \
      --replace-fail '$(INSTALL) -m 4711' '$(INSTALL) -m 0711'
  '';

  configureFlags = [
    "--sbindir=\${out}/bin"
    "--libexecdir=\${out}/libexec"
    "--sysconfdir=\${out}/etc/ssh"
    "--with-pid-dir=/run"
    "--with-ssl-dir=${lib.getDev openssl}"
    "--with-zlib=${lib.getDev zlib}"
    "--without-pam"
    "--with-sandbox=no"
    "--disable-security-key"
    "--disable-strip"
    "--without-rpath"
  ];

  enableParallelBuilding = true;

  doCheck = withTests;
  enableParallelChecking = false;
  checkTarget = "tests";

  preCheck = ''
    export TEST_SSH_PORT=4242
    export TEST_SSH_UNSAFE_PERMISSIONS=1
  '';

  installTargets = [ "install-nokeys" ];

  postInstall = ''
    cp contrib/ssh-copy-id $out/bin/
    chmod +x $out/bin/ssh-copy-id
    cp contrib/ssh-copy-id.1 $man/share/man/man1/
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/ssh -V 2>&1 | grep 'OpenSSH_${finalAttrs.version}'
    $out/bin/sshd -V 2>&1 | grep 'OpenSSH_${finalAttrs.version}'
    runHook postInstallCheck
  '';

  meta = {
    description = "OpenBSD SSH client and server";
    homepage = "https://www.openssh.com/";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    mainProgram = "ssh";
  };

  passthru = {
    inherit patchedSource patches;
  };
})
