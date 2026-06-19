;;; init.el -*- lexical-binding: t; -*-

(doom! :input

       :completion
       (corfu +icons)            ; blink.cmp
       (vertico +icons)          ; mini.pick / snacks.picker

       :ui
       doom                      ; catppuccin applied in config.el
       dashboard                 ; mini.starter
       hl-todo                   ; mini.hipatterns
       indent-guides             ; snacks indent
       (ligatures +extra)
       modeline
       nav-flash
       ophints
       (popup +defaults)
       (vc-gutter +pretty)       ; mini.diff signs
       vi-tilde-fringe
       (window-select +numbers)
       workspaces

       :editor
       (evil +everywhere)        ; your whole vim layer; SPC leader
       file-templates
       fold
       (format +onsave)          ; vim.lsp.buf.format
       snippets                  ; friendly-snippets analog (doom-snippets)
       word-wrap

       :emacs
       (dired +icons)            ; mini.files explorer
       electric
       (ibuffer +icons)
       undo
       vc

       :term
       vterm                     ; snacks.terminal

       :checkers
       syntax                    ; flymake/flycheck diagnostics

       :tools
       direnv                    ; you use direnv in nix-config
       (eval +overlay)
       (lookup +dictionary +docsets)
       (lsp +eglot)              ; nvim-lspconfig + vim.lsp.config
       magit                     ; mini.git upgrade
       (tree-sitter)             ; nvim-treesitter

       :lang
       (lua +lsp)                ; lua_ls
       (rust +lsp +tree-sitter)  ; rust_analyzer
       (javascript +lsp +tree-sitter) ; tsserver / biome
       (web +tree-sitter)        ; required by :lang php
       (php +lsp +tree-sitter)   ; intelephense
       (python +lsp +tree-sitter +pyright)
       (ocaml +lsp)              ; ocamllsp
       (go +lsp +tree-sitter)    ; gopls
       (haskell +lsp)            ; haskell-language-server
       (java +lsp)               ; jdtls (eclipse jdt)
       nix                       ; nixd / nil
       (json +tree-sitter)
       (yaml +lsp)
       (markdown)                ; render-markdown
       emacs-lisp
       sh

       :config
       (default +bindings +smartparens))
