# Vortex for Linux

[![Build status](https://github.com/Arkazzae/vortex-linux/actions/workflows/upstream-compatibility.yml/badge.svg)](https://github.com/Arkazzae/vortex-linux/actions/workflows/upstream-compatibility.yml)

[Vortex](https://www.nexusmods.com/about/vortex/) is the mod manager from Nexus Mods — the one most people use for Skyrim, Fallout, Starfield, Baldur's Gate 3 and a few hundred other games. It's an Electron app, so it *technically* starts on Linux. Then it immediately falls apart: it can't find your Steam library, it writes saves and configs to the wrong place instead of into the Proton prefix, it can't launch the game, it can't run the Windows helper tools mods depend on, and hardlink deployment leaves junk behind when you purge.

The usual workaround is running Vortex itself inside a Wine prefix, which is slow, fragile and annoying to set up.

This repo does the other thing: it patches Vortex to actually understand Linux, and builds it as a native app.

## What it does

- Finds your Steam libraries and Proton prefixes
- Maps `Documents` / `AppData` into the right prefix, so mods and saves land where the game actually looks
- Launches games through Steam
- Runs Windows modding tools through Wine
- Deploys and purges hardlinked mods without leaving stale files behind

These are general Linux fixes, not per-game hacks. Game-specific Vortex extensions can still carry their own Windows-only assumptions, so not every supported game is guaranteed to work — but the base is sane now.

Nothing from Vortex is vendored here. The build pulls the official source from Nexus Mods and applies the patches on top. This is a community project, not an official Nexus Mods release.

## Install

Grab the [latest release](https://github.com/Arkazzae/vortex-linux/releases/latest). Every file ships with a `.sha256` next to it.

### Arch

```sh
sha256sum --check vortex-linux-*.pkg.tar.zst.sha256
sudo pacman -U ./vortex-linux-*.pkg.tar.zst
```

### Everything else (AppImage)

Install Wine from your package manager first, then:

```sh
sha256sum --check Vortex-*.AppImage.sha256
chmod +x Vortex-*.AppImage
./Vortex-*.AppImage
```

The AppImage bundles the Linux .NET 9 runtime Vortex probes for at startup, plus the Windows .NET runtimes modding tools need — you don't need .NET installed system-wide. Wine you do need.

No FUSE 2 on your system? Run it as:

```sh
./Vortex-*.AppImage --appimage-extract-and-run
```

AppImages don't add themselves to your app menu or register as the `nxm://` handler. AppImageLauncher handles that, or write a desktop entry yourself.

## Before you add your first game

**Launch the game once through Steam.** Proton and the game create their real config and save directories on that first run; if you point Vortex at a prefix that doesn't exist yet, nothing will line up.

**Keep staging and the game on the same filesystem.** Hardlinks can't cross filesystems. Vortex suggests a good folder under `Settings → Mods`. If you already have mods in an old staging folder, use Vortex's transfer flow — don't move or delete it by hand.

If you keep extra compatibility prefixes around, list them colon-separated in `VORTEX_COMPAT_PREFIXES`. The Wine prefix used for helper tools defaults to:

```text
${XDG_DATA_HOME:-$HOME/.local/share}/vortex-linux/wineprefix
```

## Building from source (Arch)

```sh
git clone https://github.com/Arkazzae/vortex-linux.git
cd vortex-linux
makepkg -si
```

The build is pinned to an exact upstream Vortex commit and downloads the source, Node dependencies, Electron and the Microsoft runtime files. First build is a big one.

## How it's tested

CI applies every patch, runs the affected tests and typechecks the renderer. Builds from `master` produce both release formats and publish them together. A daily job also tests the newest upstream Vortex release — it reports breakage, but won't publish anything that isn't pinned in the PKGBUILD yet.

Before release, the AppImage is booted in a clean Ubuntu container with Wine and the desktop libraries but no system .NET. You can run the same check locally:

```sh
scripts/test-appimage.sh dist/Vortex-*.AppImage
```

And test a new upstream release:

```sh
scripts/check-upstream-compatibility.sh --ref latest --keep
```

`--ref pinned` tests whatever version `PKGBUILD` currently points at.

## Something broken?

Open an issue with the game, the store, where it's installed, how to reproduce it, and the relevant chunk of `~/.config/Vortex/vortex.log`. Scrub your Nexus tokens and private download links out of the log first.

## License

The build files and Linux patches here are GPL-3.0-only. Vortex itself stays under the upstream Nexus Mods license. See [LICENSE](LICENSE).
