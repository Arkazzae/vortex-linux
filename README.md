# Vortex for Linux

[![Build status](https://github.com/Arkazzae/vortex-linux/actions/workflows/upstream-compatibility.yml/badge.svg)](https://github.com/Arkazzae/vortex-linux/actions/workflows/upstream-compatibility.yml)

Vortex is still a Windows-first application. This repository contains the
build recipe and patches needed to run it as a native Linux application. Ready
builds are available as an Arch package and as an AppImage for other x86_64
Linux distributions.

The Vortex source is fetched from the official Nexus Mods repository during the
build. It is not copied or maintained here. This is an independent community
project and is not an official Nexus Mods release.

## Download

Open the [latest release](https://github.com/Arkazzae/vortex-linux/releases/latest)
and download the format you need. Each file has a matching `.sha256` checksum.

### Arch Linux

Download the `.pkg.tar.zst` file and its checksum, then run:

```sh
sha256sum --check vortex-linux-*.pkg.tar.zst.sha256
sudo pacman -U ./vortex-linux-*.pkg.tar.zst
```

### Other distributions

Install Wine from your distribution's package manager. Download the AppImage
and its checksum, then run:

```sh
sha256sum --check Vortex-*.AppImage.sha256
chmod +x Vortex-*.AppImage
./Vortex-*.AppImage
```

The AppImage contains Vortex, the Linux .NET 9 runtime required by its startup
probe, and the Windows .NET runtimes used by modding tools. A system-wide .NET
installation is not required. Wine remains a system requirement. On a system
without FUSE 2, start it with:

```sh
./Vortex-*.AppImage --appimage-extract-and-run
```

AppImages do not register themselves in the application menu or as the handler
for `nxm://` links. AppImageLauncher can do that, or you can create a desktop
entry manually.

## What is fixed

The patches replace Windows-only path, filesystem and process handling with
Linux equivalents. Vortex can find Steam libraries and Proton prefixes, map
Documents and AppData to the correct prefix, launch games through Steam, run
Windows helper tools through Wine, and deploy or purge hardlinked mods without
leaving stale files behind.

The changes are shared Linux fixes, not a list of exceptions for individual
games. Game-specific Vortex extensions can still have their own Windows-only
assumptions, so not every one of the hundreds of supported games is guaranteed
to work.

## Before managing a game

Run the game once through Steam first. Proton and the game need that first run
to create their real configuration and save directories.

Hardlink deployment also requires the staging folder and the game to be on the
same filesystem. Vortex suggests a suitable folder in `Settings → Mods`. If an
old staging folder already contains mods, use Vortex's transfer flow instead of
moving or deleting it by hand.

Extra compatibility prefixes can be supplied as a colon-separated list in
`VORTEX_COMPAT_PREFIXES`. The default Wine prefix for helper tools is:

```text
${XDG_DATA_HOME:-$HOME/.local/share}/vortex-linux/wineprefix
```

## Build it yourself on Arch

```sh
git clone https://github.com/Arkazzae/vortex-linux.git
cd vortex-linux
makepkg -si
```

The build is pinned to an exact upstream Vortex commit. It downloads the
official source, Node dependencies, Electron and the required Microsoft runtime
files, so the first build is large.

## Compatibility checks

GitHub Actions applies every patch, runs the affected tests and typechecks the
renderer. A successful build from `master` produces both release formats and
publishes them together. A daily check also tests the latest upstream Vortex
release; it reports breakage but does not publish code that has not yet been
pinned in the build recipe.

Before publication, the AppImage is also started in a fresh Ubuntu container
that has Wine and the desktop libraries but no system .NET installation. Run
the same smoke test locally with Docker:

```sh
scripts/test-appimage.sh dist/Vortex-*.AppImage
```

To check a new upstream release locally:

```sh
scripts/check-upstream-compatibility.sh --ref latest --keep
```

Use `--ref pinned` to test the version currently listed in `PKGBUILD`.

## Reporting problems

Include the game, store, installation path, steps to reproduce and the relevant
part of `~/.config/Vortex/vortex.log`. Remove Nexus tokens and private download
links before posting a log.

## License

The build files and Linux patches in this repository are licensed under
GPL-3.0-only. Vortex itself remains under the upstream Nexus Mods license. See
[LICENSE](LICENSE).
