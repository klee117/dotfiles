# Neovim Cheatsheet
Leader key: `,`

## File Navigation
| Key | Action |
|-----|--------|
| `<leader>f` | Fuzzy find files |
| `<leader>g` | Live grep (ripgrep) |
| `<leader>b` | Switch buffer (fzf) |
| `<leader>p` | Recent file history |
| `<leader>/` | Search lines in current buffer |
| `<leader>j` | Git-tracked files (GFiles) |
| `<leader>o` | Open file relative to current file |
| `<leader>e` | Toggle file tree |
| `<leader>E` | Reveal current file in tree |

## LSP
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Find references |
| `gi` | Go to implementation |
| `K` | Hover docs |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>lf` | Format file |
| `<leader>s` | Document symbols (fuzzy, jump) |

## Diagnostics
| Key | Action |
|-----|--------|
| `<leader>d` | Open diagnostic float |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |

## Trouble Panel
| Key | Action |
|-----|--------|
| `<leader>xx` | Workspace diagnostics |
| `<leader>xX` | Buffer diagnostics |
| `<leader>xr` | LSP references |
| `<leader>xs` | Symbols |
| `<leader>xq` | Quickfix list |

## Git (Fugitive)
| Key | Action |
|-----|--------|
| `<leader>Gs` | Git status |
| `<leader>Gb` | Git blame |
| `<leader>Gd` | Git diff |
| `<leader>Gl` | Git log (last 20) |

## Completion (insert mode)
| Key | Action |
|-----|--------|
| `<C-Space>` | Trigger completion |
| `<C-j>` / `<Tab>` | Next item |
| `<C-k>` / `<S-Tab>` | Previous item |
| `<CR>` | Confirm selection |
| `<C-e>` | Abort completion |

## Quickfix
| Key | Action |
|-----|--------|
| `<C-n>` | Next item |
| `<C-m>` | Previous item |
| `<leader>a` | Close quickfix |

## Splits
| Key | Action |
|-----|--------|
| `:vs filename` | Vertical split |
| `:sp filename` | Horizontal split |
| `<C-w>h/j/k/l` | Move between splits |
| `<C-w>=` | Equalize split sizes |

## Buffers
| Key | Action |
|-----|--------|
| `:e filename` | Open file into buffer |
| `:bn` / `:bp` | Next / previous buffer |
| `:bd` | Close buffer |

## Jump Navigation
| Key | Action |
|-----|--------|
| `<C-o>` | Jump back |
| `<C-i>` | Jump forward |

## Search
| Key | Action |
|-----|--------|
| `n` / `N` | Next / previous result (centered) |
| `Y` | Yank to end of line |
