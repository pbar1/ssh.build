# Agent Guidelines

## Repository Scope

This repo builds SSH-related third-party projects with Nix, Bazel, and Buck2.

Current upstream projects:
- OpenSSH portable 10.4p1
- libssh2 1.11.1

Upstream source archives are pinned as flake inputs. Do not vendor upstream source trees into this repository.

## Source Control

This repo uses Jujutsu. Use `jj`, not `git`, for source-control inspection.

Preferred status command:

```sh
jj --config signing.behavior=drop status
```

Do not revert or modify unrelated user changes.

## Development Environment

Run build tools through Nix from the repo root.

Use:

```sh
nix develop path:. -c bazel build //third_party/...
nix develop path:. -c buck2 build //third_party/...
```

Do not rely on globally installed `bazel`, `buck2`, compilers, or package-manager tools. Do not use `--impure` unless explicitly requested.

## Generated Source Views

`nix develop path:.` prepares ignored symlink views:

- `third_party/openssh/src`
- `third_party/libssh2/src`
- `third_party/nixpkgs/openssl`
- `third_party/nixpkgs/zlib`
- `third_party/nixpkgs/libxcrypt`
- `third_party/nixpkgs/darwin-libresolv`

Treat these as generated inputs. Do not edit files under `third_party/openssh/src` or `third_party/libssh2/src`; edit checked-in patches, config, or build files instead.

## Patches

Keep patch ownership local to each third-party project:

- OpenSSH patches: `third_party/openssh/patches/`
- libssh2 patches: `third_party/libssh2/patches/`

When adding or removing a patch:
- update the corresponding `default.nix`
- update the patch directory `README.md`
- keep patch order explicit and dependency-aware
- prefer small protocol/debug patches over broad vendor imports

## Build-System Rules

Keep Nix, Bazel, and Buck2 source views consistent. If a dependency or source list changes, update all affected build systems.

Do not use Bazel or Buck genrules to compile upstream projects. Prefer native `cc_library` / `cc_binary` or `cxx_library` / `cxx_binary` graphs.

Do not add stubs for upstream functionality unless explicitly requested.

## Verification

For broad verification, run:

```sh
nix flake check path:. --no-build
nix build path:.#openssh --no-link
nix build path:.#libssh2 --no-link
nix develop path:. -c bazel build //third_party/...
nix develop path:. -c buck2 build //third_party/...
```

For libssh2 tests:

```sh
nix build path:.#checks.aarch64-darwin.libssh2-tests --no-link
nix develop path:. -c bazel test //third_party/libssh2/...
nix develop path:. -c buck2 test //third_party/libssh2/...
```

OpenSSH currently has build targets but no Bazel test targets. Use Bazel/Buck build verification for OpenSSH unless tests are added.

Docker-backed upstream tests are intentionally out of scope.

## OpenSSH Protocol Lab Notes

This repo intentionally carries OpenSSH protocol-debugging patches such as exposing `none` cipher/MAC behavior. Do not remove or secure-by-default these patches unless requested.

Useful checks:

```sh
nix run path:.#openssh -- -Q cipher
nix run path:.#openssh -- -Q mac
nix develop path:. -c bazel run //third_party/openssh:ssh -- -Q cipher
nix develop path:. -c bazel run //third_party/openssh:ssh -- -Q mac
nix develop path:. -c buck2 run //third_party/openssh:ssh -- -Q cipher
nix develop path:. -c buck2 run //third_party/openssh:ssh -- -Q mac
```

## Style

Make the smallest correct change. Avoid speculative abstractions. Keep checked-in files ASCII unless the file already requires otherwise.
