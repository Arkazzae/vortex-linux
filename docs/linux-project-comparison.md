# Linux project comparison

Reviewed on 2026-09-07 against Vortex 2.6.3. Versions and branches below describe
that review, not a promise that those projects remain unchanged.

| Project | Relevant finding | Result in this branch |
| --- | --- | --- |
| [AUR vortex](https://aur.archlinux.org/packages/vortex) | Native packaging alone leaves Windows assumptions in game extensions. | Keep generic compatibility tests in addition to packaging checks. |
| [AUR vortex-linux-fix](https://aur.archlinux.org/packages/vortex-linux-fix) | Contains practical extension fixes, but its older plugin-management replacement stubs LOOT. | Use the official native libloot binding and test real sorting and metadata. |
| [rashidmya/linux-vortex](https://github.com/rashidmya/linux-vortex) | Implements INI operations and routes Windows tools on Linux. | Add the missing INI API and one runner path for UI and extension calls. |
| [Starkka15/Vortex](https://github.com/Starkka15/Vortex/tree/feat/linux-libloot) | Demonstrates native LOOT integration with a separate worker. | Build official libloot 0.29.6 from pinned source; serialize native metadata explicitly and reject outstanding calls when the worker exits. |
| [Vortex PR 23828](https://github.com/Nexus-Mods/Vortex/pull/23828) | Steam's default compatibility mapping and extra libraries matter when selecting Proton. | Honor app-specific/default mappings, inspect tool manifests and compare versions numerically. |
| [Heroic](https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher) | Epic, GOG and Amazon use different manifest formats; Wine/Proton settings belong to each game and installation. | Read those manifests, preserve store IDs and route launches through native Heroic or its Flatpak. |
| [libloot](https://github.com/loot/libloot/tree/0.29.6/nodejs) | Official Linux Node binding exposes synchronous operations and native metadata objects. | Run it in a child process, convert the values expected by Vortex and verify UTF-8 metadata and ghost plugins. |

## Remaining game-dependent work

Native Unity/BepInEx support, script extender setup and tools such as the Witcher 3
Script Merger may need extension-specific fixes. They need representative game
installations and are not established by the generic fixture suite.

A native and a Flatpak launcher can register the same game. Discovery retains the
installation paths, and prefix/tool lookup uses the selected path. Ambiguous
lookups report an error; they do not select the most recently modified prefix.

The AppImage test covers packaged components and a rendered desktop window. It
cannot establish that every game extension, interactive installer or Nexus
collection works. The clean container intentionally has no system .NET so a
missing bundled runtime cannot be hidden by the build machine.
