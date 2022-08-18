(setq user-full-name "DC*"
      user-mail-address "des@riseup.net")
(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'medium))
(setq doom-theme 'doom-nord-light)
(setq display-line-numbers-type t)
(setq org-directory "~/org/")
(setq fancy-splash-image "~/.doom.d/splash/doom-emacs-bw-light.svg")
(use-package blamer
  :bind (("s-i" . blamer-show-commit-info))
  :defer 20
  :custom
    (blamer-idle-time 0.3)
    (blamer-min-offset 70)
    (blamer-max-commit-message-length 100)
  :custom-face
    (blamer-face ((t :foreground "#7a88cf"
                    :background nil
                    :italic t)))
  :config
  (global-blamer-mode 0))
(use-package better-jumper
  :ensure t
  :config
  (better-jumper-mode +1))
(with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map (kbd "C-o") 'better-jumper-jump-backward)
  (define-key evil-motion-state-map (kbd "C-i") 'better-jumper-jump-forward))
(use-package super-save
  :ensure t
  :config
  (super-save-mode +1))
(map! :leader :desc "Open Dashboard" "d" #'+doom-dashboard/open)
(map! :ne "M-/" #'comment-or-uncomment-region)
(map! "s-b" #'ido-switch-buffer)
(map! "s-t" #'+treemacs/toggle)
(map! "s-s" #'save-buffer)
(map! "s-f" #'+default/search-project)
(map! "s-p" #'projectile-find-file)
(setq flycheck-checker-error-threshold 10000)
(setq flycheck-phpcs-standard "psr12")
(setq lsp-file-watch-threshold 10000)
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
(setq
 lsp-idle-delay 0.1
 company-minimum-prefix-length 1
 company-idle-delay 0.0
 company-tooltip-minimum-width 50
 company-tooltip-maximum-width 50
 )
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

(require 'yasnippet-snippets)
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
(after! projectile
   (setq
        projectile-project-search-path '("~/sys-vagrant/code/")
   )
)
(use-package treemacs
  :ensure t
  :config
  (setq treemacs-is-never-other-window t))
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
(use-package org-modern
  :config
    ;; Add frame borders and window dividers
    (modify-all-frames-parameters
    '((right-divider-width . 5)
    (internal-border-width . 5)))

    (dolist (face '(window-divider
                    window-divider-first-pixel
                    window-divider-last-pixel))
    (face-spec-reset-face face)
    (set-face-foreground face (face-attribute 'default :background)))
    (set-face-background 'fringe (face-attribute 'default :background))

    (setq
    ;; Edit settings
    org-auto-align-tags nil
    org-tags-column 0
    org-catch-invisible-edits 'show-and-error
    org-special-ctrl-a/e t
    org-insert-heading-respect-content t

    ;; Org styling, hide markup etc.
    org-hide-emphasis-markers t
    org-pretty-entities t
    org-ellipsis "…"

    ;; Agenda styling
    org-agenda-tags-column 0
    org-agenda-block-separator ?─
    org-agenda-time-grid
    '((daily today require-timed)
    (800 1000 1200 1400 1600 1800 2000)
    " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
    org-agenda-current-time-string
    "⭠ now ─────────────────────────────────────────────────")

    (global-org-modern-mode)
  )
(use-package org
  :config
    (setq org-log-repeat nil)
)
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
  (global-centered-cursor-mode))
(use-package vertico-posframe
  :config
  (vertico-posframe-mode 1)
  (setq vertico-posframe-border-width 8
        vertico-posframe-width 120
        vertico-posframe-height 20
        vertico-posframe-min-height 10
        vertico-posframe-parameters
        '((left-fringe . 5)
          (right-fringe . 5)))
  )
