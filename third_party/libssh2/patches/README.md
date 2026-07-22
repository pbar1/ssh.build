# libssh2 Patches

Patches are from Debian `libssh2` `1.11.1-4`, excluding Debian-specific packaging patches. They are applied in dependency-aware order; Debian lists `libssh-unconst-backport.patch` last, but it is applied before `CVE-2025-15661.patch` here because that fix uses `LIBSSH2_UNCONST`.

- `cve-2026-7598.patch`: bounds checks for `username_len` in `userauth.c`.
- `libssh-unconst-backport.patch`: backports `LIBSSH2_UNCONST`, required by `CVE-2025-15661.patch`.
- `CVE-2025-15661.patch`: bounds-safe malformed SFTP symlink packet handling.
- `CVE-2026-55199.patch`: checks `_libssh2_get_string()` results in the `EXT_INFO` handler.
- `CVE-2026-55200.patch`: additional transport packet length boundary checks.

Not applied: Debian's `0001-Add-lgpg-error-to-.pc-to-facilitate-static-linking.patch`, which Debian marks `Forwarded: not-needed` and describes as Debian-specific.
