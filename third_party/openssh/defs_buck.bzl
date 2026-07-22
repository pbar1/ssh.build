load(
    ":defs_shared.bzl",
    "NIX_DARWIN_LIBRESOLV_DYLIB",
    "NIX_LIBXCRYPT_DYLIB",
    "NIX_OPENSSL_CRYPTO_DYLIB",
    "NIX_OPENSSL_SSL_DYLIB",
    "NIX_ZLIB_DYLIB",
    "OPENSSH_DARWIN_MIN_OS_FLAG",
    "OPENSSH_OPENSSL_API_DEFINE",
    "OPENSSH_UNGUARDED_AVAILABILITY_COPT",
)

OPENSSH_COMPILER_FLAGS = [
    OPENSSH_UNGUARDED_AVAILABILITY_COPT,
    "-Wno-undef-prefix",
    OPENSSH_DARWIN_MIN_OS_FLAG,
]

OPENSSH_PREPROCESSOR_FLAGS = [
    OPENSSH_OPENSSL_API_DEFINE,
    "-Ithird_party/openssh/config/darwin",
    "-Ithird_party/openssh/config/darwin/openbsd-compat/include",
    "-Ithird_party/openssh/src",
    "-Ithird_party/openssh/src/openbsd-compat",
    "-Ithird_party/nix/darwin-libresolv/include",
    "-Ithird_party/nix/libxcrypt/include",
    "-Ithird_party/nix/openssl/include",
    "-Ithird_party/nix/zlib/include",
]

OPENSSH_LINKER_FLAGS = [
    OPENSSH_DARWIN_MIN_OS_FLAG,
    NIX_DARWIN_LIBRESOLV_DYLIB,
    NIX_LIBXCRYPT_DYLIB,
    NIX_OPENSSL_CRYPTO_DYLIB,
    NIX_OPENSSL_SSL_DYLIB,
    NIX_ZLIB_DYLIB,
]

def openssh_srcs(srcs):
    return ["src/" + src for src in srcs]

def openssh_binary(name, srcs, deps = [":openssh_core"]):
    native.cxx_binary(
        name = name,
        srcs = openssh_srcs(srcs),
        compiler_flags = OPENSSH_COMPILER_FLAGS,
        deps = deps,
        preprocessor_flags = OPENSSH_PREPROCESSOR_FLAGS,
        visibility = ["PUBLIC"],
    )
