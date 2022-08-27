(setq user-full-name "DC*"
      user-mail-address "des@riseup.net")

(setq doom-theme 'doom-nord-light)

(setq display-line-numbers-type t)

(add-to-list 'initial-frame-alist '(fullscreen . maximized))

(setq warning-suppress-types (append warning-suppress-types '((org-element-cache))))

(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 12)) ;; Fira Code,  :weight 'medium, :size 12
(setq doom-unicode-font (font-spec :family "JetBrainsMono Nerd Font" :size 12))

(defun my/apply-theme (appearance)
  "Load theme, taking current system APPEARANCE into consideration."
  (mapc #'disable-theme custom-enabled-themes)
  (pcase appearance
    ('light (load-theme 'doom-nord-light t))
    ('dark (load-theme 'doom-nord t))))

(add-hook 'ns-system-appearance-change-functions #'my/apply-theme)

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

(map! "s-r" #'+default/search-project)

(map! "s-p" #'projectile-find-file)

(map! "s-f" #'consult-buffer)
(map! "s-F" #'consult-buffer-other-window)

(map! "s-]" #'next-window-any-frame)
(map! "s-[" #'previous-window-any-frame)

(map! "s-`" #'evil-window-increase-width)
(map! "s-~" #'evil-window-decrease-width)

(map! "s-." #'evil-window-increase-height)
(map! "s->" #'evil-window-decrease-height)

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

(setq
 lsp-idle-delay 0.1
 company-minimum-prefix-length 2
 company-idle-delay 0.0
 company-tooltip-minimum-width 50
 company-tooltip-maximum-width 50
 )

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

(after! org
  :custom
    (map! :nv "C-D" #'evil-multiedit-match-symbol-and-prev
        :nv "C-d" #'evil-multiedit-match-symbol-and-next))

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

(use-package org-roam
  :custom
  (org-roam-directory "~/org/roam")
  (org-roam-index-file "~/org/roam/index.org")
  )

(after! org
    (setq org-todo-keywords
        '((sequence  "PROJ(p)" "TODO(t)" "NEXT(n)" "WAITING(w)" "INPROGRESS(i)" "|" "DONE(d)" "CANCELED(c)")))
    (setq org-tag-alist '(("personal" . ?p) ("learning" . ?l) ("@home" . ?h) ("@work" . ?w) ("@computer" . ?c) ("errands" . ?e)))
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
