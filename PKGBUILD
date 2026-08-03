# Maintainer: Arkazzae <https://github.com/Arkazzae>

pkgname=vortex-linux
pkgver=2.4.2
pkgrel=1
pkgdesc="Native Linux build of Vortex with a generic compatibility layer"
arch=('x86_64')
url="https://github.com/Arkazzae/vortex-linux-aur"
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
  'npm'
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

_upstream_commit='147b45664a2c840af160a2dbdb4e4796a9982974'
_dotnet6='6.0.36'
_dotnet8='8.0.29'
_dotnet10='10.0.10'
_patches=(
  '0001-linux-runtime-compatibility.patch'
  '0002-linux-path-and-executable-discovery.patch'
  '0003-linux-filesystem-and-deployment.patch'
  '0004-linux-extension-dependency-handling.patch'
)

source=(
  "vortex::git+https://github.com/Nexus-Mods/Vortex.git#commit=${_upstream_commit}"
  "${_patches[@]}"
  'vortex.sh'
  'vortex.desktop'
  'README.md'
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
  'SKIP'
  'b5e2de4ebd001adc7b3111dcb7699c08fc4b8871869dc697fe77ae838834161af51e87a6f133833adb010bc8609d515317feef887fe387ab819e07b3fc34ed1b'
  'd2e700f878af54324a745358dcb94a1913ff505426f29fbeab0634338d626ce2df622e1e4189b9c38dea08c978fbeff047c754879474e8dfbb45fb2d72a64966'
  '8ecc2099a487070e5a65db4df8c25fc78fbe51580e55d7a8a819db47322671622ee7bbb666874542c24c6c17deca223b009525b14c980f7c4f02c0ddcb674d64'
  '9e0565b79768f51f5cc924628035cb247f4e6a670d7c52fa0364289b9bac4bd6a6bddbf2f905ddde16b46616e70c1934ff87801e2e75e0fbc2b00a11d1074dc8'
  '816976ac2e8e92dcc66762235fc7d7cc72c7fb1273969236bed4fe49ec0cb5c9705157c64d47ef779f09513cdf9ba877b97238e3b286db7caa8d24be6a9aeca0'
  '9bf22572d72496096c30271f225814c1666430afa85bee5b4f971b173c4931751bbca3d012bff984c26b47346544655bb140a1dce68fd2f58718769fcc38e68b'
  'f4d41e9f7cbef9796cb5605854a6963867449c15bf7fa3597ad47d4398729b3933fd778132275f6cabc9834699d6c55c3e4f3583c4fba8a007f8ae94b336fa23'
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

  # Some Nx targets stage Electron output as part of their dependency graph.
  # Always package into a fresh, explicitly scoped directory.
  rm -rf "$srcdir/vortex/dist/linux-unpacked"
  cd src/main/dist
  pnpm exec electron-builder \
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
  install -Dm644 LICENSE.md "$pkgdir/usr/share/licenses/$pkgname/LICENSE.md"
  install -Dm644 "$srcdir/README.md" \
    "$pkgdir/usr/share/doc/$pkgname/README.md"
}
