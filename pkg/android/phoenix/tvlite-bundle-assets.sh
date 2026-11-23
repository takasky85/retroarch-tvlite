#!/bin/sh
# TV Lite: fills pkg/android/phoenix/assets with what the build ships
# inside the APK, since the online asset updater is left out.
#
#   Ozone menu graphics and fonts      -> assets/ozone
#   System icons Ozone borrows         -> assets/xmb/monochrome/png
#   Fallback and on-screen fonts       -> assets/pkg
#   Menu sounds                        -> assets/sounds
#   Android gamepad and remote profiles -> autoconfig
#
# RetroArch unpacks the APK's assets/ folder into its app folder on the
# first start after each install or upgrade.
#
# Usage: sh tvlite-bundle-assets.sh [assets-checkout] [autoconfig-checkout]
# Without arguments it shallow-clones both repositories into a temporary
# folder.
set -eu

here=$(cd "$(dirname "$0")" && pwd)
out="$here/assets"
work=""

cleanup() { [ -n "$work" ] && rm -rf "$work"; }
trap cleanup EXIT

assets_src=${1:-}
autoconf_src=${2:-}

if [ -z "$assets_src" ] || [ -z "$autoconf_src" ]; then
   work=$(mktemp -d)
fi
if [ -z "$assets_src" ]; then
   git clone -q --depth 1 https://github.com/libretro/retroarch-assets.git \
      "$work/retroarch-assets"
   assets_src="$work/retroarch-assets"
fi
if [ -z "$autoconf_src" ]; then
   git clone -q --depth 1 https://github.com/libretro/retroarch-joypad-autoconfig.git \
      "$work/retroarch-joypad-autoconfig"
   autoconf_src="$work/retroarch-joypad-autoconfig"
fi

rm -rf "$out"
mkdir -p "$out/assets/xmb/monochrome" "$out/assets/pkg" "$out/autoconfig"

cp -R "$assets_src/ozone"              "$out/assets/ozone"
cp -R "$assets_src/xmb/monochrome/png" "$out/assets/xmb/monochrome/png"
cp -R "$assets_src/sounds"             "$out/assets/sounds"
cp    "$assets_src/pkg/fallback-font.ttf" \
      "$assets_src/pkg/osd-font.ttf"   "$out/assets/pkg/"
cp -R "$autoconf_src/android"          "$out/autoconfig/android"

# Sources only, not needed at run time
find "$out" \( -name '*.svg' -o -name '*.md' -o -name 'Makefile' \) -type f -delete

du -sh "$out"
