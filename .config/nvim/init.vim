call plug#begin(stdpath('data') . '/plugged')

" ── Existing ──────────────────────────────────────────────────────────
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'lifepillar/vim-solarized8'
Plug 'itchyny/lightline.vim'
Plug 'L3MON4D3/LuaSnip', {'tag': 'v2.*', 'do': 'make install_jsregexp'}
Plug 'AndrewRadev/splitjoin.vim'
Plug 'christoomey/vim-tmux-navigator'

" ── LSP & server installer ────────────────────────────────────────────
Plug 'williamboman/mason.nvim'           " installs LSP servers / formatters
Plug 'williamboman/mason-lspconfig.nvim' " bridges mason ↔ lspconfig
Plug 'neovim/nvim-lspconfig'
Plug 'mfussenegger/nvim-jdtls'          " Java LSP (needs special launcher)

" ── Autocompletion ────────────────────────────────────────────────────
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'saadparwaiz1/cmp_luasnip'

" ── Syntax ────────────────────────────────────────────────────────────
" Pinned to master: the `main` rewrite drops the nvim-treesitter.configs API
" and requires the tree-sitter CLI; master compiles parsers with gcc.
Plug 'nvim-treesitter/nvim-treesitter', {'branch': 'master', 'do': ':TSUpdate'}

" ── Git ───────────────────────────────────────────────────────────────
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'

" ── File tree ─────────────────────────────────────────────────────────
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'

" ── Formatting (format-on-save) ───────────────────────────────────────
Plug 'stevearc/conform.nvim'

" ── FZF Lua (LSP symbol picker, etc.) ───────────────────────────────
Plug 'ibhagwan/fzf-lua'

" ── Keymap discovery popup ────────────────────────────────────────────
Plug 'folke/which-key.nvim'

" ── Editing QoL ───────────────────────────────────────────────────────
Plug 'windwp/nvim-autopairs'

" ── Diagnostics / references panel ────────────────────────────────────
Plug 'folke/trouble.nvim'

call plug#end()

""""""""""""""""""""""
"      Settings      "
""""""""""""""""""""""
" Disable unused providers
let g:loaded_python3_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0

filetype plugin indent on
set laststatus=2
set autoread
set autoindent
set backspace=indent,eol,start
set incsearch
set hlsearch
set noerrorbells
set number
set relativenumber              " relative line numbers help with j/k jumps
set showcmd
set noswapfile
set nobackup
set splitright
set splitbelow
set autowrite
set hidden
set fileformats=unix,dos,mac
set noshowmatch
set noshowmode
set ignorecase
set smartcase
set completeopt=menu,menuone,noselect   " noselect needed for nvim-cmp
set pumheight=10
set nocursorcolumn
set cursorline
set timeoutlen=1000
set ttimeoutlen=10
set signcolumn=yes              " always show sign column so diagnostics don't shift text
set scrolloff=8                 " keep 8 lines of context above/below the cursor

" Python indent (tradeflow-query)
autocmd FileType python setlocal expandtab shiftwidth=4 softtabstop=4

" Java indent (scfx)
autocmd FileType java setlocal expandtab shiftwidth=4 softtabstop=4

" Clipboard
set clipboard^=unnamed,unnamedplus

" Persistent undo
set undofile
set undodir=~/.local/share/nvim/undo//

" Colorscheme
set termguicolors
set background=light
colorscheme solarized8

" Cursor shape
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20

" Cursorline: amber in normal, blue in insert
highlight CursorLine ctermbg=58 cterm=none
autocmd InsertEnter * highlight CursorLine ctermbg=23 cterm=none
autocmd InsertLeave * highlight CursorLine ctermbg=58 cterm=none

""""""""""""""""""""""
"      Mappings      "
""""""""""""""""""""""
let mapleader = ","

" fzf
nnoremap <leader>f :Files<CR>
nnoremap <leader>g :Rg<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>p :History<CR>
nnoremap <leader>/ :BLines<CR>
nnoremap <leader>j :GFiles<CR>

let g:fzf_vim = {}

" Quickfix navigation
" Note: <C-m> is the same byte as <CR>, so mapping it would hijack the Enter
" key. Use <C-p> for :cprevious instead (pairs naturally with <C-n>).
nnoremap <C-n> :cnext<CR>
nnoremap <C-p> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

" Visual linewise up and down
noremap <Up> gk
noremap <Down> gj
noremap j gj
noremap k gk

" Center search results
nnoremap n nzzzv
nnoremap N Nzzzv

" Act like D and C
nnoremap Y y$

" File tree
nnoremap <leader>e :NvimTreeToggle<CR>
nnoremap <leader>E :NvimTreeFindFile<CR>

" Git (fugitive) — capital G prefix so it doesn't shadow <leader>g (grep)
nnoremap <leader>Gs :Git<CR>
nnoremap <leader>Gb :Git blame<CR>
nnoremap <leader>Gd :Git diff<CR>
nnoremap <leader>Gl :Git log --oneline -20<CR>

" Diagnostics navigation
nnoremap <leader>d :lua vim.diagnostic.open_float()<CR>
nnoremap [d :lua vim.diagnostic.goto_prev()<CR>
nnoremap ]d :lua vim.diagnostic.goto_next()<CR>

" LSP symbols
nnoremap <leader>s :FzfLua lsp_document_symbols<CR>

" Trouble (diagnostics / references panel)
nnoremap <leader>xx :Trouble diagnostics toggle<CR>
nnoremap <leader>xX :Trouble diagnostics toggle filter.buf=0<CR>
nnoremap <leader>xr :Trouble lsp_references toggle<CR>
nnoremap <leader>xs :Trouble symbols toggle<CR>
nnoremap <leader>xq :Trouble qflist toggle<CR>

" Cheatsheet
nnoremap <leader>? :e ~/.config/nvim/cheatsheet.md<CR>

" Open a file relative to the current file's directory (without changing cwd,
" so :Files/:Rg/nvim-tree stay scoped to the project root)
nnoremap <leader>o :e <C-r>=expand('%:h').'/'<CR>

""""""""""""""""""""""
"      Plugins       "
""""""""""""""""""""""

lua << EOF

-- ── fzf-lua ───────────────────────────────────────────────────────────
local fzflua_ok, fzflua = pcall(require, "fzf-lua")
if fzflua_ok then
  fzflua.setup({})
end

-- ── Ensure user-local bins (e.g. standalone ruff) are on PATH ─────────
do
  local local_bin = vim.fn.expand("~/.local/bin")
  if not string.find(vim.env.PATH or "", local_bin, 1, true) then
    vim.env.PATH = local_bin .. ":" .. (vim.env.PATH or "")
  end
end

-- ── Mason (LSP server installer) ──────────────────────────────────────
local mason_ok, mason = pcall(require, "mason")
if mason_ok then
  mason.setup()
end

local mason_lsp_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if mason_lsp_ok then
  mason_lspconfig.setup({
    ensure_installed = { "pyright" },
    -- jdtls is driven by nvim-jdtls (the FileType autocmd below). Stop
    -- mason-lspconfig from also auto-enabling the stock lspconfig jdtls,
    -- which the healthcheck showed starting a second, duplicate Java client.
    automatic_enable = { exclude = { "jdtls" } },
  })
end

-- ── Shared LSP on_attach (keymaps for every LSP) ──────────────────────
local function on_attach(_, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gd",         vim.lsp.buf.definition,      opts)
  vim.keymap.set("n", "gD",         vim.lsp.buf.declaration,     opts)
  vim.keymap.set("n", "gr",         vim.lsp.buf.references,      opts)
  vim.keymap.set("n", "gi",         vim.lsp.buf.implementation,  opts)
  vim.keymap.set("n", "K",          vim.lsp.buf.hover,           opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,          opts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,     opts)
  vim.keymap.set("n", "<leader>lf", function()
    require("conform").format({ async = true, lsp_format = "fallback" })
  end, opts)
end

-- ── nvim-cmp (autocompletion) ─────────────────────────────────────────
local cmp_ok, cmp = pcall(require, "cmp")
local snip_ok, luasnip = pcall(require, "luasnip")

if cmp_ok and snip_ok then
  cmp.setup({
    snippet = {
      expand = function(args) luasnip.lsp_expand(args.body) end,
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"]     = cmp.mapping.abort(),
      ["<CR>"]      = cmp.mapping.confirm({ select = false }),
      ["<C-j>"]     = cmp.mapping.select_next_item(),
      ["<C-k>"]     = cmp.mapping.select_prev_item(),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "buffer" },
      { name = "path" },
    }),
  })
end

-- ── LSP capabilities (tells servers what cmp supports) ────────────────
local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_lsp_ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if cmp_lsp_ok then
  capabilities = cmp_lsp.default_capabilities()
end

-- ── Python LSP (tradeflow-query) ──────────────────────────────────────
-- Uses new nvim 0.11+ API (vim.lsp.config / vim.lsp.enable).
-- Auto-detects a project-local .venv from nvim — no file needed in the repo.
vim.lsp.config("pyright", {
  on_attach    = on_attach,
  capabilities = capabilities,
  before_init = function(params, config)
    local root = params.rootPath or vim.fn.getcwd()
    local venv_python = root .. "/.venv/bin/python"
    if vim.fn.executable(venv_python) == 1 then
      config.settings = config.settings or {}
      config.settings.python = config.settings.python or {}
      config.settings.python.pythonPath = venv_python
    end
  end,
  settings = {
    python = {
      analysis = {
        autoSearchPaths        = true,
        useLibraryCodeForTypes = true,
        diagnosticMode         = "openFilesOnly",
      },
    },
  },
})
vim.lsp.enable("pyright")

-- ── Java LSP (scfx) ───────────────────────────────────────────────────
-- nvim-jdtls needs the Eclipse JDT launcher jar — installed via Mason:
--   :MasonInstall jdtls
-- Workspace is per-project (stored in ~/.local/share/nvim/jdtls-workspace/).
vim.api.nvim_create_autocmd("FileType", {
  pattern  = "java",
  callback = function()
    local jdtls      = require("jdtls")
    local mason_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
    -- Derive the workspace from the project root (not cwd) so the `lcd`
    -- autocmd above can't fragment the index across a file's subdirectories.
    -- scfx is a multi-module Maven reactor: every module has its own pom.xml,
    -- so find_root() would stop at the *nearest* one and import the module in
    -- isolation, breaking cross-module + parent-managed dependency resolution.
    -- Climb to the *topmost* pom.xml (the aggregator) instead.
    local function reactor_root()
      local dir = vim.fn.expand("%:p:h")
      -- Non-file buffers (e.g. the jdt:// library sources `gd` opens) aren't
      -- absolute paths; walking them with :h converges to "." not "/", which
      -- would spin forever. Bail and let find_root handle those buffers.
      if dir:sub(1, 1) ~= "/" then return nil end
      local root, prev = nil, nil
      while dir ~= "/" and dir ~= prev do
        if vim.fn.filereadable(dir .. "/pom.xml") == 1 then root = dir end
        prev, dir = dir, vim.fn.fnamemodify(dir, ":h")
      end
      return root
    end
    local root_dir   = reactor_root() or jdtls.setup.find_root({ "pom.xml", ".git" }) or vim.fn.getcwd()
    local project    = vim.fn.fnamemodify(root_dir, ":p:h:t")
    local workspace  = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project

    local launcher = vim.fn.glob(
      mason_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"
    )

    if launcher == "" then
      vim.notify("jdtls not found — run :MasonInstall jdtls", vim.log.levels.WARN)
      return
    end

    -- SDKMAN-installed JDKs (detected dynamically so patch upgrades don't break):
    --   jdtls itself must run on JDK 21; scfx (Java 1.7) is analyzed with the 1.8 runtime.
    local function sdkman_java(prefix)
      local hits = vim.fn.glob(
        vim.fn.expand("~/.sdkman/candidates/java/" .. prefix .. "*"), false, true)
      return hits[1]
    end
    local java8    = sdkman_java("8.")
    local java21   = sdkman_java("21.")
    local java_bin = (java21 and (java21 .. "/bin/java")) or "java"

    local java_runtimes = {}
    if java8 then
      table.insert(java_runtimes, { name = "JavaSE-1.8", path = java8 })
    end
    if java21 then
      table.insert(java_runtimes, { name = "JavaSE-21", path = java21, default = true })
    end

    jdtls.start_or_attach({
      cmd = {
        java_bin,
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.level=ALL",
        "-Xmx2g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens", "java.base/java.util=ALL-UNNAMED",
        "--add-opens", "java.base/java.lang=ALL-UNNAMED",
        "-jar", launcher,
        "-configuration", mason_path .. "/config_linux",
        "-data", workspace,
      },
      root_dir = root_dir,
      settings = {
        java = {
          eclipse        = { downloadSources = true },
          maven          = { downloadSources = true },
          referencesCodeLens    = { enabled = true },
          implementationsCodeLens = { enabled = true },
          signatureHelp  = { enabled = true },
          contentProvider = { preferred = "fernflower" },
          configuration  = { runtimes = java_runtimes },
        },
      },
      on_attach    = on_attach,
      capabilities = capabilities,
    })
  end,
})

-- ── Diagnostics display (inline virtual text, rounded float, sorted) ──
vim.diagnostic.config({
  virtual_text     = { spacing = 2, prefix = "●" },
  signs            = true,
  underline        = true,
  update_in_insert = false,   -- don't churn diagnostics while typing
  severity_sort    = true,    -- errors above warnings in the gutter/float
  float            = { border = "rounded", source = true },
})

-- ── Treesitter (syntax highlighting + code navigation) ────────────────
local ts_ok, treesitter = pcall(require, "nvim-treesitter.configs")
if ts_ok then
  treesitter.setup({
    ensure_installed = { "python", "java", "lua", "json", "yaml", "sql", "html", "javascript" },
    highlight        = { enable = true },
    indent           = { enable = true },
  })
end

-- ── Gitsigns (inline git change indicators) ───────────────────────────
local gs_ok, gitsigns = pcall(require, "gitsigns")
if gs_ok then
gitsigns.setup({
  signs = {
    add          = { text = "▎" },
    change       = { text = "▎" },
    delete       = { text = "▁" },
    topdelete    = { text = "▔" },
    changedelete = { text = "▎" },
  },
  on_attach = function(bufnr)
    local gs   = package.loaded.gitsigns
    local opts = { buffer = bufnr }
    vim.keymap.set("n", "]h", gs.next_hunk,    opts)
    vim.keymap.set("n", "[h", gs.prev_hunk,    opts)
    vim.keymap.set("n", "<leader>hs", gs.stage_hunk,   opts)
    vim.keymap.set("n", "<leader>hr", gs.reset_hunk,   opts)
    vim.keymap.set("n", "<leader>hp", gs.preview_hunk, opts)
    vim.keymap.set("n", "<leader>hb", gs.blame_line,   opts)
  end,
})
end

-- ── nvim-tree (file explorer) ─────────────────────────────────────────
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1

local tree_ok, nvim_tree = pcall(require, "nvim-tree")
if tree_ok then
nvim_tree.setup({
  view = { width = 35 },
  renderer = {
    group_empty = true,
    icons = { show = { git = true, file = true, folder = true } },
  },
  filters = { dotfiles = false },
  git     = { enable = true, ignore = false },
})
end

-- ── conform.nvim (formatting + format-on-save) ────────────────────────
local conform_ok, conform = pcall(require, "conform")
if conform_ok then
  conform.setup({
    formatters_by_ft = {
      python = { "ruff_format", "ruff_organize_imports" },
    },
    -- Format-on-save for Python only. The scfx Java codebase is legacy and
    -- shared; auto-reformatting it would create huge diffs, so Java is left
    -- to manual <leader>lf (jdtls) instead.
    format_on_save = function(bufnr)
      if vim.bo[bufnr].filetype == "python" then
        return { timeout_ms = 2000, lsp_format = "never" }
      end
    end,
  })
end

-- ── which-key (popup of available leader mappings) ────────────────────
local wk_ok, wk = pcall(require, "which-key")
if wk_ok then
  wk.setup({})
  wk.add({
    { "<leader>G", group = "git (fugitive)" },
    { "<leader>h", group = "git hunks" },
    { "<leader>l", group = "lsp/format" },
    { "<leader>r", group = "rename" },
    { "<leader>c", group = "code action" },
    { "<leader>x", group = "trouble" },
  })
end

-- ── nvim-autopairs (auto-close brackets/quotes, treesitter-aware) ─────
local ap_ok, autopairs = pcall(require, "nvim-autopairs")
if ap_ok then
  autopairs.setup({ check_ts = true })
  -- After confirming a function completion in cmp, auto-insert the "()"
  local cmp_ap_ok, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
  if cmp_ap_ok and cmp_ok then
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end
end

-- ── trouble.nvim (diagnostics / references panel) ─────────────────────
local trouble_ok, trouble = pcall(require, "trouble")
if trouble_ok then
  trouble.setup({})
end

EOF
