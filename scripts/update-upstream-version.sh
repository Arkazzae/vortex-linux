#!/usr/bin/env bash

set -Eeuo pipefail

REPOSITORY_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
readonly REPOSITORY_ROOT
readonly PKGBUILD_PATH="${REPOSITORY_ROOT}/PKGBUILD"
readonly SRCINFO_PATH="${REPOSITORY_ROOT}/.SRCINFO"

upstream_ref=""
upstream_commit=""

usage() {
  cat <<'EOF'
Usage: scripts/update-upstream-version.sh --ref REF --commit COMMIT

Update PKGBUILD and .SRCINFO to a tested stable Vortex release. REF must be a
numeric stable release tag such as v2.7.0 and COMMIT must be its full Git SHA.

The script writes these GitHub Actions outputs when GITHUB_OUTPUT is set:
  changed, package_version, package_revision, upstream_commit
EOF
}

read_pkgbuild_value() {
  local variable_name="$1"
  local value

  value="$(sed -nE "s/^${variable_name}=['\"]?([^'\"]+)['\"]?$/\\1/p" \
    "$PKGBUILD_PATH" | head -n 1)"
  if [[ -z "$value" ]]; then
    printf 'Unable to read %s from PKGBUILD\n' "$variable_name" >&2
    return 1
  fi
  printf '%s' "$value"
}

write_output() {
  local key="$1"
  local value="$2"
  if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
    printf '%s=%s\n' "$key" "$value" >> "$GITHUB_OUTPUT"
  fi
}

# Print -1, 0, or 1 when the first dotted numeric version is older than, equal
# to, or newer than the second one.
compare_versions() {
  local first="$1"
  local second="$2"
  local -a first_parts=()
  local -a second_parts=()
  local part_count
  local index
  local first_part
  local second_part

  IFS=. read -r -a first_parts <<< "$first"
  IFS=. read -r -a second_parts <<< "$second"
  part_count="${#first_parts[@]}"
  if ((${#second_parts[@]} > part_count)); then
    part_count="${#second_parts[@]}"
  fi

  for ((index = 0; index < part_count; index++)); do
    first_part="${first_parts[index]:-0}"
    second_part="${second_parts[index]:-0}"
    if ((10#$first_part < 10#$second_part)); then
      printf '%s' -1
      return
    fi
    if ((10#$first_part > 10#$second_part)); then
      printf '%s' 1
      return
    fi
  done
  printf '%s' 0
}

replace_once() {
  local path="$1"
  local pattern="$2"
  local replacement="$3"
  local expected_count="$4"
  local actual_count

  actual_count="$(grep -Ec "$pattern" "$path")"
  if [[ "$actual_count" -ne "$expected_count" ]]; then
    printf 'Expected %d match(es) for %s in %s, found %d\n' \
      "$expected_count" "$pattern" "$path" "$actual_count" >&2
    return 1
  fi
  sed -Ei "s|${pattern}|${replacement}|" "$path"
}

while (($# > 0)); do
  case "$1" in
    --ref)
      upstream_ref="${2:?--ref requires a value}"
      shift 2
      ;;
    --commit)
      upstream_commit="${2:?--commit requires a value}"
      shift 2
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown option: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ -z "$upstream_ref" || -z "$upstream_commit" ]]; then
  usage >&2
  exit 2
fi
if [[ ! "$upstream_ref" =~ ^v?([0-9]+(\.[0-9]+){1,3})$ ]]; then
  printf 'Not a stable numeric Vortex release tag: %s\n' "$upstream_ref" >&2
  exit 2
fi
new_version="${BASH_REMATCH[1]}"
if [[ ! "$upstream_commit" =~ ^[0-9a-fA-F]{40}$ ]]; then
  printf 'Not a full Git commit SHA: %s\n' "$upstream_commit" >&2
  exit 2
fi

upstream_commit="${upstream_commit,,}"
old_version="$(read_pkgbuild_value pkgver)"
old_release="$(read_pkgbuild_value pkgrel)"
old_commit="$(read_pkgbuild_value _upstream_commit)"

if [[ ! "$old_version" =~ ^[0-9]+(\.[0-9]+){1,3}$ ]]; then
  printf 'Current pkgver is not a dotted numeric version: %s\n' "$old_version" >&2
  exit 1
fi
if [[ ! "$old_release" =~ ^[0-9]+$ ]]; then
  printf 'Current pkgrel is not numeric: %s\n' "$old_release" >&2
  exit 1
fi

version_order="$(compare_versions "$new_version" "$old_version")"
if [[ "$version_order" == -1 ]]; then
  printf 'Refusing to downgrade Vortex from %s to %s\n' \
    "$old_version" "$new_version" >&2
  exit 1
fi

if [[ "$upstream_commit" == "${old_commit,,}" ]]; then
  if [[ "$new_version" != "$old_version" ]]; then
    printf 'Commit %s is already pinned as version %s, not %s\n' \
      "$upstream_commit" "$old_version" "$new_version" >&2
    exit 1
  fi
  changed=false
  new_release="$old_release"
else
  changed=true
  if [[ "$new_version" == "$old_version" ]]; then
    new_release="$((old_release + 1))"
  else
    new_release=1
  fi

  replace_once "$PKGBUILD_PATH" '^pkgver=.*$' "pkgver=${new_version}" 1
  replace_once "$PKGBUILD_PATH" '^pkgrel=.*$' "pkgrel=${new_release}" 1
  replace_once "$PKGBUILD_PATH" "^_upstream_commit=.*$" \
    "_upstream_commit='${upstream_commit}'" 1

  replace_once "$SRCINFO_PATH" '^[[:space:]]+pkgver = .*$' \
    "\tpkgver = ${new_version}" 1
  replace_once "$SRCINFO_PATH" '^[[:space:]]+pkgrel = .*$' \
    "\tpkgrel = ${new_release}" 1
  replace_once "$SRCINFO_PATH" '^[[:space:]]+provides = vortex=.*$' \
    "\tprovides = vortex=${new_version}" 1
  replace_once "$SRCINFO_PATH" \
    '^[[:space:]]+source = vortex::git\+https://github\.com/Nexus-Mods/Vortex\.git#commit=.*$' \
    "\tsource = vortex::git+https://github.com/Nexus-Mods/Vortex.git#commit=${upstream_commit}" 1
fi

package_revision="${new_version}-${new_release}"
write_output changed "$changed"
write_output package_version "$new_version"
write_output package_revision "$package_revision"
write_output upstream_commit "$upstream_commit"

if [[ "$changed" == true ]]; then
  printf 'Prepared Vortex %s (%s) as package revision %s.\n' \
    "$new_version" "$upstream_commit" "$package_revision"
else
  printf 'Vortex %s (%s) is already pinned.\n' \
    "$new_version" "$upstream_commit"
fi
