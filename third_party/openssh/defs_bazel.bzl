load("@ssh_build//third_party/openssh:defs_shared.bzl", "OPENSSH_COMMON_COPTS")

def openssh_binary(name, srcs, deps = [":openssh_core"]):
    native.cc_binary(
        name = name,
        srcs = srcs,
        copts = OPENSSH_COMMON_COPTS,
        deps = deps,
    )
