#!/usr/bin/env bash
# Test, build the split-per-ABI release APKs and publish them as a GitHub release for the current tag.
# Run scripts/version.sh first. Updates keep user data only if the APK is signed with the same key
# and has a higher versionCode, so this refuses to build without the release keystore.
set -euo pipefail
cd "$(dirname "$0")/.."

ver=$(sed -n 's/^version: *\([^+]*\)+.*/\1/p' app/pubspec.yaml)
tag="v$ver"
[ "$(git rev-parse HEAD)" = "$(git rev-parse "$tag^{commit}" 2>/dev/null)" ] || { echo "HEAD is not tagged $tag; run scripts/version.sh" >&2; exit 1; }
[ -f app/android/key.properties ] || { echo "app/android/key.properties missing: a debug-signed APK cannot update an installed app" >&2; exit 1; }

(cd packages/core && dart test)
(cd cli && dart test)
(cd app && { flutter pub get --offline || flutter pub get; } && flutter test --no-pub && flutter build apk --no-pub --release --no-tree-shake-icons --split-per-abi)

rm -rf dist && mkdir dist
for abi in arm64-v8a armeabi-v7a; do
  cp "app/build/app/outputs/flutter-apk/app-$abi-release.apk" "dist/daftar-$ver-$abi.apk"
done

git push origin HEAD "$tag"
gh release create "$tag" dist/*.apk --title "Daftar $ver" --generate-notes
