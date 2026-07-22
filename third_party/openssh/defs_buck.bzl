load(
    ":defs_shared.bzl",
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
]

OPENSSH_LINKER_FLAGS = [OPENSSH_DARWIN_MIN_OS_FLAG]

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
