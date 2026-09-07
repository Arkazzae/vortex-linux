# Linux compatibility work

Branch: `feat/linux-compatibility-completion`. Each item is a separate commit,
including its regression tests and package metadata where needed.

- [x] Check release triggers and create the working branch. Push builds are
  restricted to `master`; pull requests can build artifacts but cannot publish.
- [x] Implement Linux INI reads and writes with the existing parser API.
- [ ] Resolve user folders from the selected game's prefix; cover Flatpak,
  multiple installations, and missing prefixes without guessing by modification time.
- [ ] Build Bethesda plugin management with native Linux LOOT and verify sorting.
- [ ] Route extension tools through the game's runner and prefix; respect Steam's
  default Proton and additional libraries.
- [ ] Discover and launch Heroic games from native and Flatpak installations,
  including Epic, GOG, and Amazon prefixes.
- [ ] Extend AppImage validation and document its limits. Keep the clean Ubuntu
  check without system .NET; add INI, plugin, prefix, tool, and deployment checks.

## Validation

Run relevant regression tests before each implementation commit. At completion,
apply the entire patch series to the pinned upstream source, run the compatibility
suite and typechecking, build the Arch package and AppImage, and test the AppImage
in a clean Ubuntu container. Use temporary fixtures instead of installed games
or user profiles. Record game-dependent checks separately; passing fixtures does
not establish that every game or collection works.

Existing fixes on `master`, including Vortex user-data protection and native FOMOD
module loading, must remain covered. No merge or release is part of this work.
