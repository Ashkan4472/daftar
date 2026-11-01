#!/usr/bin/env bash
# Bump the app version, commit and tag it.  Usage: scripts/version.sh patch|minor|major|X.Y.Z
# The +N build number is Android's versionCode: it must only ever go up, or phones refuse the update.
set -euo pipefail
cd "$(dirname "$0")/.."
[ -z "$(git status --porcelain)" ] || { echo "working tree not clean" >&2; exit 1; }

cur=$(sed -n 's/^version: *//p' app/pubspec.yaml)
name=${cur%+*}; build=${cur#*+}
IFS=. read -r ma mi pa <<<"$name"
case "${1:?patch|minor|major|X.Y.Z}" in
  patch) name="$ma.$mi.$((pa + 1))" ;;
  minor) name="$ma.$((mi + 1)).0" ;;
  major) name="$((ma + 1)).0.0" ;;
  *.*.*) name=$1 ;;
  *) echo "bad argument" >&2; exit 1 ;;
esac
new="$name+$((build + 1))"

sed -i.bak "s/^version: .*/version: $new/" app/pubspec.yaml && rm app/pubspec.yaml.bak
git add app/pubspec.yaml
git commit -q -m "chore: release v$name"
git tag -a "v$name" -m "Daftar $name"
echo "$cur -> $new (tagged v$name). Next: scripts/release.sh"
