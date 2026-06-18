# emacs-config

MaelitoP's Doom Emacs configuration, nixified — the Emacs counterpart to
[`nvim-config`](https://github.com/MaelitoP/nvim-config).

## Architecture

This repo is the Doom **user config** directory (`~/.config/doom`). It mirrors
the `nvim-config` model exactly:

- `flake.nix` exposes a `homeManagerModule` that symlinks this repo to
  `~/.config/doom` (the analog of nvim-config symlinking to `~/.config/nvim`).
- Doom itself and its packages are **not** Nix-managed. Emacs is installed via
  Nix (`nix-config/modules/pkgs.nix`); Doom bootstraps its own packages with
  `straight.el` and `doom sync`, the same imperative model as `lazy.nvim`.

| File | Role | nvim-config analog |
|------|------|--------------------|
| `init.el` | Doom modules (features) enabled | `lua/plugins/*` + `lazy_spec.lua` |
| `packages.el` | Extra packages beyond Doom modules | plugin specs |
| `config.el` | Options, keybindings, custom commands | `opts.lua`, `mappings.lua`, `modules.lua` |

## Bootstrap (imperative, one-time)

```sh
# Emacs comes from Nix. Install Doom into ~/.config/emacs:
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom install
# After editing init.el / packages.el:
~/.config/emacs/bin/doom sync
```

`doom sync` is the analog of `:Lazy sync`. `~/.config/emacs` (the install dir)
stays out of Nix and out of this repo.

## Feature mapping (nvim → Doom)

- `mini.pick` / `snacks.picker` → vertico + consult
- `mini.files` / snacks explorer → dired
- `mini.git` / `mini.diff` → magit + diff-hl (vc-gutter)
- `mini.surround` / `comment` / `ai` / `pairs` → evil + smartparens
- `mini.move` → drag-stuff
- `mini.clue` → which-key
- `mini.starter` → doom-dashboard
- `blink.cmp` → corfu
- `nvim-lspconfig` → eglot
- `nvim-treesitter` → tree-sitter
- `catppuccin` (macchiato) → catppuccin-theme
- `dropbar.nvim` → breadcrumb

## Known divergences from nvim-config

- `SPC p` is a **prefix** here (`pp` copy path, `pi` jump to symbol) rather than
  a single dropbar command, to coexist with `SPC pp`.
- `dn`/`dp` diagnostics navigation uses flycheck (Doom `:checkers syntax`); if
  you switch eglot to flymake, rebind to `flymake-goto-{next,prev}-error`.
- Bookmark bindings (`SPC As`/`Aa`/`AA`) approximate `mini.visits` todo labels.
