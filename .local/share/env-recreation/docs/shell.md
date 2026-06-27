# Shell / dotfiles

Default login shell is **bash** (`/bin/bash`). `zsh` is installed and `.zshrc` is
tracked, but it is not the login shell. Configs are managed with a **bare-repo
dotfiles tracker** — no symlinks; git tracks files in place.

## Bare-repo dotfiles model

- Repo: `~/.dotfiles` (bare). Work tree: `$HOME`.
- Alias (in `.bashrc`): `dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'`.
- `status.showUntrackedFiles no` keeps the rest of `$HOME` out of `status`.
- **Tracked files:** `.bashrc`, `.zshrc`, `.profile`, `.tmux.conf`,
  `.config/nvim/init.vim`, `.config/nvim/cheatsheet.md`, `.local/bin/tmux-profile`
  — plus this kit and the usb kit under `.local/share/`.
- **⚠️ Never `dotfiles add -A`** (would sweep in secrets). Add explicitly only.
  Do **not** track `~/.ssh`, `~/.config/gh`, `~/.aws`, `~/.netrc`, `~/.sdkman`,
  `~/.nvm`, or the rest of `~/.local/share`.

### Reference scripts (`~/projects/dotfiles/`, on the external drive)
- `dotfiles-init.sh` — one-time setup on a machine: `git init --bare ~/.dotfiles`,
  set `showUntrackedFiles no`, add the alias, add the curated files, first commit.
- `dotfiles-install.sh <remote-url>` — fresh-machine restore: clone bare, then
  `checkout` into `$HOME` (backs up any colliding files to `~/.dotfiles-backup`).
- These scripts live beyond a `$HOME` symlink so they're **not** tracked — copy
  `dotfiles-install.sh` over manually before the repo exists.

### Restore on a new machine
```bash
# 1. If a remote exists (see [[todo-dotfiles-backup]] — push is still pending):
./dotfiles-install.sh <git-remote-url>
# 2. If no remote yet: copy ~/.dotfiles from a backup, then:
git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout
# open a new shell so the alias loads
```

## What `.bashrc` sets up (highlights)
- `PATH` prepends `~/.local/bin` (so standalone `ruff` is found).
- **nvm** init (`$NVM_DIR=~/.nvm`).
- **SDKMAN** init — **must be the last lines of the file**.
- `set -o vi` + cursor-shape mode strings; `EDITOR=nvim`.
- `~/.fzf.bash` sourced (fzf keybindings/completion).
- Auto-`cd ~` when a shell opens in `/mnt/c/*`.
- Aliases: `3claw` (tmux profile), `fd=fdfind`, `dotfiles`, `new-funding-juno`,
  ls family. Functions: `fdo` (fzf file/dir picker), `tldr-update` (manual tldr
  cache refresh — the 1.6.1 updater is broken), `manage_limit`.
- Some aliases/functions point at project scripts under `~/projects/...` (on the
  external drive): `new-funding-juno`, `manage_limit`, etc. — they only work once
  the drive is mounted.

## tmux

- Prefix remapped to **`C-a`** (from `C-b`). vi copy-mode.
- **vim-tmux-navigator** integration (`C-h/j/k/l` move between vim splits and
  tmux panes, fzf-aware).
- **WSL2 clipboard:** copy-mode yank pipes to `clip.exe`.
- **TPM** plugin manager at `~/.tmux/plugins/tpm`; plugins: **tmux-resurrect** +
  **tmux-continuum** (session save/restore). On a fresh machine:
  ```bash
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  tmux            # then press  C-a  then  I   to install plugins
  ```
- `~/.local/bin/tmux-profile` — launches named layouts. The `3claw` profile opens
  windows running `claude` on different models (sonnet/opus/haiku) + htop.
  Invoked via the `3claw` alias.
