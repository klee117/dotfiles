# Toolchains

## SDKMAN (Java + Maven)
Install SDKMAN (`curl -s https://get.sdkman.io | bash`), then:
```bash
sdk install java 8.0.452-tem      # required by scfx (see scfx.md)
sdk install java 21.0.7-tem       # default; runs jdtls, general dev
sdk default java 21.0.7-tem
sdk install maven 3.3.9           # scfx is verified on 3.3.9
```
- `~/.sdkman/candidates/java/` ends up with both `8.0.452-tem` and `21.0.7-tem`.
- **`mvn` resolves to the SDKMAN `current` Maven (3.3.9)** — not a system apt
  maven. (An older memory called it "system"; it's SDKMAN.)
- SDKMAN init **must be the last block in `.bashrc`**.
- nvim's jdtls launcher discovers these JDKs dynamically by glob
  (`~/.sdkman/candidates/java/8.*` and `21.*`), so patch upgrades don't break it.

## nvm (Node)
Install nvm, then:
```bash
nvm install 24       # currently node v24.x
```
`.bashrc` sources `$NVM_DIR/nvm.sh`. Used by some nvim plugins
(`markdown-preview.nvim` runs `npm install`; `LuaSnip` builds `jsregexp`).

## Python tooling — IMPORTANT constraint
System Python on Ubuntu 24.04 is **PEP 668 externally-managed** and `ensurepip`
is broken, so **Mason cannot install Python tools** (`:MasonInstall ruff` fails
`spawn: python3 failed`). Installing `python3-pip` does **not** fix it.

- **ruff** is installed as a **standalone binary** via the astral.sh installer
  into `~/.local/bin/ruff` (which `.bashrc` and `init.vim` put on PATH). It drives
  conform.nvim format-on-save for Python.
  ```bash
  curl -LsSf https://astral.sh/ruff/install.sh | sh
  ```
- For other Python CLI tools (black, debugpy, …) use the same standalone/pipx
  approach into `~/.local/bin`, **not** Mason. (To unlock the Mason route you'd
  need `sudo apt install python3.12-venv` for a working `ensurepip`.)

## apt packages (manually installed, the notable ones)
```
build-essential curl git gh unzip zip
ripgrep fd-find fzf tealdeer htop
zsh hdparm ntfs-3g ufw python3-pip
```
- `fd-find` → binary is `fdfind`; `.bashrc` aliases `fd=fdfind`.
- `tealdeer` → the `tldr` command; `.bashrc` has a `tldr-update` workaround.
- `fzf` is here via apt **and** re-installed by vim-plug for the nvim
  integration; `.bashrc` sources `~/.fzf.bash` (junegunn installer) for shell
  keybindings.
- `gh` is the GitHub CLI (used for repos/PRs).
