# Environment recreation kit — `x13` WSL2 dev box

**Purpose:** hand this directory (and the `~/.dotfiles` repo it references) to an
agent or a future you to rebuild this development environment from scratch on a
new Windows + WSL2 machine. It is a **runbook**, not an auto-installer — work
through it top to bottom; an agent can run the command blocks and adapt to
failures.

Built from **verified live state + curated memory** on **2026-06-27**. Things I
could not fully verify are called out in **§ Gaps** at the bottom — trust those
less.

---

## How to use this kit

1. Read this file first. It is the ordered checklist.
2. The actual config files (`.bashrc`, `init.vim`, …) are **not** inlined here —
   they live in the **`~/.dotfiles` bare repo** and get restored in Step 3.
3. Deep-dive docs live in `docs/`; each step links to its detail doc.
4. Two phases: **Phase A — Windows host (human/PowerShell)** then **Phase B —
   inside WSL (agent-runnable)**.

> **Already on this machine and just want to *change* the env (not rebuild)?**
> Use the **`/env-config`** slash command or spawn the **`env-config`** subagent
> (both in `~/.claude/`, tracked in the dotfiles repo). They pre-load this kit
> plus the known-pitfalls list so a session starts already knowing the
> environment — e.g. it won't reach for usbipd again.

## Machine baseline (what "done" looks like)

| | |
|---|---|
| Host | `x13` (ASUS laptop) |
| Platform | Windows + **WSL2**, kernel `…-microsoft-standard-WSL2` |
| Distro | **Ubuntu 24.04 LTS** |
| Default user / shell | `klee1` / **`/bin/bash`** (zsh installed but not the login shell) |
| Editor | Neovim **0.11.x** (pinned — see pins below) |
| JVM | SDKMAN: JDK **8.0.452-tem** + **21.0.7-tem** (21 default), Maven 3.3.9 |
| Node | nvm: **node 24.x** |
| External data | Seagate drive auto-mounted at `/mnt/external`; `~/projects` → `/mnt/external/projects` |

---

## ⚠️ Decisions & pins — get these wrong and it breaks

- **Neovim must stay on 0.11.x.** 0.12+ crashes the pinned `nvim-treesitter`
  *master* branch (`attempt to call method 'range' (a nil value)`). Do not
  upgrade nvim without first migrating treesitter to the `main` branch + its new
  setup API. See `docs/neovim.md`.
- **`nvim-treesitter` is pinned to the `master` branch** (not `main`) — the
  config uses the `nvim-treesitter.configs` API that `main` drops.
- **scfx builds REQUIRE JDK 8**, even though SDKMAN's default is 21. Set
  `JAVA_HOME` to `8.0.452-tem` for that build. See `docs/scfx.md`.
- **Python CLI tools are NOT installed via Mason/pip** — system Python is PEP 668
  externally-managed and `ensurepip` is broken. `ruff` is a standalone binary in
  `~/.local/bin`. See `docs/toolchains.md`.
- **`appendWindowsPath=false`** in `wsl.conf` — Windows `.exe`s are NOT on the
  WSL `$PATH`. Call them by full path (e.g.
  `/mnt/c/Windows/System32/.../powershell.exe`). See `docs/wsl-host.md`.
- **WSL needs `systemd=true`** (set in `wsl.conf`).
- **Never `dotfiles add -A`** — it would sweep in secrets. Add files explicitly.

---

## Phase A — Windows host (human / PowerShell, with admin)

1. Install WSL2 + Ubuntu 24.04: `wsl --install -d Ubuntu-24.04`. Create user
   `klee1`. Confirm WSL2 (`wsl -l -v` shows VERSION 2).
2. **External drive auto-mount** (Hyper-V `wsl --mount --bare`, keyed by serial):
   follow **`docs/external-drive.md`** → which points to the self-contained kit
   at `~/.local/share/usb-external-mount/` (script `C:\Scripts\mount-external.ps1`
   + scheduled task `WSL Mount External`, re-importable from
   `WSL-Mount-External.task.xml`). Skip if no external drive on the new box.

## Phase B — inside WSL (agent-runnable)

### Step 1 — `wsl.conf` + base apt packages
- Install `/etc/wsl.conf` (systemd, automount metadata, `appendWindowsPath=false`,
  default user). Full file + rationale in `docs/wsl-host.md`. Then `wsl --shutdown`
  from PowerShell and reopen.
- Base packages:
  ```bash
  sudo apt update && sudo apt install -y \
    build-essential curl git gh unzip zip \
    ripgrep fd-find fzf tealdeer htop \
    zsh hdparm ntfs-3g ufw python3-pip
  ```
  (Notes: `fd-find` ships the binary as `fdfind` → `.bashrc` aliases `fd=fdfind`.
  `fzf` is also re-installed by vim-plug for the nvim integration. `tealdeer` =
  `tldr`; `.bashrc` has a `tldr-update` workaround for a broken updater.)

### Step 2 — toolchains (SDKMAN, nvm, ruff)
Follow **`docs/toolchains.md`**. Summary:
- **SDKMAN** → `sdk install java 8.0.452-tem`, `sdk install java 21.0.7-tem`
  (default 21), `sdk install maven 3.3.9`.
- **nvm** → install nvm, then `nvm install 24`.
- **ruff** → astral standalone installer into `~/.local/bin/ruff` (NOT pip/Mason).
- **fzf** → the `~/.fzf.bash` integration (junegunn installer) if not using the
  apt one.

### Step 3 — shell / dotfiles
Follow **`docs/shell.md`**. Summary:
- Restore the bare-repo dotfiles (this also installs `.bashrc`/`.zshrc`/`.profile`/
  `.tmux.conf`/`init.vim`/`cheatsheet.md`/`tmux-profile`):
  ```bash
  # copy dotfiles-install.sh over first (it predates the repo), then:
  ./dotfiles-install.sh <git-remote-url-of-dotfiles>
  ```
  (Reference scripts live at `~/projects/dotfiles/`. **The dotfiles remote may
  not exist yet** — see `[[todo-dotfiles-backup]]`; until pushed, restore from a
  local copy of `~/.dotfiles` instead.)
- **tmux**: clone TPM (`~/.tmux/plugins/tpm`), open tmux, `prefix + I` to install
  plugins (tmux-resurrect, tmux-continuum). Prefix is **`C-a`**.

### Step 4 — Neovim
Follow **`docs/neovim.md`**. Summary:
- Install nvim **0.11.x** from the official tarball to `/opt/nvim-linux-x86_64`,
  symlink `/usr/local/bin/nvim`. **Do not** take 0.12.
- Install vim-plug, launch nvim, `:PlugInstall`.
- `:MasonInstall jdtls pyright` (jdtls is driven by the nvim-jdtls FileType
  autocmd; pyright via mason-lspconfig). Run `:checkhealth`.
- Optional: `sudo apt install wslu` (gives `wslview` so `gx` opens URLs).

### Step 5 — projects
- `~/projects` is a symlink to `/mnt/external/projects` (created once the drive
  mounts). scfx build specifics: **`docs/scfx.md`**.

---

## Verification checklist

```bash
nvim --version | head -1            # v0.11.x  (NOT 0.12)
sdk current java                    # 21.x default; 8.x also installed
java -version                       # 21
node -v                             # v24.x
ruff --version                      # present, from ~/.local/bin
fzf --version ; rg --version ; fdfind --version
mountpoint -q /mnt/external && echo external-OK
git --git-dir=$HOME/.dotfiles --work-tree=$HOME status   # dotfiles tracked
# In nvim:  :checkhealth   then open a .java file -> jdtls attaches (one client)
```

## Gaps — verify on rebuild, trusted less

- **Dotfiles remote doesn't exist yet** (`[[todo-dotfiles-backup]]`): until the
  push happens, "restore from remote" can't run — copy `~/.dotfiles` manually.
- **`~/.m2` orphaned scfx artifacts** are hand-installed and machine-local (not
  backed up anywhere) — see `docs/scfx.md`; rebuilding scfx requires re-installing
  them.
- **Not captured / out of scope:** exact `ufw` rules, any WireGuard/VPN config
  (the usb memory notes a WSL-subnet exclusion), `~/.gitconfig`, the full apt set
  beyond the list above, Windows OS version.
- **Deliberately excluded (secrets):** `~/.ssh`, `~/.config/gh` token, `~/.aws`,
  `~/.netrc`. Recreate these by hand.
- Built from live state + memory (no transcript mining), so undocumented one-off
  tweaks from past sessions may be missing.
