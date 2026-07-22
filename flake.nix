{
  description = "Forge for SSH-related third-party tooling via Nix, Bazel, and Buck2";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    openssh-src = {
      url = "https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-10.4p1.tar.gz";
      flake = false;
    };
    libssh2-src = {
      url = "https://libssh2.org/download/libssh2-1.11.1.tar.gz";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      openssh-src,
      libssh2-src,
      ...
    }:
    let
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];

      eachSystem = f:
        builtins.listToAttrs (
          map (system: {
            name = system;
            value = f system;
          }) systems
        );

      mkSystem =
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          mkOpenSsh =
            withTests:
            pkgs.callPackage ./third_party/openssh {
              src = openssh-src;
              inherit withTests;
            };

          openssh = mkOpenSsh false;
          openssh-tests = mkOpenSsh true;
          opensshSource = openssh.passthru.patchedSource;

          mkLibssh2 =
            withTests:
            pkgs.callPackage ./third_party/libssh2 (
              {
                src = libssh2-src;
                inherit withTests;
              }
              // pkgs.lib.optionalAttrs withTests {
                testOpenSsh = openssh;
              }
            );

          libssh2 = mkLibssh2 false;
          libssh2-tests = mkLibssh2 true;
          libssh2Source = libssh2.passthru.patchedSource;

          opensslRoot = pkgs.symlinkJoin {
            name = "openssl-root";
            paths = [
              pkgs.openssl.dev
              pkgs.openssl.out
            ];
          };
          zlibRoot = pkgs.symlinkJoin {
            name = "zlib-root";
            paths = [
              pkgs.zlib.dev
              pkgs.zlib.out
            ];
          };
          libxcryptRoot = pkgs.symlinkJoin {
            name = "libxcrypt-root";
            paths = [ pkgs.libxcrypt ];
          };
          darwinLibresolvRoot =
            if pkgs.stdenv.hostPlatform.isDarwin then
              pkgs.symlinkJoin {
                name = "libresolv-root";
                paths = [
                  pkgs.darwin.libresolv.dev
                  pkgs.darwin.libresolv.out
                ];
              }
            else
              "";
        in
        {
          packages = {
            inherit openssh libssh2;
          };

          checks = {
            inherit openssh-tests libssh2-tests;
          };

          devShells.default = pkgs.mkShell {
            packages = [
              pkgs.bazel_7.passthru.bazelBootstrap
              pkgs.buck2
              pkgs.pkg-config
              pkgs.gnumake
              pkgs.autoconf
              pkgs.automake
              pkgs.m4
              pkgs.cmake
              pkgs.ninja
              pkgs.perl
              pkgs.openssl
              pkgs.zlib
              pkgs.patch
              pkgs.which
              pkgs.coreutils
              pkgs.findutils
              pkgs.gnused
              pkgs.gnugrep
              pkgs.gawk
              pkgs.gnutar
              pkgs.gzip
              pkgs.unzip
              openssh
            ];

            shellHook = ''
              export OPENSSL_ROOT=${opensslRoot}
              export ZLIB_ROOT=${zlibRoot}
              export LIBXCRYPT_ROOT=${libxcryptRoot}
              export DARWIN_LIBRESOLV_ROOT=${darwinLibresolvRoot}
              export PKG_CONFIG_PATH=${pkgs.openssl.dev}/lib/pkgconfig:${pkgs.zlib.dev}/lib/pkgconfig''${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}
              export BAZEL_OUTPUT_USER_ROOT="$PWD/.cache/bazel-output"
              export TEST_TMPDIR="$PWD/.cache/bazel-test-tmp"
              export BUCK2_TEST_DEFAULT_TIMEOUT=600

              link_dev_input() {
                target="$1"
                source="$2"

                if [ -L "$target" ]; then
                  if [ "$(readlink "$target" 2>/dev/null || true)" != "$source" ]; then
                    ln -sfn "$source" "$target"
                  fi
                elif [ ! -e "$target" ]; then
                  ln -s "$source" "$target"
                fi
              }

              if [ -d third_party/openssh ] && [ -d third_party/libssh2 ]; then
                mkdir -p third_party/nixpkgs
                link_dev_input third_party/openssh/src ${opensshSource}
                link_dev_input third_party/libssh2/src ${libssh2Source}
                link_dev_input third_party/nixpkgs/openssl ${opensslRoot}
                link_dev_input third_party/nixpkgs/zlib ${zlibRoot}
                link_dev_input third_party/nixpkgs/libxcrypt ${libxcryptRoot}
                if [ -n "${darwinLibresolvRoot}" ]; then
                  link_dev_input third_party/nixpkgs/darwin-libresolv ${darwinLibresolvRoot}
                fi
              fi
            '';
          };
        };

      bySystem = eachSystem mkSystem;
    in
    {
      packages = eachSystem (system: bySystem.${system}.packages);
      checks = eachSystem (system: bySystem.${system}.checks);
      devShells = eachSystem (system: bySystem.${system}.devShells);
    };
}
