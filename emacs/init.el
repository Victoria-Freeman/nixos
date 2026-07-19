(load-theme 'gruvbox-dark-medium t)

(setq inhibit-startup-message t
      inhibit-startup-screen t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode 1)
(show-paren-mode 1)

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

(setq-default indent-tabs-mode nil
              tab-width 2
              c-basic-offset 2)

(require 'which-key)
(which-key-mode 1)

(require 'lsp-mode)
(setq lsp-keymap-prefix "C-c l"
      lsp-enable-indentation nil
      lsp-enable-on-type-formatting nil)
(dolist (hook '(python-mode-hook
                java-mode-hook
                kotlin-mode-hook
                nix-mode-hook
                markdown-mode-hook))
  (add-hook hook #'lsp))

(require 'vterm)

(provide 'init)
