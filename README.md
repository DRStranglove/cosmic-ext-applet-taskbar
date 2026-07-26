# COSMIC Taskbar Applet

A **Windows-style taskbar** applet for the [COSMIC desktop](https://system76.com/cosmic)
(Pop!_OS 24.04+). Instead of grouping windows by application like the stock app
list, it shows **one labeled button per open window** — icon + title — so you can
see and reach every window at a glance.

> A taskbar with three open windows looks like:
> `[🖥 Fix taskbar wi…] [🦊 #19250 - Prot…] [💬 Karere]`
> — each an icon + ellipsized title; hover for the full title.

## Features

- **One button per window**, not one per app — no hidden windows behind a grouped icon.
- **Icon + title label**, Windows 7+ style. Empty-title windows (e.g. RustDesk) fall
  back to the application name so every button is labeled.
- **Click to focus, click again to minimize.**
- **Uniform, elastic buttons** with end-ellipsis (`Long window titl…`): every button
  is the same width, and they shrink together as more windows open instead of the
  bar growing ragged.
- **Hover tooltip** shows the full, untruncated window title.
- **Overflow handling**: buttons shrink first, and once titles would get too short
  to read, the extra windows fold into a popup behind a chevron (`⌃`) button —
  nothing is ever dropped or pushed off the end of the panel.
- Right-click for the per-window context menu; works on any panel edge (labels on
  horizontal panels, icon-only on vertical).

## Requirements

- COSMIC desktop (Pop!_OS 24.04 or another COSMIC distro).
- A Rust toolchain (`rustup`) and build dependencies:

  ```sh
  # Debian/Pop!_OS/Ubuntu
  sudo apt install pkg-config libxkbcommon-dev libwayland-dev libinput-dev \
                   libgbm-dev libpixman-1-dev libssl-dev just
  # Rust, if you don't have it
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  ```

## Build & install

```sh
git clone https://github.com/DRStranglove/cosmic-ext-applet-taskbar.git
cd cosmic-ext-applet-taskbar
./install.sh
```

`install.sh` builds in release mode and installs to your user directories
(no root needed):

- binary  → `~/.local/bin/cosmic-ext-applet-taskbar`
- desktop → `~/.local/share/applications/com.cosmicext.Taskbar.desktop`

The first build compiles libcosmic from source and takes ~10–15 minutes.

**Upgrading?** The panel keeps running the old binary until it is restarted:

```sh
kill "$(pgrep -x cosmic-panel)"   # cosmic-session respawns it immediately
```

## Add it to your panel

1. **Settings → Desktop → Panel** (or **Dock**) → **Configure applets**.
2. **＋ Add applet → Taskbar**.
3. Drag it where you want, and **remove the stock "App Tray"** from the same bar
   so you don't see grouped icons *and* per-window buttons at once.

If "Taskbar" doesn't appear in the picker right away, close and reopen Settings.

## Uninstall

```sh
./uninstall.sh
```

Then remove it from the bar in Settings.

## Notes & caveats

- **libcosmic's API is unstable.** The dependency revisions in `Cargo.toml` are
  pinned to what this was built against. A future COSMIC update may require
  bumping those revs and fixing minor fallout — PRs welcome.
- Applets can't run standalone; launching the binary directly just prints a
  Wayland "Bad file descriptor" error. That's expected — it must be hosted by the
  COSMIC panel.
- System-tray icons (RustDesk, chat apps, etc.) are separate from the taskbar and
  live in the panel's status area; this applet doesn't manage them.

## Credits & license

This is a fork of the **App List** applet from
[pop-os/cosmic-applets](https://github.com/pop-os/cosmic-applets), reworked to
render per-window buttons. Huge thanks to System76 and the COSMIC contributors.

Licensed under **GPL-3.0-only**, same as the upstream applet. See [LICENSE](LICENSE).
