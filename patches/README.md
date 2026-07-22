# Patches

Project-specific patch files belong in subdirectories here.

Patch lists are wired through `nix/patches.nix`. The flake applies them to source derivations used by Nix packages and by the dev source symlinks consumed by Bazel and Buck2.
