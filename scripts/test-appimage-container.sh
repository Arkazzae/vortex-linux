#!/usr/bin/env bash

set -Eeuo pipefail

readonly SOURCE_APPIMAGE="${1:?usage: test-appimage-container.sh APPIMAGE}"
readonly TEST_ROOT='/tmp/vortex-appimage-smoke'
readonly TEST_APPIMAGE="${TEST_ROOT}/Vortex.AppImage"
readonly STARTUP_LOG="${TEST_ROOT}/startup.log"
readonly DEPENDENCY_LOG="${TEST_ROOT}/dependencies.log"

if command -v dotnet >/dev/null 2>&1; then
  printf 'The clean-container test image unexpectedly contains dotnet\n' >&2
  exit 1
fi

install -Dm755 "$SOURCE_APPIMAGE" "$TEST_APPIMAGE"

export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
if ! apt-get install --quiet=2 --no-install-recommends --yes \
  dbus-x11 \
  libasound2t64 \
  libatk-bridge2.0-0 \
  libatspi2.0-0 \
  libcups2t64 \
  libdrm2 \
  libgbm1 \
  libgtk-3-0t64 \
  libicu74 \
  libnss3 \
  libxcomposite1 \
  libxdamage1 \
  libxfixes3 \
  libxkbcommon0 \
  libxrandr2 \
  libxss1 \
  wine \
  wine64 \
  xvfb >"$DEPENDENCY_LOG" 2>&1; then
  printf 'Unable to install clean-container runtime dependencies\n' >&2
  sed -n '1,240p' "$DEPENDENCY_LOG" >&2
  exit 1
fi

if command -v dotnet >/dev/null 2>&1; then
  printf 'Host dotnet was pulled in by runtime dependencies; test is not hermetic\n' >&2
  exit 1
fi

for command_name in dbus-run-session wine xvfb-run; do
  if ! command -v "$command_name" >/dev/null 2>&1; then
    printf 'Clean-container runtime command is missing: %s\n' "$command_name" >&2
    exit 1
  fi
done

printf 'Running AppImage runtime self-test without host .NET\n'
APPIMAGE_EXTRACT_AND_RUN=1 timeout 30s "$TEST_APPIMAGE" --vortex-self-test

useradd --create-home --shell /bin/bash vortex-test
install -o vortex-test -g vortex-test -m755 "$TEST_APPIMAGE" /home/vortex-test/Vortex.AppImage

printf 'Starting the full AppImage under Xvfb\n'
set +e
runuser --user vortex-test -- env \
  HOME=/home/vortex-test \
  XDG_CONFIG_HOME=/home/vortex-test/.config \
  XDG_DATA_HOME=/home/vortex-test/.local/share \
  APPIMAGE_EXTRACT_AND_RUN=1 \
  timeout --signal=TERM --kill-after=5s 25s \
  dbus-run-session -- \
  xvfb-run --auto-servernum /home/vortex-test/Vortex.AppImage --no-sandbox \
  >"$STARTUP_LOG" 2>&1
startup_status=$?
set -e

if [[ "$startup_status" -ne 124 ]]; then
  printf 'AppImage exited during the startup window (status %d)\n' "$startup_status" >&2
  sed -n '1,240p' "$STARTUP_LOG" >&2
  exit 1
fi

if grep -Fq 'You must install .NET to run this application' "$STARTUP_LOG"; then
  printf 'AppImage tried to use a host .NET installation\n' >&2
  sed -n '1,240p' "$STARTUP_LOG" >&2
  exit 1
fi

printf 'AppImage remained running for the 25-second smoke window\n'
