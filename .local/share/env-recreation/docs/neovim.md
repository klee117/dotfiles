# Neovim

Config is a single `~/.config/nvim/init.vim` (vimscript with an embedded
`lua << EOF` block) — tracked in the dotfiles repo. Keymap cheatsheet at
`~/.config/nvim/cheatsheet.md` (`<leader>?` opens it; leader is `,`).

## ⚠️ Version pin — stay on 0.11.x
Currently **v0.11.7**. **Do not upgrade to 0.12+** without first migrating
`nvim-treesitter`:
- `nvim-treesitter` is pinned to the **`master`** branch (`init.vim`), which
  explicitly does **not** support nvim 0.12 — running 0.12 throws
  `attempt to call method 'range' (a nil value)` from the treesitter highlighter
  on every buffer.
- master is pinned deliberately: the `main` rewrite drops the
  `require('nvim-treesitter.configs').setup{...}` API the config uses.
- To go to 0.12+ you must move treesitter to `main` AND rewrite the setup
  (parsers via `install()`, highlight via `vim.treesitter.start()` in a FileType
  autocmd).

### Install method
Official tarball extracted to `/opt/nvim-linux-x86_64`, symlinked
`/usr/local/bin/nvim → /opt/nvim-linux-x86_64/bin/nvim`. (A prior 0.12.3 upgrade
broke things and was rolled back; backup kept at `/opt/nvim-0.12.3.bak`.)
```bash
# fetch the 0.11.x linux tarball, then:
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
```

## Plugin manager — vim-plug
`~/.local/share/nvim/site/autoload/plug.vim`. Install it, then `:PlugInstall`.
```bash
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim \
  --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```
Migrating to lazy.nvim is a **deferred, low-priority** todo (`[[nvim-plugin-manager-lazy-todo]]`)
— don't, unless a lockfile/reproducible config is wanted.

> Note: the live `plugged/` dir has two **stale** plugins not in `init.vim`
> (`gruvbox`, `ultisnips`) — leftovers; `:PlugClean` removes them. A fresh
> `:PlugInstall` installs exactly what `init.vim` declares.

## Plugins (declared in init.vim)
fzf + fzf.vim + fzf-lua · vim-solarized8 (light bg) · lightline · LuaSnip ·
splitjoin · vim-tmux-navigator · **mason.nvim + mason-lspconfig + nvim-lspconfig
+ nvim-jdtls** · nvim-cmp (+ cmp-nvim-lsp/buffer/path, cmp_luasnip) ·
**nvim-treesitter (master)** · vim-fugitive + gitsigns · nvim-tree (+ web-devicons)
· conform.nvim · which-key · nvim-autopairs · trouble.nvim · markdown-preview.

## LSP servers via Mason
```
:MasonInstall jdtls pyright
```
- **pyright** (Python / tradeflow-query): enabled via `mason-lspconfig`
  `ensure_installed`. Auto-detects a project-local `.venv/bin/python`.
- **jdtls** (Java / scfx): driven by the **nvim-jdtls FileType autocmd**, NOT by
  mason-lspconfig (which is told `automatic_enable = { exclude = { "jdtls" } }`
  to avoid a duplicate second Java client). Notable jdtls wiring in `init.vim`:
  - Climbs to the **topmost `pom.xml`** (the Maven aggregator) for `root_dir`, so
    a multi-module reactor like scfx imports as one project, not per-module.
  - Runs jdtls on **JDK 21**; registers JavaSE-1.8 + JavaSE-21 runtimes (JDK
    paths discovered by glob under `~/.sdkman/candidates/java/`).
  - Per-project workspace under `~/.local/share/nvim/jdtls-workspace/`.
- Python tools are **not** Mason-installable here (PEP 668) — see
  `toolchains.md`. `ruff` (standalone) drives conform.nvim format-on-save for
  Python; Java is left to manual `<leader>lf` (jdtls) to avoid huge legacy diffs.

## Optional / deferred
- `sudo apt install wslu` → provides `wslview` so `gx` (open URL/file under
  cursor) works. Not installed; nothing depends on it (`[[nvim-setup-optional-followups]]`).

## Verify
`:checkhealth`, then open a `.java` file in an scfx module → exactly **one**
jdtls client attaches; open a `.py` file → pyright attaches and `:w` runs ruff.
