# Maintainer: Arkazzae <https://github.com/Arkazzae>

pkgname=vortex-linux
pkgver=2.6.2
pkgrel=1
pkgdesc="Community build of Vortex with generic Linux compatibility patches"
arch=('x86_64')
url="https://github.com/Arkazzae/vortex-linux"
license=('GPL-3.0-only')

depends=(
  'alsa-lib'
  'at-spi2-core'
  'cairo'
  'cups'
  'dotnet-runtime'
  'gtk3'
  'libappindicator'
  'libdrm'
  'libnotify'
  'libsecret'
  'libx11'
  'libxcb'
  'libxcomposite'
  'libxdamage'
  'libxext'
  'libxfixes'
  'libxkbcommon'
  'libxrandr'
  'libxss'
  'mesa'
  'nss'
  'pango'
  'wine'
  'wine-mono'
  'xdg-utils'
)
makedepends=(
  'dotnet-sdk'
  'git'
  'nodejs-lts-krypton'
  'npm'
  'patchelf'
  'pnpm'
  'python'
  'python-setuptools'
  'yarn'
)
optdepends=(
  'kde-cli-tools: native trash support on KDE Plasma'
  'pipewire: screen sharing under Wayland'
)
provides=("vortex=${pkgver}")
conflicts=('vortex' 'vortex-bin' 'vortex-git')
options=('!debug' '!strip')
install=vortex.install

_upstream_commit='af2fd1945e32ec3fabb9acdc117433e228ffdcca'
_dotnet6='6.0.36'
_dotnet8='8.0.29'
_dotnet10='10.0.10'
_patches=(
  '0001-linux-runtime-compatibility.patch'
  '0002-linux-path-and-executable-discovery.patch'
  '0003-linux-filesystem-and-deployment.patch'
  '0004-linux-extension-dependency-handling.patch'
  '0005-linux-steam-game-launch.patch'
  '0006-linux-optional-ini-purge.patch'
  '0007-linux-posix-hardlink-purge.patch'
  '0008-linux-proton-user-folders.patch'
  '0009-linux-staging-suggestions.patch'
  '0010-download-state-recovery.patch'
  '0011-linux-case-safe-deployment.patch'
  '0012-linux-extension-path-compatibility.patch'
  '0013-linux-win32-normalize-compatibility.patch'
)

source=(
  "vortex::git+https://github.com/Nexus-Mods/Vortex.git#commit=${_upstream_commit}"
  "${_patches[@]}"
  'vortex.sh'
  'vortex.desktop'
  'README.md'
  'LICENSE'
  "dotnet-runtime-${_dotnet6}-win-x64.zip::https://builds.dotnet.microsoft.com/dotnet/Runtime/${_dotnet6}/dotnet-runtime-${_dotnet6}-win-x64.zip"
  "dotnet-runtime-${_dotnet8}-win-x64.zip::https://builds.dotnet.microsoft.com/dotnet/Runtime/${_dotnet8}/dotnet-runtime-${_dotnet8}-win-x64.zip"
  "dotnet-runtime-${_dotnet10}-win-x64.zip::https://builds.dotnet.microsoft.com/dotnet/Runtime/${_dotnet10}/dotnet-runtime-${_dotnet10}-win-x64.zip"
  "windowsdesktop-runtime-${_dotnet6}-win-x64.zip::https://builds.dotnet.microsoft.com/dotnet/WindowsDesktop/${_dotnet6}/windowsdesktop-runtime-${_dotnet6}-win-x64.zip"
  "windowsdesktop-runtime-${_dotnet8}-win-x64.zip::https://builds.dotnet.microsoft.com/dotnet/WindowsDesktop/${_dotnet8}/windowsdesktop-runtime-${_dotnet8}-win-x64.zip"
  "windowsdesktop-runtime-${_dotnet10}-win-x64.zip::https://builds.dotnet.microsoft.com/dotnet/WindowsDesktop/${_dotnet10}/windowsdesktop-runtime-${_dotnet10}-win-x64.zip"
)
noextract=(
  "dotnet-runtime-${_dotnet6}-win-x64.zip"
  "dotnet-runtime-${_dotnet8}-win-x64.zip"
  "dotnet-runtime-${_dotnet10}-win-x64.zip"
  "windowsdesktop-runtime-${_dotnet6}-win-x64.zip"
  "windowsdesktop-runtime-${_dotnet8}-win-x64.zip"
  "windowsdesktop-runtime-${_dotnet10}-win-x64.zip"
)
sha512sums=(
  # Vortex is pinned by _upstream_commit; all following local files are versioned
  # together with this PKGBUILD, so hashing them only duplicates Git integrity.
  'SKIP'
  'SKIP'
  'SKIP'
  'SKIP'
  'SKIP'
  'SKIP'
  'SKIP'
  'SKIP'
  'SKIP'
  'SKIP'
  'SKIP'
  'SKIP'
  'SKIP'
  'SKIP'
  'SKIP'
  'SKIP'
  'SKIP'
  'SKIP'
  # Keep integrity checks for binaries downloaded outside this repository.
  '935db5c6cee19f2c016e67168bfae7b491044735de76c673abb3b125dd325fd5e779d7efe12ba80178d46689ae70a25e558a3fa846417d44c5f4ca256e7f4bf2'
  'e3f31d298a2b674b54c7fc89fb3f06d9645fc5879a54f2ebf2ea20e9ee7ae55f1bfe3284c1f90a591d6be2d6bcd251790ddc27771d65303e7a6a56d331df4632'
  '2161dfa1cf027cdc074de7195b5f206b17ebd829ae415b9e7c9ee5f06d3952b6583030022dbe0d6e9221b5c577c411d7cd5322241f6d2299d9c886641215699b'
  'cee88fef07643dceb3d34ea71b64eeae85b8e39e7042bc4d35bc3a1f1df29373681dc48e31c01c9f593ec412699f6762b6fc5817433283c89df35a27ce8885bf'
  '7cf8d7ec8daeb2734dc44e0a06ca5001cdb459ba7534f4821b6a0e918cf4004e45531d5df794885b0a48ffb61658fc4a43ff23a3260fe9bbc1c32f807d422651'
  '58e243f490e09b00ef8c20d7c3dc06d0385aa4180b359eeb4ae8924ad1300fd19ec96c10e3989a96c4ce0076cf38e639bfb2b909baace73864dac28d64cdf9fc'
)

prepare() {
  cd "$srcdir/vortex"

  local compatibility_patch
  for compatibility_patch in "${_patches[@]}"; do
    patch -Np1 -i "$srcdir/$compatibility_patch"
  done

  export npm_config_runtime='electron'
  export npm_config_target='43.0.0'
  export npm_config_disturl='https://electronjs.org/headers'
  pnpm install --frozen-lockfile
}

build() {
  cd "$srcdir/vortex"

  export CI=1
  export NODE_ENV='production'
  export NO_PARALLEL=1
  export VORTEX_SKIP_SUBMODULES=1
  export npm_config_runtime='electron'
  export npm_config_target='43.0.0'
  export npm_config_disturl='https://electronjs.org/headers'

  pnpm run build
  pnpm nx run @vortex/main:publish

  # leveldown 5.6.0 ships an old N-API prebuild which node-gyp-build prefers
  # over the binary rebuilt for Electron.  Under Electron 43 / Node 24 that
  # prebuild segfaults in snappy::CompressFragment while Vortex updates its
  # metadata database, causing Electron to restart the renderer indefinitely.
  # Keep prebuild-only resolution for the other native dependencies, but make
  # leveldown's selected Linux prebuild the binary produced by this build.
  local leveldown_dir="$srcdir/vortex/src/main/dist/node_modules/leveldown"
  local leveldown_build="$leveldown_dir/build/Release/leveldown.node"
  local leveldown_prebuild="$leveldown_dir/prebuilds/linux-x64/node.napi.glibc.node"
  if [[ ! -f "$leveldown_build" || ! -f "$leveldown_prebuild" ]]; then
    printf 'The rebuilt or prebuilt leveldown addon is missing\n' >&2
    return 1
  fi
  install -Dm755 "$leveldown_build" "$leveldown_prebuild"
  if ! cmp -s "$leveldown_build" "$leveldown_prebuild"; then
    printf 'Unable to replace the incompatible leveldown prebuild\n' >&2
    return 1
  fi

  # Some Nx targets stage Electron output as part of their dependency graph.
  # Always package into a fresh, explicitly scoped directory.
  rm -rf "$srcdir/vortex/dist/linux-unpacked"
  cd src/main/dist
  ./node_modules/.bin/electron-builder \
    --config ./electron-builder.config.json \
    --publish never \
    --linux dir \
    --x64 \
    -c.compression=store
}

package() {
  cd "$srcdir/vortex"

  install -dm755 "$pkgdir/opt/Vortex"
  cp -a dist/linux-unpacked/. "$pkgdir/opt/Vortex/"

  # The native FOMOD addon is built with an absolute RUNPATH pointing at the
  # build tree. Make the packaged addon relocatable so it can find the
  # co-located NativeAOT library after installation and inside an AppImage.
  local fomod_release_dir="$pkgdir/opt/Vortex/resources/app.asar.unpacked/node_modules/@nexusmods/fomod-installer-native/build/Release"
  local fomod_node="$fomod_release_dir/modinstaller.node"
  local fomod_library="$fomod_release_dir/ModInstaller.Native.so"
  if [[ ! -f "$fomod_node" || ! -f "$fomod_library" ]]; then
    printf 'Native FOMOD runtime files are missing from the Electron output\n' >&2
    return 1
  fi
  patchelf --set-rpath '$ORIGIN' "$fomod_node"
  if [[ "$(patchelf --print-rpath "$fomod_node")" != '$ORIGIN' ]]; then
    printf 'Unable to make the native FOMOD addon relocatable\n' >&2
    return 1
  fi

  install -dm755 "$pkgdir/opt/Vortex/dotnet-win-x64"
  local runtime_version
  for runtime_version in "$_dotnet6" "$_dotnet8" "$_dotnet10"; do
    bsdtar -xf "$srcdir/dotnet-runtime-${runtime_version}-win-x64.zip" \
      -C "$pkgdir/opt/Vortex/dotnet-win-x64"
    bsdtar -xf "$srcdir/windowsdesktop-runtime-${runtime_version}-win-x64.zip" \
      -C "$pkgdir/opt/Vortex/dotnet-win-x64"
  done

  chmod 4755 "$pkgdir/opt/Vortex/chrome-sandbox"

  install -Dm755 "$srcdir/vortex.sh" "$pkgdir/usr/bin/vortex"
  install -Dm644 "$srcdir/vortex.desktop" \
    "$pkgdir/usr/share/applications/com.nexusmods.vortex.desktop"
  install -Dm644 assets/images/vortex.png \
    "$pkgdir/usr/share/icons/hicolor/256x256/apps/vortex.png"
  install -Dm644 LICENSE.md "$pkgdir/usr/share/licenses/$pkgname/VORTEX-LICENSE.md"
  install -Dm644 "$srcdir/LICENSE" \
    "$pkgdir/usr/share/licenses/$pkgname/PATCHES-GPL-3.0.txt"
  install -Dm644 "$srcdir/README.md" \
    "$pkgdir/usr/share/doc/$pkgname/README.md"
}
