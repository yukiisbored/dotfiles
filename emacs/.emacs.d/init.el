;; Custom file setup
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerr)

;; Package setup
(require 'package)
(setq package-enable-at-startup nil
      package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
			 ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Auto-compile elisp to byte code
(use-package auto-compile
  :init
  (auto-compile-on-load-mode)
  (auto-compile-on-save-mode))

;; UTF-8 Forever
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; Improved scrolling
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

(setq tab-always-indent nil
      indent-tabs-mode nil)

;; Sensible defaults
(load-file "~/.emacs.d/sensible-defaults.el/sensible-defaults.el")
(sensible-defaults/use-all-settings)
(sensible-defaults/use-all-keybindings)
(sensible-defaults/backup-to-temp-directory)

;; Distraction free
(menu-bar-mode -1)

(when window-system
  (tool-bar-mode -1)
  (scroll-bar-mode -1))

;; Give me more fucking space!
(set-fringe-mode 0)

(defun yuki/disable-scroll-bars (frame)
  (modify-frame-parameteres frame
			    '((vertical-scroll-bars . nil)
			      (horizontal-scroll-bars . nil))))

(add-hook 'after-make-frame-functions 'yuki/disable-scroll-bars)

;; Visual aid
(global-hl-line-mode t)
(column-number-mode t)

;; Automatically update packages
(use-package auto-package-update
  :config
  (add-hook 'after-init-hook 'auto-package-update-maybe))

;; Get variables from shell
(use-package exec-path-from-shell
  :if window-system
  :init
  (setq-default exec-path-from-shell-check-startup-files nil)
  (setq exec-path-from-shell-variables '("PATH"
					 "GOPATH"))
  :config
  (exec-path-from-shell-initialize))

;; Cyberpunk theme
(use-package cyberpunk-theme
  :config
  (load-theme 'cyberpunk t))

;; The superior completion front-end
(use-package ivy
  :bind
  ("C-c C-r" . ivy-resume)
  :init
  (setq ivy-use-virtual-buffers t
	enable-recursive-minibuffers t)
  :config
  (add-hook 'after-init-hook 'ivy-mode))

;; The superior isearch
(use-package swiper
  :bind
  ("C-s" . swiper)
  ("C-r" . swiper))

;; Use the superior completion front end
(use-package counsel
  :bind
  ("M-x"     . counsel-M-x)
  ("C-x C-f" . counsel-find-file)
  ("<f1> f"  . counsel-describe-function)
  ("<f2> v"  . counsel-describe-variable)
  ("<f1> l"  . counsel-find-library)
  ("<f1> i"  . counsel-info-lookup-symbol)
  ("<f2> u"  . counsel-unicode-char)
  :config
  (define-key read-expression-map
    (kbd "C-r") 'counsel-expression-history))

;; The silver searcher
(use-package ag
  :after counsel
  :bind
  ("C-c k" . counsel-ag))

;; Display available keybindings in popup
(use-package which-key
  :init
  (setq which-key-idle-delay 0.5)
  :config
  (which-key-mode t))

;; Easier window management
(use-package switch-window
  :bind
  ("C-x o" . switch-window)
  ("C-x 1" . switch-window-then-maximize)
  ("C-x 2" . switch-window-then-split-below)
  ("C-x 3" . switch-window-then-split-right)
  ("C-x 0" . switch-window-then-delete)
  :init
  (setq switch-window-shortcut-style 'qwerty)
  (setq switch-window-qwerty-shortcuts
        '("a" "s" "d" "f" "j" "k" "l" ";" "w" "e" "i" "o"))
  (setq switch-window-minibuffer-shortcut ?z))

;; A Better Git interface
(use-package magit
  :bind
  ("C-x g" . magit-status))

;; Auto completion interface
(use-package auto-complete
  :hook (prog-mode . auto-complete-mode)
  :config
  (ac-config-default))

;; Automatic whitespace cleanup
(use-package whitespace-cleanup-mode
  :config
  (add-hook 'after-init-hook 'global-whitespace-cleanup-mode))

;; Project awareness
(use-package projectile
  :bind (:map projectile-mode-map)
  ("C-c p" . projectile-command-map)
  :init
  (setq projectile-completion-system 'ivy)
  :config
  (add-hook 'after-init-hook 'projectile-mode))

;; Modern on-the-fly syntax checking
(use-package flycheck
  :config
  (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))
  (add-hook 'after-init-hook 'global-flycheck-mode))

;; Persistent Undo
(use-package undo-tree
  :config
  (unless (file-directory-p "~/.emacs.d/undo")
    (make-directory "~/.emacs.d/undo"))
  (setq undo-tree-history-directory-alist '((".*" . "~/.emacs.d/undo")))
  (setq undo-tree-auto-save-history t))

;; Highlight TODOs
(use-package hl-todo
  :config
  (add-hook 'after-init-hook 'global-hl-todo-mode))

;; Highlight version control diffs
(use-package diff-hl
  :config
  (add-hook 'after-init-hook 'global-diff-hl-mode)
  (add-hook 'dired-mode-hook 'diff-hl-dired-mode)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))

;; IMenu Anywhere
(use-package imenu-anywhere
  :bind
  ("C-c ." . imenu-anywhere))

;; Generic Lisp Environment
(use-package parinfer
  :bind ("C-," . parinfer-toggle-mode)
  :hook
  (clojure-mode . parinfer-mode)
  (emacs-lisp-mode . parinfer-mode)
  (common-lisp-mode . parinfer-mode)
  (scheme-mode . parinfer-mode)
  (lisp-mode . parinfer-mode)
  :init
  (setq parinfer-extensions '(default pretty-parents paredit
			       smart-tab smart-yank)))

;; Major mode for YAML
(use-package yaml-mode
  :mode "\\.ya?ml")

;; Major mode for Go
(use-package go-mode
  :mode "\\.go\\'"
  :config
  (add-hook 'before-save-hook 'gofmt-before-save))

;; Auto completion for Go
(use-package go-autocomplete)

;; Major mode for Protocol Buffers
(use-package protobuf-mode)

;; Major mode for Markdown
(use-package markdown-mode
  :mode "\\.md\\'"
  :init
  (setq markdown-command "multimarkdown"))

;; Org babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)))

;; Do indentation natively in Org documents
(setq org-src-tab-acts-natively t)

;; Use xelatex
(setq org-latex-to-pdf-process
      '("xelatex -interaction nonstopmode %f"
	"xelatex -interaction nonstopmode %f"))