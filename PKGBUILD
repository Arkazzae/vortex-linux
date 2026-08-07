# Maintainer: Arkazzae <https://github.com/Arkazzae>

pkgname=vortex-linux
pkgver=2.4.2
pkgrel=12
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

_upstream_commit='147b45664a2c840af160a2dbdb4e4796a9982974'
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
  'SKIP'
  'b5e2de4ebd001adc7b3111dcb7699c08fc4b8871869dc697fe77ae838834161af51e87a6f133833adb010bc8609d515317feef887fe387ab819e07b3fc34ed1b'
  'd2e700f878af54324a745358dcb94a1913ff505426f29fbeab0634338d626ce2df622e1e4189b9c38dea08c978fbeff047c754879474e8dfbb45fb2d72a64966'
  '8ecc2099a487070e5a65db4df8c25fc78fbe51580e55d7a8a819db47322671622ee7bbb666874542c24c6c17deca223b009525b14c980f7c4f02c0ddcb674d64'
  '9e0565b79768f51f5cc924628035cb247f4e6a670d7c52fa0364289b9bac4bd6a6bddbf2f905ddde16b46616e70c1934ff87801e2e75e0fbc2b00a11d1074dc8'
  '7200f121d2f6e83da147ca714d6364f99f8c9e122ed690cddb1ba0fb700d1190d23d279e6b9d04ecd2c9837cd8d531c4a2daa816af72a962abb7e41b9ef2c9b6'
  '3e3a91316fa3cf05a0feaf825d3f4551ab08724f2de7fab3db958b6ab8220879554a9b1b383cfefd26b514c5bbe419299f822b41809a786c02c96e50f5e41dac'
  '184876a9c448f9b3dc15696c6eebf6dbec02ef35a3d7c7683ed7f5ec0f81c797517b72b7ea139453d790004dcc9e9377720d7dedd32ae18873eb612ec19a443d'
  'a6a840e107750d26062f976e08a077198152a9dbf2a5ae22340ed842bd33d23ba0c8b875375c4676051bfbc56dfd2858f39dc0c04d33f22e55ce2917167d665d'
  '6c1324e03fa2cf56798511d15d034fd5368dde10a170dc515cf303ae8dd8950e03b9a9365b929a07de1d145d1153588081a276e18b03888ba370b9bbc3988f0a'
  '4889fd282fdab0dbef4e6d7b0f1f1afc07f25e799c77df910ee88bf0733f1cab84f56054618e6af9326033e71a9b0250be111a41b3b7ddf801cdc8273ebd3c51'
  'c09b6a4b0fa13a4f642c6492fa6ff63ad8b984a6f4bc1ace3f4d1afe27985d5d287ad2a3399cc099d263155f933156bf14e12d91e2a42af8584efead78ed350a'
  '73db679d526b6657b454ae4e464f8adc5ee503630648f160877ef88e8fce2d48c9272687f4bf49a60e5adf4bee36b0abf06c502116c0a674f8648a8833dc38b2'
  '9bf22572d72496096c30271f225814c1666430afa85bee5b4f971b173c4931751bbca3d012bff984c26b47346544655bb140a1dce68fd2f58718769fcc38e68b'
  'ce4d3230131ebe82af04f991b7550e2a0c353ae829f7707eb622403aef10d3e50fd93bcb048235a09c9fd612d8416e11b48a87f33e7bcb55b098331bd75de263'
  '6792296df27f1dc2cce19cd11d842a7b415d613f3c4fe96a8a11bbab05a4b3d12a28846a7eee657ae6711da0398e3b77e8ea91cf0bbe4dc432d0dedd7a6a7394'
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
