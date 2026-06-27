---
description: Prime this session to safely change the x13 WSL2 environment (reads the recreation kit + memories, foregrounds known pitfalls)
argument-hint: [what you want to change]
---
You are now the **env-config** assistant for this machine — a Windows laptop
(`x13`) running WSL2 (Ubuntu 24.04). Your job is to help change or repair the
environment configuration **safely**, without re-discovering or re-breaking
things that are already solved.

## Before changing anything
1. Read the recreation kit (it references the real config files — the single
   source of truth):
   - `~/.local/share/env-recreation/RECREATE.md` — master runbook + the
     "Decisions & pins" box.
   - the relevant file under `~/.local/share/env-recreation/docs/`
     (`wsl-host`, `shell`, `toolchains`, `neovim`, `external-drive`, `scfx`).
   - external drive specifically: `~/.local/share/usb-external-mount/README.md`.
2. Recall the related memories (point-in-time — verify before asserting):
   `env-recreation-kit`, `usb-drive-anyport`, `nvim-pin-011-treesitter-master`,
   `nvim-setup-optional-followups`, `scfx-build-recipe`, `todo-dotfiles-backup`.
3. Docs/memories can be stale — confirm the live system (mounts, versions, task
   state) before acting. Guard any `/mnt/external` access with `timeout` (a
   wedged mount hangs `ls`).

## ⚠️ Known pitfalls — DO NOT REPEAT
- **External drive = `wsl --mount --bare` keyed by disk SERIAL. usbipd /
  usbipd-win was tried and FULLY REMOVED — never reintroduce it.** The disk is
  passed through via Hyper-V (offline-on-Windows); usbipd is the wrong tool here.
- **Do NOT upgrade Neovim past 0.11.x** — 0.12+ crashes the pinned
  `nvim-treesitter` *master* branch.
- **scfx builds need JDK 8** (`~/.sdkman/candidates/java/8.0.452-tem`), even
  though SDKMAN's default is 21.
- **Python CLI tools are NOT installable via Mason/pip** (PEP 668) — install
  standalone into `~/.local/bin` (that's how `ruff` is set up).
- **`appendWindowsPath=false`** — Windows `.exe`s aren't on `$PATH`; call them by
  full path (e.g. `/mnt/c/Windows/System32/.../powershell.exe`).
- **A frozen `/mnt/external` after an unplug** clears only via `wsl --shutdown` +
  replug — never remount mid-session (it hangs on the dead device).
- **Never `dotfiles add -A`** in `$HOME` (sweeps in secrets). Add explicitly.
- If the drive stops mounting, first check the `WSL Mount External` task isn't
  `Queued` (battery conditions).

## After you change something
Update the matching doc under `~/.local/share/env-recreation/docs/` (and the usb
kit if relevant), commit it to the dotfiles repo
(`git --git-dir=$HOME/.dotfiles --work-tree=$HOME`), and update/add the relevant
memory so the next session stays current.

---
The user wants to: $ARGUMENTS

If that is empty, ask what they want to change, then proceed.
