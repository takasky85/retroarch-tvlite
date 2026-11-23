# RetroArch TV Lite

A slimmed-down RetroArch for Google TV and Android TV (Android 14), built
as a single 32-bit ARM (armeabi-v7a) APK. It installs beside the regular
RetroArch as `com.retroarch.tvlite`, named "RetroArch TV Lite".

## What is different from stock RetroArch

Left out of the build:

- Achievements (RetroAchievements)
- Cloud sync
- The online asset updater, and the manual thumbnail updater
- Every menu except Ozone (no XMB, Material UI or RGUI)
- Video and audio filters
- Recording and streaming (the record driver defaults to null)
- Every UI language except English
- Netplay LAN discovery and the network gamepad

Hidden from the menus:

- Netplay. Its code is still compiled, because in RetroArch it is welded
  to the networking that the core downloader and thumbnail downloads
  need. The Netplay menu entries, the netplay options in
  Settings > Network and the "show Netplay" visibility switch are gone.

Kept:

- The online core downloader and core info updater
- Automatic thumbnail download (on by default)
- The controller profile updater, plus the Android controller profiles
  bundled in the APK
- SMB and NFS network shares (Settings > Network)

Changed defaults:

- Ozone menu, touch overlay off, on every device
- Core info files: `/storage/emulated/0/RetroArch/info`
- Your own cores: `/storage/emulated/0/RetroArch/cores`
- Saves, states, system, playlists, thumbnails and the rest stay in
  `/storage/emulated/0/RetroArch`, as in stock RetroArch

## Remote, mouse, keyboard and gamepads

All of them work at once; use whichever is in your hand.

| Remote button | In the menu | In a game |
|---|---|---|
| D-pad | Move | D-pad |
| OK / Select | OK | RetroPad B (main button) |
| Back | Back | Open the menu |

Keyboard: Escape opens the menu (Android TV takes F1). Controller:
L1+R1 opens the menu.
| Channel Up | Start | Start |
| Channel Down | Select | Select |

The mouse drives the Ozone menu with its own cursor (always on in this
build); in a game it goes to the core. Main Menu always has Quit.

Missing core info files (the human-readable names in the core
downloader) are fetched automatically whenever the info folder is empty.

## How the cores folder works

Android will only load a core from the app's own private folder. Shared
storage is mounted so nothing on it can run, and RetroArch also refuses
any other location. So `/storage/emulated/0/RetroArch/cores` is where you
put cores, and on every start RetroArch copies any new or changed `.so`
file from there into its private cores folder, where it loads them from.
Cores from the online core downloader are installed in the private
folder and copied to the cores folder too, so they survive an
uninstall. Delete a core from Main Menu > Manage Cores, which removes
both copies.

A core you build yourself is not signed by libretro. Load it once from
Main Menu > Load Core and choose "Always Trust"; after that it also loads
from playlists.

## Storage permission

On first start RetroArch asks for "All files access". Without it,
everything falls back to the app's private folder. Some Google TV
devices hide that settings page; then grant it over adb:

    adb shell appops set --uid com.retroarch.tvlite MANAGE_EXTERNAL_STORAGE allow

## Building

    sh pkg/android/phoenix/tvlite-bundle-assets.sh
    cd pkg/android/phoenix
    ./gradlew assembleTvliteRelease    # or assembleTvliteDebug

The first script fetches the Ozone graphics, fonts, menu sounds and the
Android controller profiles into `pkg/android/phoenix/assets`, since the
APK has to carry them now that the asset updater is gone.

The build profile lives in `pkg/android/phoenix-common/jni/Android.mk`
(`RARCH_TV_LITE`) and `pkg/android/phoenix/build.gradle` (the `tvlite`
flavor).
