# OpenSSH

OpenSSH portable 10.4p1 is pinned as a flake input. The upstream source is not vendored; `nix develop` prepares the ignored `third_party/openssh/src` source view used by Bazel and Buck2, including patches from `nix/patches.nix`.

## Build

Run commands from the repository root.

### Nix

```sh
nix build path:.#openssh
```

### Bazel

```sh
nix develop path:. -c bazel build //third_party/openssh:openssh
```

### Buck2

```sh
nix develop path:. -c buck2 build //third_party/openssh:openssh
```

## Run

Run commands from the repository root.

### Nix

```sh
nix run path:.#openssh -- -Q cipher
```

### Bazel

```sh
nix develop path:. -c bazel run //third_party/openssh:ssh -- -Q cipher
```

### Buck2

```sh
nix develop path:. -c buck2 run //third_party/openssh:ssh -- -Q cipher
```
