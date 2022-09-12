;; THIS FILE WAS GENERATED AUTOMATICALLY VIA org-babel. DO NOT EDIT MANUALLY.

(setq user-full-name "DC*"
      user-mail-address "des@riseup.net")

(add-hook 'after-save-hook #'evil-normal-state)

(setq warning-suppress-types (append warning-suppress-types '((org-element-cache))))

(setq mac-command-modifier 'meta) ; make cmd key do Meta
(setq mac-option-modifier 'super) ; make opt key do Super
(setq mac-control-modifier 'control) ; make Control key do Control

(setq delete-by-moving-to-trash t)
(setq trash-directory "~/.Trash")

(use-package undo-tree
    :ensure t
    :init
    (setq undo-limit 80000000)
    (setq undo-outer-limit 100000000)
    (setq undo-strong-limit 150000000)
    (setq undo-tree-mode-lighter " UN")
    (setq undo-tree-auto-save-history t)
    (setq undo-tree-enable-undo-in-region nil)
    (setq undo-tree-history-directory-alist '(("." . "~/emacs.d/undo")))
    (add-hook 'undo-tree-visualizer-mode-hook
              (lambda () (undo-tree-visualizer-selection-mode)
                (setq display-line-numbers nil)))
    (add-hook 'evil-local-mode-hook 'turn-on-undo-tree-mode)
    :config
        (global-undo-tree-mode 1))

(use-package super-save
  :ensure t
  :defer t
  :config
  (super-save-mode +1))

(defun me/super-save-disable-advice (orig-fun &rest args)
  "Dont auto-save under these conditions."
  (unless (equal (car args) " *LV*")
	(apply orig-fun args)))
(advice-add 'super-save-command-advice :around #'me/super-save-disable-advice)

(setq doom-theme 'doom-nord-light)

(setq display-line-numbers-type t)

;(add-to-list 'initial-frame-alist '(fullscreen . maximized)) ;; only starting frame
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(defun me/set-scroll-margin()
  (set (make-local-variable 'scroll-margin) 10))

(add-hook 'org-mode-hook 'me/set-scroll-margin)
(add-hook 'prog-mode-hook 'me/set-scroll-margin)

(setq doom-modeline-enable-word-count t)

(setq doom-font-increment 1)
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 15)) ;; Fira Code,  :weight 'medium, :size 12
(setq doom-unicode-font (font-spec :family "JetBrainsMono Nerd Font" :size 15))
(setq doom-variable-pitch-font (font-spec :family "Fira Sans" :size 15))

(custom-theme-set-faces
    'user
    '(org-block ((t (:inherit fixed-pitch))))
    '(org-code ((t (:inherit (shadow fixed-pitch)))))
    '(org-document-info ((t (:foreground "dark orange"))))
    '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
    '(org-indent ((t (:inherit (org-hide fixed-pitch)))))
    ;;'(org-link ((t (:foreground "royal blue" :underline t))))
    '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
    '(org-property-value ((t (:inherit fixed-pitch))) t)
    '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
    '(org-table ((t (:inherit fixed-pitch :foreground "#83a598"))))
    '(org-tag ((t (:inherit (shadow fixed-pitch) :weight bold))))

    '(org-verbatim ((t (:inherit (shadow fixed-pitch))))))

(defun my/apply-theme (appearance)
  "Load theme, taking current system APPEARANCE into consideration."
  (mapc #'disable-theme custom-enabled-themes)
  (pcase appearance
    ('light (load-theme 'doom-nord-light t))
    ('dark (load-theme 'doom-nord t))))

(add-hook 'ns-system-appearance-change-functions #'my/apply-theme)

(setq fancy-splash-image "~/.doom.d/splash/doom-emacs-bw-light.svg")

(after! git-gutter
  (setq git-gutter:update-interval 0.5))

(advice-add 'evil-ex-search-next :after
            (lambda (&rest x) (evil-scroll-line-to-center (line-number-at-pos))))
(advice-add 'evil-ex-search-previous :after
            (lambda (&rest x) (evil-scroll-line-to-center (line-number-at-pos))))

(use-package centered-cursor-mode
  :defer t
  :config
  ;; Optional, enables centered-cursor-mode in all buffers.
  ;;(global-centered-cursor-mode)
)

(use-package vertico
  :init
  (vertico-mode))
;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :defer t
  :init
  (savehist-mode))

;; Optionally use the `orderless' completion style.
(use-package orderless
  :defer t
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package vertico-posframe
  :config
  (vertico-posframe-mode 1)
  (setq vertico-posframe-border-width 8
        vertico-posframe-width 120
        vertico-posframe-height 20
        vertico-posframe-min-height 10
        vertico-posframe-parameters
        '((left-fringe . 2)
          (right-fringe . 2))))

(map! "M-§" #'resize-window)

(use-package beacon
  :defer t
  :ensure t
  :config
    (beacon-mode 1)
    (setq beacon-size 10))

(after! highlight-indent-guides
  (highlight-indent-guides-auto-set-faces))

(setq split-width-threshold 1)
(setq evil-vsplit-window-right t
      evil-split-window-below t)

(defadvice! prompt-for-buffer (&rest _)
  :after 'evil-window-split (consult-projectile))
(defadvice! prompt-for-vbuffer (&rest _)
  :after 'evil-window-vsplit (consult-projectile))

(map! "M-n"
     'evil-window-vnew)
(defadvice! vnew-righthand (&rest _)
  :after 'evil-window-vnew (+evil/window-move-right))
(defadvice! vnew-dashboard (&rest _)
  :after 'evil-window-vnew (+doom-dashboard/open (selected-frame)))
(defadvice! vnew-projectile (&rest _)
  :after 'evil-window-vnew (consult-projectile))

(use-package zoom
  :defer t
  :config
    (zoom-mode 0)
    (global-set-key (kbd "C-x =") 'zoom))

(map! "M-v" 'clipboard-yank)
(map! "M-c" 'copy-region-as-kill)

(map! :leader :desc "Open Dashboard" "d" #'+doom-dashboard/open)

(map! "M-;" 'execute-extended-command)

(map! :ne "M-/" #'comment-or-uncomment-region)

(map! "M-t" #'+treemacs/toggle)

(map! "M-s" #'save-buffer)

(map! "M-r" #'+default/search-project)

(map! "M-m" #'consult-imenu)
(defadvice! expand-folds-imenu(&rest _)
  :before 'consult-imenu (+org/open-all-folds))
(defadvice! expand-folds-imenu(&rest _)
  :before '+default/search-buffer (+org/open-all-folds))

(map! "M-f" #'consult-projectile)
(map! :leader "SPC" 'consult-projectile)

(map! "M-p" #'projectile-find-file)

(map! "M-b" #'+vertico/switch-workspace-buffer)

(map! "M-]" #'next-window-any-frame)
(map! "M-[" #'previous-window-any-frame)

(global-set-key (kbd "C-c v p") 'er/mark-paragraph)
(global-set-key (kbd "C-c v w") 'er/mark-word)

(map! "M-i" #'consult-yasnippet)

(after! evil-org
  (define-key evil-org-mode-map (kbd "<visual-state> M-l") 'org-insert-link))

(map! "M-g" #'xref-find-definitions-other-window)

(map! "M-w" 'delete-window)

(global-set-key (kbd "C-c e") 'org-edit-src-code)

(after! evil-org
  (define-key evil-org-mode-map (kbd "<normal-state> M-k") 'evil-scroll-up)
  (define-key evil-org-mode-map (kbd "<normal-state> M-j") 'evil-scroll-down))

(map! "C-." 'goto-last-change)
(map! "C-," 'goto-last-change-reverse)
;(global-set-key [(control ?.)] 'goto-last-change)
;(global-set-key [(control ?,)] 'goto-last-change-reverse)

(use-package ispell
  :defer t)

(use-package flyspell
  :defer t)

(setq ispell-dictionary "british")

(setq langtool-default-language "en-GB")

(defun langtool-autoshow-detail-popup (overlays)
  (when (require 'popup nil t)
    ;; Do not interrupt current popup
    (unless (or popup-instances
                ;; suppress popup after type `C-g` .
                (memq last-command '(keyboard-quit)))
      (let ((msg (langtool-details-error-message overlays)))
        (popup-tip msg)))))

(setq langtool-autoshow-message-function
      'langtool-autoshow-detail-popup)

(setq flycheck-checker-error-threshold 5000)

(setq flycheck-phpcs-standard "psr12")

(setq lsp-file-watch-threshold 5000)

(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]vendor\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]misc-dev-contrib\\~")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]misc\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]push-notifications\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]main\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]kantox-sdk-guzzle5\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]ecadmin\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]docs-api-swagger\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]docs-network-api-swagger\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]dbmigration\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]admin-v2\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]static\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]sandbox\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]rtb\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]management\'")
  ;; or
  (add-to-list 'lsp-file-watch-ignored-files "[/\\\\]\\.my-files\\'"))

(use-package lsp-ui
  :after lsp-mode
  :defer t)

(setq lsp-idle-delay 0.1
    company-minimum-prefix-length 4
    company-idle-delay 0.1
    company-tooltip-minimum-width 50
    company-tooltip-maximum-width 50
    lsp-ui-doc-include-signature t
    lsp-ui-doc-max-width 100
    lsp-ui-doc-max-height 20
    lsp-ui-doc-enable t)

(use-package lsp-treemacs
  :defer t)

(setq lsp-headerline-breadcrumb-enable t)
(setq lsp-headerline-breadcrumb-segments '(symbols))
(setq lsp-headerline-breadcrumb-icons-enable t)
(setq lsp-headerline-breadcrumb-enable-diagnostics nil)

(map! "M-x" 'lsp-ui-peek-find-references)

(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(use-package yasnippet-snippets
  :defer t)

(use-package evil-snipe
  :defer t
  :config
  (setq evil-snipe-scope 'visible)
  (setq evil-snipe-repeat-scope 'buffer)
  (setq evil-snipe-spillover-scope 'whole-buffer)
)

(use-package devdocs
  :defer t
  :ensure t)

(global-set-key (kbd "C-h D") 'devdocs-lookup)

(use-package better-jumper
  :defer t
  :ensure t
  :config
  (better-jumper-mode +1))
(with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map (kbd "C-o") 'better-jumper-jump-backward)
  (define-key evil-motion-state-map (kbd "C-i") 'better-jumper-jump-forward))

(after! magit
    (setq git-commit-summary-max-length 100))

(after! projectile
   (setq projectile-project-search-path '("~/sys-vagrant/code")))

(use-package treemacs
  :defer t
  :config
  (setq treemacs-is-never-other-window t
        treemacs-wrap-around nil
        treemacs-display-current-project-exclusively t
        treemacs-follow-mode t))

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-magit
  :defer t
  :after (treemacs magit)
  :ensure t)

(use-package treemacs-persp ;;treemacs-perspective if you use perspective.el vs. persp-mode
  :after (treemacs persp-mode) ;;or perspective vs. persp-mode
  :ensure t
  :config (treemacs-set-scope-type 'Perspectives))

(defun me/switch-workspace ()
  (interactive)
  (call-interactively #'+workspace/switch-to))

(map! :leader
    :desc "Switch workspace"
    "TAB TAB" #'me/switch-workspace)

(setq org-directory "~/org/")
(after! org
  (setq
    org-startup-folded nil
    org-hide-emphasis-markers t))

(defun me/org-disable-line-numbers-mode()
  (display-line-numbers-mode -1))

; File mode specification error: (void-function me/org-disable-hl-indent-mode)
(defun me/org-disable-indent-mode()
  (setq org-indent-mode -1))

(defun me/org-disable-git-gutter-mode()
  (git-gutter-mode -1))

(defun me/org-enable-literate-calc-minor-mode()
  (literate-calc-minor-mode 1))

(defun me/org-disable-hl-indent-guides()
  (highlight-indent-guides-mode -1))

(add-hook 'org-mode-hook 'visual-line-mode)
(add-hook 'org-mode-hook 'variable-pitch-mode)
(add-hook 'org-mode-hook 'me/org-disable-indent-mode)
(add-hook 'org-mode-hook 'me/org-disable-line-numbers-mode)
(add-hook 'org-mode-hook 'me/org-disable-hl-indent-guides)
(add-hook 'org-mode-hook 'me/org-enable-literate-calc-minor-mode)

;; see https://github.com/doomemacs/doomemacs/issues/4815#issue-834176237
(add-to-list 'git-gutter:disabled-modes 'org-mode)

(setq company-global-modes '(not org-mode))

(setq org-archive-location (concat "archive/archive-"
                                   (format-time-string "%Y%m" (current-time)) ".org_archive::"))

(setq org-capture-bookmark nil)

(map! "M-o" 'org-agenda)

(setq org-agenda-custom-commands
      '(
        ("w" "List :work: TODO/INPROGRESS/NEXT"
          ((tags "work/TODO|INPROGRESS|NEXT")))
        ("p" "List :personal: TODO/INPROGRESS/NEXT"
            ((tags "personal/TODO|INPROGRESS|NEXT")))
        ("P" "List :projects: TODO/INPROGRESS/NEXT"
            ((tags "projects/TODO|INPROGRESS|NEXT")))
        ("e" "List :emacs: TODO/INPROGRESS/NEXT"
            ((tags "emacs/TODO|INPROGRESS|NEXT")))
        ("l" "List :learning:"
            ((tags "learning")))
    ))

(setq org-agenda-sorting-strategy '((agenda priority-down todo-state-down)
                                    (todo priority-down todo-state-down)
                                    (tags priority-down todo-state-down)
                                    (search priority-down todo-state-down category-keep)))

(use-package org-modern
  :defer t
  :config
  (setq org-modern-star nil)
  (setq org-modern-timestamp nil)
  (setq org-modern-todo nil)
  (setq org-modern-tag nil)
  (setq org-modern-statistics nil)
  (setq org-modern-hide-stars nil)
  (global-org-modern-mode)
  (custom-set-faces
   '(org-modern-block-name ((t nil)))))

(use-package org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default nil))

(use-package! ob-http
  :commands org-babel-execute:http)

(use-package org-roam
  :defer t
  :custom
  (org-roam-directory "~/org/roam")
  (org-roam-index-file "~/org/roam/index.org")
  )

(defun me/counsel-ag-roam ()
 "Do counsel-ag on the org roam directory"
 (interactive)
 (counsel-ag nil org-roam-directory))

(use-package consult-org-roam
  :defer t
   :ensure t
   :init
   (require 'consult-org-roam)
   ;; Activate the minor-mode
   (consult-org-roam-mode 1)
   :custom
   (consult-org-roam-grep-func #'consult-ripgrep)
   :config
   ;; Eventually suppress previewing for certain functions
   (consult-customize
    consult-org-roam-forward-links
    :preview-key (kbd "M-.")))

(map! :leader
      :desc "Search via consult"
      "n r S" #'consult-org-roam-search)

(after! org
    (setq org-todo-keywords
        '((sequence  "PROJ(p)" "TODO(t)" "NEXT(n)" "WAITING(w)" "INPROGRESS(i)" "|" "DONE(d)" "CANCELED(c)")))
    (setq org-tag-alist '(("personal" . ?p) ("projects" . ?P) ("learning" . ?l) ("@home" . ?h) ("work" . ?w) ("@computer" . ?c) ("errands" . ?e)))
    )

(use-package org-bullets
  :defer t
  :ensure t
  :config
    (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  )

(use-package org
  :config
    (setq org-log-repeat nil)
)

(use-package literate-calc-mode
  :defer t
  :ensure t)

(setq org-pomodoro-format "%s"
      org-pomodoro-start-sound-p t
      org-pomodoro-short-break-length 10)

(setq org-clock-clocked-in-display nil)

(setq me/org-pomodoro-bell-sound "~/.doom.d/resources/bell-ring-01.wav")
(setq org-pomodoro-finished-sound me/org-pomodoro-bell-sound
      org-pomodoro-start-sound me/org-pomodoro-bell-sound
      org-pomodoro-long-break-sound me/org-pomodoro-bell-sound
      org-pomodoro-short-break-sound me/org-pomodoro-bell-sound
      org-pomodoro-ticking-sound me/org-pomodoro-bell-sound
      org-pomodoro-overtime-sound me/org-pomodoro-bell-sound)

(use-package vterm
  :defer t
  :custom
  (vterm-shell "fish")
  (setq vterm-timer-delay 0))

(use-package elfeed
  :defer t
  :init
  (elfeed-goodies/setup)
  :config
  (add-hook 'elfeed-show-mode-hook #'elfeed-update)
  (add-hook  'elfeed-show-mode-hook 'variable-pitch-mode)
  (map! "M-e" 'elfeed)
  (setq elfeed-feeds
      '(
        ("https://sachachua.com/blog/category/emacs-news/feed/" emacs)
        ("https://planet.emacslife.com/atom.xml" emacs)
        ("http://nedroid.com/feed/" webcomic)
        ("https://hnrss.org/frontpage" news)
        )))

(use-package calibredb
  :defer t
  :config
  (setq calibredb-root-dir "~/Sync/Books/Calibre Library")
  (setq calibredb-db-dir (expand-file-name "metadata.db" calibredb-root-dir))
  (setq calibredb-library-alist '(("~/Sync/Books/Calibre Library"))))

(use-package keyfreq
  :defer t
  :config
    (keyfreq-mode 1)
    (keyfreq-autosave-mode 1))

(setq circe-network-options
      '(("Libera"
         :tls t
         :nick "DC[e]"
         :channels ("#freenet"))))

(setq browse-url-browser-function 'browse-url-generic)
(setq browse-url-generic-program "/Applications/Firefox.app/Contents/MacOS/firefox")
