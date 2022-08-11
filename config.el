(setq user-full-name "DC"
      user-mail-address "des@riseup.net")
(setq doom-theme 'doom-nord-light)
(setq display-line-numbers-type t)
(setq org-directory "~/org/")
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
  (define-key evil-motion-state-map (kbd "<C-i>") 'better-jumper-jump-forward))
(use-package super-save
  :ensure t
  :config
  (super-save-mode +1))
(map! :leader :desc "Open Dashboard" "d" #'+doom-dashboard/open)
(map! :ne "M-/" #'comment-or-uncomment-region)
(map! "s-b" #'ido-switch-buffer)
(map! "s-p" #'+treemacs/toggle)
(map! "s-§" #'+treemacs/toggle)
(map! "s-s" #'save-buffer)
(map! "s-f" #'+default/search-project)
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
(use-package org
  :config
    (setq org-log-repeat nil)
)
(use-package modeline
  (setq doom-modeline-enable-word-count t))
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
(use-package spatial-navigate
  :after (lsp-treemacs)
  :ensure t)
(with-eval-after-load 'lsp-treemacs
  (doom-themes-treemacs-config))
    (define-keyevil-normal-state-map (kbd "C-k") 'spatial-navigate-backward-vertical-box)
    (define-key evil-normal-state-map (kbd "C-j") 'spatial-navigate-forward-vertical-box)
    (define-key evil-normal-state-map (kbd "C-h") 'spatial-navigate-backward-horizontal-box)
    (define-key evil-normal-state-map (kbd "C-l") 'spatial-navigate-forward-horizontal-box)
    (define-key evil-insert-state-map (kbd "C-k") 'spatial-navigate-backward-vertical-bar)
    (define-key evil-insert-state-map (kbd "C-j") 'spatial-navigate-forward-vertical-bar)
    (define-key evil-insert-state-map (kbd "C-h") 'spatial-navigate-backward-horizontal-bar)
    (define-key evil-insert-state-map (kbd "C-l") 'spatial-navigate-forward-horizontal-bar)
