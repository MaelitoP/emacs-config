;;; config.el -*- lexical-binding: t; -*-

;;; Identity
(setq user-full-name "Maelito"
      user-mail-address "maelito.contact@gmail.com")

;;; Theme
(setq catppuccin-flavor 'macchiato)
(setq doom-theme 'catppuccin)

;;; Editor options 
(setq display-line-numbers-type 'relative)    ; relativenumber
(setq-default tab-width 2                     ; tabstop / shiftwidth
              indent-tabs-mode nil            ; expandtab
              evil-shift-width 2)
(setq scroll-margin 2)                        ; scrolloff
(setq evil-split-window-below t               ; splitbelow
      evil-vsplit-window-right t)             ; splitright
(setq confirm-kill-emacs nil)                 ; confirm = false

(setq evil-escape-key-sequence "jj"
      evil-escape-delay 0.15)

(after! breadcrumb
  (breadcrumb-mode +1))

;; launchd daemon won't foreground itself; focus client frames on creation
(add-hook 'server-after-make-frame-hook
          (lambda () (select-frame-set-input-focus (selected-frame))))

;; open new frames maximized instead of the default ~80x36
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(after! eglot
  (add-to-list 'eglot-server-programs
               '(nix-mode . ("nixd")))
  (add-to-list 'eglot-server-programs
               '((js-mode js-ts-mode typescript-mode typescript-ts-mode tsx-ts-mode)
                 . ("typescript-language-server" "--stdio")))
  ;; swap the line above for this when working in a biome project:
  ;; '((...) . ("biome" "lsp-proxy"))
  (add-to-list 'eglot-server-programs
               '((php-mode php-ts-mode) . ("intelephense" "--stdio"))))

(defun maelito/paste-below-keep-cursor ()
  (interactive)
  (let ((col (current-column)))
    (evil-paste-after 1)
    (move-to-column col)))

(defun maelito/cycle-line-numbers ()
  (interactive)
  (setq display-line-numbers
        (pcase display-line-numbers
          ('t 'relative)
          ('relative nil)
          (_ t))))

(defvar maelito--flow-on nil)
(defun maelito/toggle-flow ()
  (interactive)
  (if maelito--flow-on
      (progn (display-line-numbers-mode +1)
             (when (fboundp 'breadcrumb-local-mode) (breadcrumb-local-mode +1))
             (setq maelito--flow-on nil))
    (display-line-numbers-mode -1)
    (when (fboundp 'breadcrumb-local-mode) (breadcrumb-local-mode -1))
    (setq maelito--flow-on t)))

(defun maelito/copy-file-path ()
  (interactive)
  (if-let ((path (buffer-file-name)))
      (progn (kill-new path) (message "Copied: %s" path))
    (message "Buffer is not visiting a file")))

(defun maelito/find-directory ()
  (interactive)
  (dired (read-directory-name "Directory: ")))

;; Insert-mode arrow movement
(map! :i "C-h" #'left-char
      :i "C-j" #'next-line
      :i "C-k" #'previous-line
      :i "C-l" #'right-char)

;; Normal-mode core
(map! :n "p"     #'maelito/paste-below-keep-cursor
      :n "C-c"   #'evil-ex-nohighlight
      :n "C-s"   #'save-buffer
      ;; window navigation
      :n "C-h"   #'evil-window-left
      :n "C-j"   #'evil-window-down
      :n "C-k"   #'evil-window-up
      :n "C-l"   #'evil-window-right
      ;; buffer cycling
      :n "TAB"   #'next-buffer
      :n "S-TAB" #'previous-buffer
      ;; split resizing
      :n "M-k"   #'evil-window-increase-height
      :n "M-j"   #'evil-window-decrease-height
      :n "M-h"   #'evil-window-increase-width
      :n "M-l"   #'evil-window-decrease-width
      ;; centered scrolling
      :n "C-d"   (cmd! (evil-scroll-down 0) (evil-scroll-line-to-center nil))
      :n "C-u"   (cmd! (evil-scroll-up 0) (evil-scroll-line-to-center nil)))

(after! drag-stuff
  (map! :n "S-h" #'drag-stuff-left
        :n "S-l" #'drag-stuff-right
        :n "S-j" #'drag-stuff-down
        :n "S-k" #'drag-stuff-up
        :v "S-h" #'drag-stuff-left
        :v "S-l" #'drag-stuff-right
        :v "S-j" #'drag-stuff-down
        :v "S-k" #'drag-stuff-up))

;; Visual-mode help / search for selection
(map! :v "??" (cmd! (call-interactively #'describe-symbol))
      :v "?/" (cmd! (call-interactively #'evil-ex-search-forward)))

;; Leader bindings
(map! :leader
      ;; files / buffers / pickers
      :desc "Find file (here)"     "F"  #'find-file
      :desc "Find file (project)"  "ff" #'projectile-find-file
      :desc "Find buffers"         "bs" #'consult-buffer
      :desc "Resume last search"   "fr" #'vertico-repeat
      :desc "Grep live (project)"  "fw" #'+default/search-project
      :desc "Find directory"       "fd" #'maelito/find-directory
      :desc "Remove buffer"        "bq" #'kill-current-buffer
      :desc "Toggle explorer"      "e"  #'dired-jump
      :desc "Explorer (window)"    "E"  #'dired-jump-other-window
      :desc "Scratch buffer"       "o"  #'doom/open-scratch-buffer
      :desc "Toggle terminal"      "tt" #'+vterm/toggle
      :desc "Copy file path"       "pp" #'maelito/copy-file-path
      :desc "Jump to symbol"       "pi" #'consult-imenu
      ;; git
      :desc "Git commits"          "gc" #'magit-log-current
      :desc "Git status/hunks"     "gh" #'magit-status
      :desc "Toggle diff signs"    "td" #'diff-hl-mode
      ;; bookmarks
      :desc "Bookmark jump"        "As" #'consult-bookmark
      :desc "Bookmark set"         "Aa" #'bookmark-set
      :desc "Bookmark delete"      "AA" #'bookmark-delete
      ;; toggles
      :desc "Toggle line numbers"  "tn" #'maelito/cycle-line-numbers
      :desc "Toggle flow"          "tf" #'maelito/toggle-flow)

(map! :n "dn" #'flycheck-next-error
      :n "dp" #'flycheck-previous-error)

(map! :leader
      :desc "Diagnostics list"   "dp" #'consult-flycheck
      :desc "Diagnostic float"   "df" #'flycheck-display-error-at-point
      :desc "Diagnostics loclist" "ds" #'consult-flycheck
      :desc "Toggle inlay hints" "hi" #'eglot-inlay-hints-mode
      :desc "Hover docs"         "k"  #'+lookup/documentation
      :desc "Goto definition"    "ld" #'+lookup/definition
      :desc "Goto declaration"   "lh" #'eglot-find-declaration
      :desc "Goto type def"      "lt" #'eglot-find-typeDefinition
      :desc "Goto implementation" "li" #'eglot-find-implementation
      :desc "Goto references"    "lr" #'+lookup/references
      :desc "Code action"        "la" #'eglot-code-actions
      :desc "Format buffer"      "lf" #'+format/buffer
      :desc "Rename symbol"      "lc" #'eglot-rename)

;; insert-mode signature help (eldoc)
(map! :i "C-s" #'eldoc)
