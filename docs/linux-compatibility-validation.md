# Linux compatibility validation

Validated on 2026-09-07 on `feat/linux-compatibility-completion`.
Implementation commit: `e8db4f6`. Package: `vortex-linux 2.6.3-3`.
Upstream: `aa459b9499224bde07e5119d715b463bfae92c5e`.

| Check | Result |
| --- | --- |
| Patch application to clean upstream source | All 26 patches applied |
| Compatibility suite | 743 tests passed |
| Full renderer suite | 1943 passed, 9 skipped |
| Production build | Build, lint and typechecking passed for 152 projects and their dependencies |
| Native LOOT | Sorting, metadata, casing, ghost plugins and worker shutdown passed |
| AppImage version mismatch | A package whose application reported 2.6.2 was rejected as expected |
| Arch package | Built in an Arch container with `makepkg --cleanbuild`; revision 2.6.3-3 |
| AppImage | Built from that package; embedded application version is 2.6.3 |
| Clean Ubuntu 24.04 | Packaged fixtures and rendered main page passed without system .NET |
| Artifact checksums | Both SHA-256 files verified |

The compatibility suite contains 118 renderer tests, 619 plugin-management tests,
4 archive tests and 2 unpacked-path tests. The renderer counts overlap with the
full renderer suite; they are not additional tests.

INI tests cover BOMs, encodings, case-insensitive names and hardlink preservation.
Prefix tests include creating a game's first configuration directory and keeping
Vortex's own data outside game prefixes. Tool tests execute fixture runners and
verify file paths, literal arguments, working directories and environments.

The Ubuntu test exercised the packaged INI/prefix/tool/Heroic/hardlink fixtures,
native LOOT and an XML FOMOD installation. Wine listed the bundled Windows .NET
6, 8 and 10 runtimes; the native probe found bundled Linux .NET 9.0.18. Vortex then
rendered its main page under Xvfb and remained running through the final check.

## Local artifacts

Files and verification logs are in `dist/linux-compatibility-completion/`.
They are build outputs, excluded from Git.

```text
40bc61ce275fcc1bf6ca2e3ca72a3173157dbe094fea222d76a2c56989f0df51  Vortex-2.6.3-x86_64.AppImage
720b89f781325df738eadd8d80372addfd23720953a5d471ac5cecfcffb3ad6a  vortex-linux-2.6.3-x86_64.pkg.tar.zst
```

## Manual checks still needed

Real game launches, Steam/Heroic authentication, Flatpak permissions, interactive
FOMOD choices and complete collection installs need representative installations.
BepInEx, script extenders and Witcher 3 Script Merger remain game-specific work.
The fixture results do not establish support for every game or extension.

No merge, push or release was performed.
