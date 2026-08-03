# Vortex for Linux — Arch/AUR build recipe

This repository contains only the Arch packaging and generic Linux compatibility
patches required to build [Vortex](https://github.com/Nexus-Mods/Vortex). It does
**not** redistribute or mirror the Vortex source tree. The `PKGBUILD` checks out
the pinned official release commit and applies the patches locally during the
build.

This is an independent community package, not an official Nexus Mods release or
support channel.

## What the compatibility layer does

- replaces Windows-only volume and disk queries with portable filesystem logic;
- treats not-yet-created deployment directories correctly by checking their
  nearest existing parent;
- suggests a staging directory on the same mounted filesystem as the game,
  which is required for hardlink deployment;
- resolves executable and document paths without hard-coding individual games;
- launches Windows-only helper tools through one isolated Wine prefix while the
  Vortex Electron application itself runs natively;
- hands complete Steam game launches back to the native Steam client by AppID,
  preserving Proton selection, launch options, DRM and the Steam Runtime;
- tracks the delayed Steam/Proton process so the Play button changes to
  `Running...`, blocks duplicate launches and resets after the game exits;
- treats missing backups for optional game INI files as a no-op during purge,
  while preserving errors for real restore failures;
- identifies hardlinks on native Linux by their exact filesystem device and
  inode, so purge and disable/remove operations actually retract deployed files;
- supplies side-by-side Windows Desktop .NET runtimes for managed helper tools;
- adds safe fallbacks for extensions that rely on optional Windows APIs;
- keeps genuinely broken third-party extension dependencies visible instead of
  hiding their errors.

The patches are platform-oriented. There are no per-game path lists or special
cases in the compatibility layer.

## Build and install

On Arch Linux or an Arch derivative:

```sh
git clone https://github.com/Arkazzae/vortex-linux-aur.git
cd vortex-linux-aur
makepkg -si
```

Then register Vortex as the handler for Nexus Mods links:

```sh
xdg-mime default com.nexusmods.vortex.desktop x-scheme-handler/nxm
```

Builds are intentionally pinned to an exact upstream Vortex commit. The large
build downloads the official source, Node dependencies, Electron, and the
Microsoft Windows runtime components required by managed helper tools.

## Filesystem rule for deployment

Hardlinks cannot cross filesystem boundaries. Put the Vortex staging directory
on the same mounted filesystem as the managed game. In Vortex, open
`Settings → Mods` and use the suggested staging path after selecting a game.

The compatibility layer can detect the correct mount and can validate a target
whose final directory has not been created yet. It cannot make two different
filesystems support cross-device hardlinks.

## Runtime layout

Vortex runs as a native Electron application. Only helper executables supplied
by extensions are routed through Wine. Their prefix defaults to:

```text
${XDG_DATA_HOME:-$HOME/.local/share}/vortex-linux/wineprefix
```

Override it with `VORTEX_WINEPREFIX`. The Windows .NET bundle can be overridden
with `VORTEX_DOTNET_WIN_ROOT`, and `VORTEX_OZONE_PLATFORM=auto` disables the
default X11/XWayland workaround.

## Scope and limitations

Vortex has hundreds of game extensions, and upstream currently targets Windows.
The compatibility layer fixes shared assumptions in the application core, but a
third-party or game extension may still need its own upstream fix. Report issues
with reproduction steps and the relevant portion of
`~/.config/Vortex/vortex.log`; never include Nexus authentication tokens or
private download URLs.

## Patch layout

- `0001` — process, Wine/.NET, PE-version and WinAPI compatibility;
- `0002` — portable path and executable discovery;
- `0003` — volume, staging and deployment behavior;
- `0004` — optional extension dependency handling.
- `0005` — native Steam launch routing and Proton process tracking for full games
  on Linux.
- `0006` — safe purge behavior for optional INI files that were never created.
- `0007` — POSIX hardlink ownership detection and reliable native Linux purge.

The unmodified application source and license are maintained by
[Nexus Mods](https://github.com/Nexus-Mods/Vortex).

## License

The packaging files and Linux compatibility patches in this repository
are licensed under the GNU General Public License v3.0 only
(`GPL-3.0-only`). Vortex itself remains licensed and maintained by
Nexus Mods under its upstream terms. See [LICENSE](LICENSE).
