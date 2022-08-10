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
  (global-blamer-mode 1))
;; https://github.com/bbatsov/super-save
(use-package super-save
  :ensure t
  :config
  (super-save-mode +1))
;; Comment or uncomment region with M-/
(map! :ne "M-/" #'comment-or-uncomment-region)

(map! :leader :desc "Dashboard" "d" #'+doom-dashboard/open)

;; Search with deadgrep
(map! :ne "SPC r" #'deadgrep)
(use-package multi-magit
  :bind ("C-x G" . multi-magit-status)
  :ensure nil
  :config (progn
            (unless magit-repository-directories
              (setq magit-repository-directories '(("~/sys-vagrant/code/" . 2))))
            (magit-add-section-hook 'magit-status-sections-hook
                                    'multi-magit-insert-repos-overview
                                    nil t)))


(use-package which-key
  :ensure t
  :config
  (setq which-key-idle-delay 1.0 ;; Default is 1.0
      which-key-idle-secondary-delay 0.5) ;; Default is nil
)
(after! projectile
   (setq
        projectile-project-search-path '("~/sys-vagrant/code/")
   )
)

(setq doom-modeline-enable-word-count t)
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


;; https://github.com/emacs-lsp/lsp-treemacs/issues/89
(with-eval-after-load 'lsp-treemacs
          (doom-themes-treemacs-config))
(define-key evil-normal-state-map (kbd "C-k") 'spatial-navigate-backward-vertical-box)
(define-key evil-normal-state-map (kbd "C-j") 'spatial-navigate-forward-vertical-box)
(define-key evil-normal-state-map (kbd "C-h") 'spatial-navigate-backward-horizontal-box)
(define-key evil-normal-state-map (kbd "C-l") 'spatial-navigate-forward-horizontal-box)
(define-key evil-insert-state-map (kbd "C-k") 'spatial-navigate-backward-vertical-bar)
(define-key evil-insert-state-map (kbd "C-j") 'spatial-navigate-forward-vertical-bar)
(define-key evil-insert-state-map (kbd "C-h") 'spatial-navigate-backward-horizontal-bar)
(define-key evil-insert-state-map (kbd "C-l") 'spatial-navigate-forward-horizontal-bar)
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
