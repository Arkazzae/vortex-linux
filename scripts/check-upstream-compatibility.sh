#!/usr/bin/env bash

set -Eeuo pipefail

REPOSITORY_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
readonly REPOSITORY_ROOT
readonly PKGBUILD_PATH="${REPOSITORY_ROOT}/PKGBUILD"

requested_ref="latest"
worktree=""
temporary_worktree=false
keep_worktree=false

usage() {
  cat <<'EOF'
Usage: scripts/check-upstream-compatibility.sh [options]

Clone a clean Vortex revision and apply every patch listed in PKGBUILD.

Options:
  --ref REF          Vortex tag, branch, commit, "latest", or "pinned"
                     (default: latest)
  --worktree PATH    Empty directory in which to prepare the patched source
  --keep             Keep an automatically-created temporary worktree
  -h, --help         Show this help

Environment:
  VORTEX_UPSTREAM_REPOSITORY  GitHub owner/repository (default: Nexus-Mods/Vortex)
  VORTEX_UPSTREAM_URL         Git URL override
  GITHUB_TOKEN                Optional token for the latest-release API request
EOF
}

trim() {
  local value="$1"
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  printf '%s' "$value"
}

read_pkgbuild_value() {
  local variable_name="$1"
  local value

  value="$(sed -nE "s/^${variable_name}=['\"]([^'\"]+)['\"]$/\\1/p" \
    "$PKGBUILD_PATH" | head -n 1)"
  if [[ -z "$value" ]]; then
    printf 'Unable to read %s from PKGBUILD\n' "$variable_name" >&2
    return 1
  fi
  printf '%s' "$value"
}

pinned_commit="$(read_pkgbuild_value _upstream_commit)"

read_patch_series() {
  local inside=false
  local line
  local patch_name

  while IFS= read -r line; do
    if [[ "$line" == "_patches=(" ]]; then
      inside=true
      continue
    fi
    if [[ "$inside" == true && "$line" == ")" ]]; then
      break
    fi
    if [[ "$inside" == true ]]; then
      patch_name="$(trim "$line")"
      patch_name="${patch_name#\'}"
      patch_name="${patch_name%\'}"
      patch_name="${patch_name#\"}"
      patch_name="${patch_name%\"}"
      if [[ -n "$patch_name" ]]; then
        printf '%s\n' "$patch_name"
      fi
    fi
  done < "$PKGBUILD_PATH"
}

write_output() {
  local key="$1"
  local value="$2"
  if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
    printf '%s=%s\n' "$key" "$value" >> "$GITHUB_OUTPUT"
  fi
}

write_summary() {
  if [[ -n "${GITHUB_STEP_SUMMARY:-}" ]]; then
    cat >> "$GITHUB_STEP_SUMMARY" <<EOF
### Vortex patch compatibility

- Requested ref: \`${requested_ref}\`
- Resolved ref: \`${resolved_ref}\`
- Commit: \`${upstream_commit}\`
- Different from pinned commit: \`${upstream_changed}\`
- Patches applied: ${#patches[@]}
- Node.js: \`${node_version}\`
- pnpm: \`${pnpm_version}\`
EOF
  fi
}

cleanup() {
  if [[ "$temporary_worktree" == true && "$keep_worktree" != true ]]; then
    rm -rf -- "$worktree"
  fi
}

while (($# > 0)); do
  case "$1" in
    --ref)
      requested_ref="${2:?--ref requires a value}"
      shift 2
      ;;
    --worktree)
      worktree="${2:?--worktree requires a value}"
      shift 2
      ;;
    --keep)
      keep_worktree=true
      shift
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

if [[ "$requested_ref" == "pinned" ]]; then
  requested_ref="$(read_pkgbuild_value _upstream_commit)"
fi

readonly upstream_repository="${VORTEX_UPSTREAM_REPOSITORY:-Nexus-Mods/Vortex}"
readonly upstream_url="${VORTEX_UPSTREAM_URL:-https://github.com/${upstream_repository}.git}"
resolved_ref="$requested_ref"
release_url="https://github.com/${upstream_repository}"

if [[ "$requested_ref" == "latest" ]]; then
  api_headers=(-H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28")
  if [[ -n "${GITHUB_TOKEN:-}" ]]; then
    api_headers+=(-H "Authorization: Bearer ${GITHUB_TOKEN}")
  fi
  release_json="$(curl --fail --silent --show-error --location \
    "${api_headers[@]}" \
    "https://api.github.com/repos/${upstream_repository}/releases/latest")"
  resolved_ref="$(jq -er '.tag_name' <<< "$release_json")"
  release_url="$(jq -er '.html_url' <<< "$release_json")"
fi

if [[ -z "$worktree" ]]; then
  worktree="$(mktemp -d -t vortex-upstream-compatibility.XXXXXXXX)"
  temporary_worktree=true
else
  if [[ -e "$worktree" ]] && [[ -n "$(find "$worktree" -mindepth 1 -maxdepth 1 -print -quit)" ]]; then
    printf 'Worktree must be empty: %s\n' "$worktree" >&2
    exit 2
  fi
  mkdir -p -- "$worktree"
fi
trap cleanup EXIT

mapfile -t patches < <(read_patch_series)
if ((${#patches[@]} == 0)); then
  printf 'PKGBUILD does not contain a patch series\n' >&2
  exit 1
fi

printf 'Preparing %s at %s\n' "$upstream_repository" "$resolved_ref"
git -C "$worktree" init --quiet
git -C "$worktree" remote add origin "$upstream_url"

if [[ "$resolved_ref" =~ ^[0-9a-fA-F]{40}$ ]]; then
  git -C "$worktree" fetch --quiet --depth=1 origin "$resolved_ref"
elif git -C "$worktree" fetch --quiet --depth=1 origin "refs/tags/${resolved_ref}"; then
  :
elif git -C "$worktree" fetch --quiet --depth=1 origin "$resolved_ref"; then
  :
else
  printf 'Unable to fetch upstream ref: %s\n' "$resolved_ref" >&2
  exit 1
fi
git -C "$worktree" -c advice.detachedHead=false checkout --quiet --detach FETCH_HEAD

upstream_commit="$(git -C "$worktree" rev-parse HEAD)"
if [[ "$upstream_commit" == "$pinned_commit" ]]; then
  upstream_changed=false
else
  upstream_changed=true
fi
node_version="$(jq -r \
  '.devEngines.runtime.version // .volta.node // .engines.node // empty' \
  "$worktree/package.json")"
pnpm_version="$(jq -r \
  '.packageManager // empty | capture("^pnpm@(?<version>[^+]+)").version' \
  "$worktree/package.json")"

if [[ ! "$node_version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ || \
    ! "$pnpm_version" =~ ^[0-9]+\.[0-9]+\.[0-9]+([.-][0-9A-Za-z.-]+)?$ ]]; then
  printf 'Upstream package.json contains an unsupported Node.js or pnpm version: %s / %s\n' \
    "${node_version:-missing}" "${pnpm_version:-missing}" >&2
  exit 1
fi

# Publish the resolved revision before applying patches so a failed scheduled
# check can still identify the incompatible upstream release in its issue.
write_output requested_ref "$requested_ref"
write_output upstream_ref "$resolved_ref"
write_output upstream_commit "$upstream_commit"
write_output upstream_url "$release_url"
write_output upstream_changed "$upstream_changed"
write_output node_version "$node_version"
write_output pnpm_version "$pnpm_version"
write_output worktree "$worktree"

for patch_name in "${patches[@]}"; do
  patch_path="${REPOSITORY_ROOT}/${patch_name}"
  if [[ ! -f "$patch_path" ]]; then
    printf 'Patch listed in PKGBUILD is missing: %s\n' "$patch_name" >&2
    exit 1
  fi

  printf 'Checking %-49s' "$patch_name"
  if ! git -C "$worktree" apply --check "$patch_path"; then
    printf 'FAILED\n' >&2
    if [[ "${GITHUB_ACTIONS:-false}" == true ]]; then
      printf '::error file=%s::Patch does not apply to Vortex %s\n' "$patch_name" "$resolved_ref"
    fi
    exit 1
  fi
  git -C "$worktree" apply "$patch_path"
  printf 'OK\n'
done
write_summary

printf '\nAll %d patches apply to Vortex %s (%s).\n' \
  "${#patches[@]}" "$resolved_ref" "$upstream_commit"
printf 'Patched source: %s\n' "$worktree"
