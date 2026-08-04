# Vortex for Linux — Arch/AUR build recipe

[![Upstream compatibility](https://github.com/Arkazzae/vortex-linux-aur/actions/workflows/upstream-compatibility.yml/badge.svg)](https://github.com/Arkazzae/vortex-linux-aur/actions/workflows/upstream-compatibility.yml)

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
- makes the deployment `Fix` action apply that suggestion automatically when
  the old staging directory is empty, while leaving non-empty directories to
  Vortex's normal transfer workflow;
- resolves executable and document paths without hard-coding individual games;
- maps Windows user-profile storage into the matching Steam/Proton prefix,
  including `Documents`, `AppData/Roaming`, `AppData/Local`, `AppData/LocalLow`
  and `Saved Games`;
- routes both asynchronous and synchronous extension filesystem calls through
  the same compatibility resolver;
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
- reconstructs an active download record if a failed or retried game setup
  removed its state before the transfer completed, preventing community
  extensions from receiving a spurious `Unknown Download` error.

The patches are platform-oriented. There are no per-game path lists or special
cases in the compatibility layer.

## Steam/Proton user profiles

Windows games usually keep configuration and saves outside their installation
directory. On Linux those files live in the game's Proton prefix under
`steamapps/compatdata/<appid>/pfx/drive_c/users/<user>`. The compatibility layer
searches all configured Steam libraries and maps an extension's standard
Windows profile path to the prefix where the corresponding game or application
directory already exists.

The resolver deliberately does not fabricate INI files or select an unrelated
prefix. Launch a newly installed game once so Proton and the game can create
their real profile directories and defaults, then let Vortex manage it.

Additional compatibility prefixes can be supplied through
`VORTEX_COMPAT_PREFIXES` as a colon-separated list. The native placeholder
roots can be overridden with `VORTEX_LINUX_DOCUMENTS`,
`VORTEX_LINUX_APPDATA`, `VORTEX_LINUX_LOCAL_APPDATA`,
`VORTEX_LINUX_LOCAL_LOW` and `VORTEX_LINUX_SAVED_GAMES`.

## Install the prebuilt Arch package

Every packaged revision that passes the compatibility suite on `master` is
built in a clean Arch Linux container and published under
[GitHub Releases](https://github.com/Arkazzae/vortex-linux-aur/releases). Each
release contains the installable `.pkg.tar.zst` archive and its SHA-256 file.

After downloading both files, verify and install the package with:

```sh
sha256sum --check vortex-linux-*.pkg.tar.zst.sha256
sudo pacman -U ./vortex-linux-*.pkg.tar.zst
```

The binary package targets current Arch Linux `x86_64`. Building from the
recipe remains available for Arch derivatives or customized environments.

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

## Upstream compatibility CI

The `Upstream compatibility` GitHub Actions workflow checks the pinned Vortex
revision for every patch or build-recipe change. Once a day it resolves the
latest stable release published by Nexus Mods and then:

1. fetches that exact upstream revision into a clean worktree;
2. applies every patch listed in `PKGBUILD`, in package order;
3. installs the Node.js and pnpm versions requested by that upstream release;
4. runs every test file touched by the patch series;
5. runs the renderer TypeScript typecheck.

For a change pushed to `master`, a successful check of the revision pinned in
`PKGBUILD` additionally builds the Arch package, uploads a workflow artifact and
publishes a versioned GitHub Release. The scheduled `latest` check does not ship
an uncommitted upstream revision; a new Vortex release is packaged after its
version and exact commit are recorded in `PKGBUILD`.

The workflow can also be started manually with a tag, branch or commit through
`Actions → Upstream compatibility → Run workflow`. Scheduled failures create or
update one tracking issue; a later successful scheduled run closes it.

Run the fast patch applicability check locally with:

```bash
scripts/check-upstream-compatibility.sh --ref latest --keep
```

Use `--ref pinned` to check the commit currently packaged by `PKGBUILD`.

## Filesystem rule for deployment

Hardlinks cannot cross filesystem boundaries. Put the Vortex staging directory
on the same mounted filesystem as the managed game. In Vortex, open
`Settings → Mods` and use the suggested staging path after selecting a game.
Fresh Linux configurations use this mode by default. The deployment `Fix`
action can switch an empty staging directory automatically; if mods are already
present, Vortex keeps the explicit transfer step so their files are not orphaned.

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
- `0008` — generic Steam/Proton user-profile resolution for documents, AppData,
  LocalLow and saved games across extension filesystem operations.
- `0009` — filesystem-aware staging suggestions, Linux defaults and a safe
  automatic repair for empty cross-filesystem staging directories.
- `0010` — recovery of active download state across failed or retried game setup.

The unmodified application source and license are maintained by
[Nexus Mods](https://github.com/Nexus-Mods/Vortex).

## License

The packaging files and Linux compatibility patches in this repository
are licensed under the GNU General Public License v3.0 only
(`GPL-3.0-only`). Vortex itself remains licensed and maintained by
Nexus Mods under its upstream terms. See [LICENSE](LICENSE).
