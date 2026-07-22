# libssh2

libssh2 1.11.1 is pinned as a flake input. The upstream source is not vendored; `nix develop` prepares the ignored `third_party/libssh2/src` source view used by Bazel and Buck2.

## Build

Run commands from the repository root.

### Nix

```sh
nix build path:.#libssh2
```

### Bazel

```sh
nix develop path:. -c bazel build //third_party/libssh2:libssh2
```

### Buck2

```sh
nix develop path:. -c buck2 build //third_party/libssh2:libssh2
```
