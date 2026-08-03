#!/bin/sh

export IGNORE_UPDATES="${IGNORE_UPDATES:-yes}"
export ELECTRON_TRASH="${ELECTRON_TRASH:-gio}"
export PREBUILDS_ONLY="${PREBUILDS_ONLY:-1}"

export VORTEX_DOTNET_WIN_ROOT="${VORTEX_DOTNET_WIN_ROOT:-/opt/Vortex/dotnet-win-x64}"
export VORTEX_WINEPREFIX="${VORTEX_WINEPREFIX:-${XDG_DATA_HOME:-$HOME/.local/share}/vortex-linux/wineprefix}"
export DOTNET_ROLL_FORWARD="${DOTNET_ROLL_FORWARD:-Major}"
export DOTNET_MULTILEVEL_LOOKUP="${DOTNET_MULTILEVEL_LOOKUP:-0}"

case "${1-}" in
  nxm://*) set -- --download "$@" ;;
esac

case "${VORTEX_OZONE_PLATFORM:-x11}" in
  auto) ;;
  *) set -- "--ozone-platform=${VORTEX_OZONE_PLATFORM:-x11}" --disable-vulkan "$@" ;;
esac

exec /opt/Vortex/vortex "$@"
