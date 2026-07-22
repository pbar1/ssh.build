def openssh_binary(name, srcs, copts, deps):
    native.cc_binary(
        name = name,
        srcs = srcs,
        copts = copts,
        linkopts = ["-lsandbox"],
        deps = deps,
    )
