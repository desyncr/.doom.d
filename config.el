(setq user-full-name "DC*"
      user-mail-address "des@riseup.net")

(setenv "PATH" (concat "/usr/local/opt/ruby/bin:" (getenv "PATH")))
(setq exec-path (append '("/usr/local/opt/ruby/bin") exec-path))

(setq doom-theme 'doom-nord-light)

(setq display-line-numbers-type t)

(add-to-list 'default-frame-alist '(fullscreen . maximized))
;(add-to-list 'default-frame-alist '(height . 86))
;(add-to-list 'default-frame-alist '(width . 326))
;(add-to-list 'default-frame-alist '(top . 70))
;(add-to-list 'default-frame-alist '(left . 130))

(setq warning-suppress-types (append warning-suppress-types '((org-element-cache))))

(setq scroll-margin 10
       evil-want-fine-undo t
       undo-limit 80000000
       auto-save-default t)
(display-time-mode 1)
(global-subword-mode 1)

(setq display-time-format "%H:%M%p %a, %d %b | W%U")
(setq display-time-default-load-average nil)
(display-time)

(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 14)) ;; Fira Code,  :weight 'medium, :size 12
(setq doom-unicode-font (font-spec :family "JetBrainsMono Nerd Font" :size 14))
(setq doom-variable-pitch-font (font-spec :family "Fira Sans" :size 14))

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

(setq doom-modeline-enable-word-count t)

(after! git-gutter
  (setq git-gutter:update-interval 0.5))

(advice-add 'evil-ex-search-next :after
            (lambda (&rest x) (evil-scroll-line-to-center (line-number-at-pos))))
(advice-add 'evil-ex-search-previous :after
            (lambda (&rest x) (evil-scroll-line-to-center (line-number-at-pos))))

(use-package centered-cursor-mode
  :demand
  :config
  ;; Optional, enables centered-cursor-mode in all buffers.
  ;;(global-centered-cursor-mode)
)

(use-package vertico
  :init
  (vertico-mode))
;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;; Optionally use the `orderless' completion style.
(use-package orderless
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

(map! "s-§" #'resize-window)

(use-package beacon
    :ensure t
    :config
        (beacon-mode 1)
        (setq beacon-size 10))

(after! highlight-indent-guides
  (highlight-indent-guides-auto-set-faces))

(setq evil-vsplit-window-right t
      evil-split-window-below t)

(defadvice! prompt-for-buffer (&rest _)
  :after 'evil-window-split (consult-projectile))
(defadvice! prompt-for-vbuffer (&rest _)
  :after 'evil-window-vsplit (consult-projectile))

(map! "s-n"
     'evil-window-vnew)
(defadvice! vnew-righthand (&rest _)
  :after 'evil-window-vnew (+evil/window-move-right))
(defadvice! vnew-dashboard (&rest _)
  :after 'evil-window-vnew (+doom-dashboard/open (selected-frame)))
(defadvice! vnew-projectile (&rest _)
  :after 'evil-window-vnew (consult-projectile))

(use-package zoom
    :config
    (zoom-mode 0)
    (global-set-key (kbd "C-x =") 'zoom))

(map! "s-;" 'execute-extended-command)

(use-package keyfreq
  :ensure t
  :config
    (keyfreq-mode 1)
    (keyfreq-autosave-mode 1))

(map! :leader :desc "Open Dashboard" "d" #'+doom-dashboard/open)

(map! :ne "M-/" #'comment-or-uncomment-region)

(map! "s-t" #'+treemacs/toggle)

(map! "s-s" #'save-buffer)

(map! "s-r" #'+default/search-project)

(map! "s-m" #'consult-imenu)
(defadvice! expand-folds-imenu(&rest _)
  :before 'consult-imenu (+org/open-all-folds))
(defadvice! expand-folds-imenu(&rest _)
  :before '+default/search-buffer (+org/open-all-folds))

(map! "s-f" #'consult-projectile)
(map! :leader "SPC" 'consult-projectile)

(map! "s-p" #'projectile-find-file)

(map! "s-b" #'consult-buffer)

(map! "s-]" #'next-window-any-frame)
(map! "s-[" #'previous-window-any-frame)

(global-set-key (kbd "C-c v p") 'er/mark-paragraph)
(global-set-key (kbd "C-c v w") 'er/mark-word)

(map! "s-i" #'yas-insert-snippet)

(map! "s-l" #'org-insert-link)

(map! "s-g" #'xref-find-definitions-other-window)



(global-set-key (kbd "C-c e") 'org-edit-src-code)

(map! "s-d" 'evil-scroll-down)
(map! "s-u" 'evil-scroll-up)

(use-package super-save
  :ensure t
  :config
  (super-save-mode +1))

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
  :after lsp
  :defer t
  :custom
    (lsp-idle-delay 0.5
        company-minimum-prefix-length 4
        company-idle-delay 0.5
        company-tooltip-minimum-width 50
        company-tooltip-maximum-width 50))

(use-package lsp-treemacs
  :defer t)

(setq lsp-headerline-breadcrumb-enable t)
(setq lsp-headerline-breadcrumb-segments '(symbols))
(setq lsp-headerline-breadcrumb-icons-enable t)
(setq lsp-headerline-breadcrumb-enable-diagnostics nil)

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
  :ensure t)

(global-set-key (kbd "C-h D") 'devdocs-lookup)

(map! "s-k" #'evil-multiedit-match-symbol-and-prev
  "s-j" #'evil-multiedit-match-symbol-and-next)

(use-package better-jumper
  :ensure t
  :config
  (better-jumper-mode +1))
(with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map (kbd "C-o") 'better-jumper-jump-backward)
  (define-key evil-motion-state-map (kbd "C-i") 'better-jumper-jump-forward))

(after! magit
    (setq git-commit-summary-max-length 100))

(after! projectile
   (setq
        projectile-project-search-path '("~/sys-vagrant/code/")
   )
)

(use-package treemacs
  :defer t
  :config
  (setq treemacs-is-never-other-window t
        treemacs-wrap-around nil))

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

(use-package treemacs-persp ;;treemacs-perspective if you use perspective.el vs. persp-mode
  :after (treemacs persp-mode) ;;or perspective vs. persp-mode
  :ensure t
  :config (treemacs-set-scope-type 'Perspectives))

(setq delete-by-moving-to-trash t)
(setq trash-directory "~/.Trash")

(setq org-archive-location (concat "archive/archive-"
                                   (format-time-string "%Y%m" (current-time)) ".org_archive::"))

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
(add-hook 'org-mode-hook 'me/org-disable-indent-mode)
(add-hook 'org-mode-hook 'variable-pitch-mode)
(add-hook 'org-mode-hook 'me/org-disable-line-numbers-mode)
(add-hook 'org-mode-hook 'me/org-disable-hl-indent-guides)
(add-hook 'org-mode-hook 'me/org-enable-literate-calc-minor-mode)

;; see https://github.com/doomemacs/doomemacs/issues/4815#issue-834176237
(add-to-list 'git-gutter:disabled-modes 'org-mode)

(setq company-global-modes '(not org-mode))

(use-package org-modern
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

(setq org-agenda-custom-commands
      '(
        ("n" "List :work: TODO/NEXT"
          ((tags "work/TODO|NEXT")))
        ("p" "List :personal: TODO/NEXT"
          ((tags "personal/TODO|NEXT")))
        ("P" "List :projects: TODO/NEXT"
          ((tags "projects/TODO|NEXT")))
    ))

(map! "s-o" 'org-agenda)

(use-package org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default nil))

(use-package! ob-http
  :commands org-babel-execute:http)

(use-package org-roam
  :custom
  (org-roam-directory "~/org/roam")
  (org-roam-index-file "~/org/roam/index.org")
  )

(after! org
    (setq org-todo-keywords
        '((sequence  "PROJ(p)" "TODO(t)" "NEXT(n)" "WAITING(w)" "INPROGRESS(i)" "|" "DONE(d)" "CANCELED(c)")))
    (setq org-tag-alist '(("personal" . ?p) ("projects" . ?P) ("learning" . ?l) ("@home" . ?h) ("work" . ?w) ("@computer" . ?c) ("errands" . ?e)))
    )

(use-package org-bullets
  :ensure t
  :config
    (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  )

(use-package org
  :config
    (setq org-log-repeat nil)
)

(use-package literate-calc-mode
  :ensure t)

(use-package vterm
  :custom
  (vterm-shell "fish"))

(setq elfeed-feeds
      '(("https://www.reddit.com/r/emacs.rss" reddit)
        ("https://planet.emacslife.com/atom.xml" emacslife)))
