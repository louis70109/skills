#!/usr/bin/env bash
# Install each "external" skill of upstream.json at its pinned commit.
# Target: $SKILLS_DIR, default ~/.agents/skills.
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
target="${SKILLS_DIR:-$HOME/.agents/skills}"

jq -c '.[] | select(.mode == "external")' "$root/upstream.json" | while read -r entry; do
  name="$(jq -r .dest <<<"$entry")"
  repo="$(jq -r .repo <<<"$entry")"
  path="$(jq -r .path <<<"$entry")"
  commit="$(jq -r .commit <<<"$entry")"

  src="$(mktemp -d)"
  git -C "$src" init -q
  git -C "$src" fetch -q --depth 1 "https://github.com/$repo" "$commit"
  git -C "$src" checkout -q FETCH_HEAD

  rm -rf "${target:?}/$name"
  mkdir -p "$target/$name"
  cp -R "$src/$path/." "$target/$name"
  rm -rf "$target/$name/.git"
  if [ -f "$src/LICENSE" ]; then cp "$src/LICENSE" "$target/$name/LICENSE"; fi
  rm -rf "$src"
  echo "installed $name at ${commit:0:7} -> $target/$name"
done
