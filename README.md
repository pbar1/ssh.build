# ssh.build

Forge for building SSH-related third-party projects with Nix, Bazel, and Buck2.

Initial projects:

- OpenSSH portable 10.4p1
- libssh2 1.11.1

Upstream sources are pinned as flake inputs and are not vendored in this repository.

## Commands

```sh
nix develop
nix build .#openssh
nix build .#libssh2
nix flake check
nix develop -c bazel build //third_party/...
nix develop -c bazel test //third_party/...
nix develop -c buck2 build //third_party/...
nix develop -c buck2 test //third_party/...
```

Docker-backed upstream tests are intentionally out of scope.
