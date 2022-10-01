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
(setq me/doom-font-size 13)
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size me/doom-font-size)) ;; Fira Code,  :weight 'medium, :size 12
(setq doom-unicode-font (font-spec :family "JetBrainsMono Nerd Font" :size me/doom-font-size))
(setq doom-variable-pitch-font (font-spec :family "Fira Sans" :size me/doom-font-size))

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

(use-package edwina
  :config
  (advice-remove #'display-buffer #'edwina--display-buffer)
  (edwina-mode 1))

(defun edwina-mode-line-indicator ())

(defun me/edwina-window-arrange ()
  (interactive)
  "Create a window preserving layout"
  (me/edwina-treemacs-snapshot)

  (edwina-arrange)

  (me/edwina-treemacs-restore))

(defadvice! me/edwina-window-follow-xref-advice (&rest _)
  :after 'xref-find-definitions-other-window (me/edwina-window-arrange))

(defadvice! me/edwina-terminal-advice (&rest _)
  :after 'me/vterm-split-right (me/edwina-window-arrange))

(defun me/edwina-window-create ()
  (interactive)
  "Create a window preserving layout"
  (me/edwina-treemacs-snapshot)

  (evil-window-vnew nil nil)

  ; arrange windows
  (edwina-arrange)

  (me/edwina-treemacs-restore)
  ; go back to the previously selected window
  ; rather than being stuck in treemacs
  (evil-window-prev 0)
)

(map! "M-n" 'me/edwina-window-create)

(defun me/edwina-treemacs-restore ()
  (interactive)
  (require 'treemacs)
  "Restore treemacs if it was visible"
  (pcase me/treemacs-restore
    (`visible (if (doom-project-p)
                  (treemacs-add-and-display-current-project)
                (treemacs)))
    (_ (message "No need to restore Treemacs")))
)

(defun me/edwina-treemacs-snapshot ()
  (interactive)
  (require 'treemacs)
  "Save treemacs visibility and close it"
  (setq me/treemacs-restore (treemacs-current-visibility))

  ;; forcibly close treemacs (if open)
  (pcase (treemacs-current-visibility)
    (`visible (delete-window (treemacs-get-local-window)))
    (_ (message "Treemacs is not visible or open")))
)

(defun me/edwina-window-close ()
  (interactive)
  "Close a window preserving layout"
  (message "Edwina close")

  (me/edwina-treemacs-snapshot)
  (+workspace/close-window-or-workspace)
  (me/edwina-treemacs-restore)

  ; This causes treemacs to be displayed as master window...
  ; sometimes
  (evil-window-prev 0)
)

(map! :map persp-mode-map "M-w" 'me/edwina-window-close)

(defun me/edwina-window-zoom ()
    (interactive)
    "Zoom/cycle the selected window to/from master area."
    (if (eq (selected-window) (frame-first-window))
        (edwina-swap-next-window)
      (let ((pane (edwina-pane (selected-window))))
        (edwina-delete-window)
        (edwina-arrange (cons pane (edwina-pane-list)))
        ;; switch to master window
        (select-window (car (edwina--window-list))))))

(defun me/edwina-zoom-arrange ()
  (interactive)
  "Arrange currently selected window as the master window"
  (me/edwina-treemacs-snapshot)
  (me/edwina-window-zoom)
  (edwina-arrange)
  (me/edwina-treemacs-restore))

(map! "M-a" 'me/edwina-zoom-arrange)

(defun doom-popup-filter (in-buffer)
    (with-current-buffer in-buffer
      (progn
        (message "[EDWINA] checking buffer t[%s] ib[%s] pun[%s] pub[%s] pu[%s] cb[%s] pm[%s]"
                 (type-of in-buffer)
                 in-buffer
                 (+popup-buffer-p (buffer-name in-buffer))
                 (+popup-buffer-p in-buffer)
                 (+popup-buffer-p)
                 (current-buffer)
                 +popup-mode)
        (if (or (+popup-buffer-p)
                (cond
                 (( string-match-p "*" (buffer-name in-buffer)) t)      ; other
                 (( string-match-p " *" (buffer-name in-buffer)) t)     ; treemacs
                 (( string-match-p "Preview:" (buffer-name in-buffer)) t) ; lsp-ui follow-xref multiple implementation selection
                 (( string-match-p "magit" (buffer-name in-buffer)) t)
                 (t nil)))
            (progn (message "[EDWINA] Filter out %s" (buffer-name in-buffer)) t)
          (progn (message "[EDWINA] Allow %s" (buffer-name in-buffer)) nil)))))

(setq! edwina-buffer-filter #'doom-popup-filter)

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

(map! "M-±" #'resize-window)

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

(setq
 display-time-format "w%U"
 display-time-default-load-average nil)
(display-time)

(setq doom-modeline-buffer-file-name-style 'file-name)

(map! :leader :desc "Open Dashboard" "d" #'+doom-dashboard/open)

(map! "M-;" 'execute-extended-command)

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

(remove-hook 'doom-first-input-hook #'evil-snipe-mode)
(with-eval-after-load 'evil-maps
  (define-key evil-normal-state-map (kbd "s") 'evil-ex-search-forward)
  (define-key evil-normal-state-map (kbd "S") 'evil-ex-search-backward))

(map! "M-]" #'next-window-any-frame)
(map! "M-[" #'previous-window-any-frame)

(map! "M-w" 'delete-window)

(map! "M-y" '+vterm/toggle)

(map! "M-g" #'xref-find-definitions-other-window)

(map! "M-k" 'evil-scroll-up)
(map! "M-j" 'evil-scroll-down)

(after! evil-org
  (define-key evil-org-mode-map (kbd "<normal-state> M-k") 'evil-scroll-up)
  (define-key evil-org-mode-map (kbd "<normal-state> M-j") 'evil-scroll-down))

(with-eval-after-load 'evil-maps
  (define-key evil-normal-state-map (kbd "M-,") 'goto-last-change-reverse)
  (define-key evil-normal-state-map (kbd "M-.") 'goto-last-change))

(map! :ne "M-/" #'comment-or-uncomment-region)

(map! :desc "Paste from clipboard" "M-v" 'clipboard-yank)
(map! :desc "Copy into clipboard" "M-c" 'copy-region-as-kill)

(map! :leader :desc "Visually mark paragraph" "v p" 'er/mark-paragraph)
(map! :leader :desc "Visually mark word" "v w" 'er/mark-word)

(map! "M-i" #'consult-yasnippet)

(after! evil-org
  (define-key evil-org-mode-map (kbd "<visual-state> M-l") 'org-insert-link))

(global-set-key (kbd "C-c e") 'org-edit-src-code)

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

(use-package expand-region
  :bind ("M-=" . er/expand-region))

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

(defun me/magit-commit-setup ()
  (insert (concat (magit-get-current-branch) ": ")))

(add-hook 'git-commit-setup-hook 'me/magit-commit-setup)

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

(map! "M-§" 'me/switch-workspace)

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

; Disabling as it causes errors when buffers as killed before the result is computed,
; usually while switching quickly between org files
;(add-hook 'org-mode-hook 'me/org-enable-literate-calc-minor-mode)

;; see https://github.com/doomemacs/doomemacs/issues/4815#issue-834176237
(add-to-list 'git-gutter:disabled-modes 'org-mode)

(setq company-global-modes '(not org-mode))

(setq org-archive-location (concat "archive/archive-"
                                   (format-time-string "%Y%m" (current-time)) ".org_archive::"))

(setq org-capture-bookmark nil)

(setq org-capture-templates
    '(("t" "TODO" entry (file+headline +org-capture-todo-file "Inbox")
       "* TODO %? %U\n%i\n%a" :prepend t)
      ("n" "Notes" entry (file+headline +org-capture-notes-file "Inbox")
       "* %u %?\n%i\n%a" :prepend t)
      ("j" "Journal" entry (file+olp+datetree +org-capture-journal-file)
       "* %U %?\n%i\n%a" :prepend t)))

(defun me/org-capture-todo (type &optional arg)
  (interactive "P")
  (org-capture arg type))

(map! :leader :desc "Capture a TODO item" "c t" (lambda() (interactive) (me/org-capture-todo "t")))
(map! :leader :desc "Capture a new note" "c n" (lambda() (interactive) (me/org-capture-todo "n")))
(map! :leader :desc "Capture a new journal entry" "c j" (lambda() (interactive) (me/org-capture-todo "j")))

(map! "M-o" 'org-agenda)

(setq org-agenda-custom-commands
      '(
        ("w" "List :work: TODO/WAITING|INPROGRESS|NEXT"
          ((tags "work/TODO|WAITING|INPROGRESS|NEXT")))
        ("d" "List :docs: TODO/WAITING|INPROGRESS|NEXT"
          ((tags "docs/TODO|WAITING|INPROGRESS|NEXT")))
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

(defun me/org-agenda-view (type &optional arg)
  (interactive "P")
  (split-window-horizontally)
  (other-window 1)
  (org-agenda arg type))

(map! :leader :desc "Work view" "o a w" (lambda() (interactive) (me/org-agenda-view "w")))
(map! :leader :desc "Docs view" "o a d" (lambda() (interactive) (me/org-agenda-view "d")))
(map! :leader :desc "Personal view" "o a p" (lambda() (interactive) (me/org-agenda-view "p")))
(map! :leader :desc "Projects view" "o a P" (lambda() (interactive) (me/org-agenda-view "P")))
(map! :leader :desc "Emacs view" "o a e" (lambda() (interactive) (me/org-agenda-view "e")))
(map! :leader :desc "Learning view" "o a l" (lambda() (interactive) (me/org-agenda-view "l")))

(setq org-agenda-prefix-format "%t %s")

(use-package org-modern
  :config
  (setq org-modern-star nil)
  (setq org-modern-timestamp nil)
  (setq org-modern-todo nil)
  (setq org-modern-tag nil)
  (setq org-modern-statistics nil)
  (setq org-modern-hide-stars nil)
  (custom-set-faces
   '(org-modern-block-name ((t nil))))
  (global-org-modern-mode))

(use-package org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default nil))

(setq plantuml-jar-path "/usr/local/bin/plantuml.jar")
(setq plantuml-default-exec-mode 'jar)

(org-babel-do-load-languages
 'org-babel-load-languages
 '(;; other Babel languages
   (plantuml . t)))

(use-package! ob-http
  :commands org-babel-execute:http)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (http . t)))

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
        '((sequence  "REPEAT(r)" "PROJ(p)" "TODO(t)" "NEXT(n)" "WAITING(w)" "INPROGRESS(i)" "|" "DONE(d)" "CANCELED(c)")))
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
  :defer t)

(setq org-pomodoro-format "%s"
      org-pomodoro-start-sound-p t
      org-pomodoro-short-break-length 10)

(setq org-clock-clocked-in-display 'mode-line)

(setq org-clock-heading-function
      (lambda ()
        (let ((str (nth 4 (org-heading-components))))
          (if (> (length str) 8)
              (substring str 0 8)))))

(setq me/org-pomodoro-bell-sound "~/.doom.d/resources/bell-ring-01.wav")
(setq org-pomodoro-finished-sound me/org-pomodoro-bell-sound
      org-pomodoro-start-sound me/org-pomodoro-bell-sound
      org-pomodoro-long-break-sound me/org-pomodoro-bell-sound
      org-pomodoro-short-break-sound me/org-pomodoro-bell-sound
      org-pomodoro-ticking-sound me/org-pomodoro-bell-sound
      org-pomodoro-overtime-sound me/org-pomodoro-bell-sound)

(setq me/org-pomodoro-sound-args "-volume 0.5")
(setq org-pomodoro-finished-sound-args me/org-pomodoro-sound-args
      org-pomodoro-long-break-sound-args me/org-pomodoro-sound-args
      org-pomodoro-start-sound-args me/org-pomodoro-sound-args
      org-pomodoro-short-break-sound-args me/org-pomodoro-sound-args
      org-pomodoro-ticking-sound-args me/org-pomodoro-sound-args)

(use-package vterm
  :defer t
  :custom
  (vterm-shell "fish")
  (setq vterm-timer-delay 0))

(after! vterm
  (map! :map vterm-mode-map "M-v" 'vterm-yank)
  (map! :map vterm-mode-map "M-w" '+workspace/close-window-or-workspace))

(defun me/vterm-split-right ()
  "Create a new vterm window to the right of the current one."
  (interactive)
  (let* ((ignore-window-parameters t)
         (dedicated-p (window-dedicated-p)))
    (split-window-horizontally)
    (other-window 1)
    (+vterm/here default-directory)))

(map! :leader :desc "Open vterm vsplit" "o T" #'me/vterm-split-right)

(defun run-command-recipe-example ()
  (list
   (list :display "Run APv2 locally"
         :command-name "*www-admin-v2-local"
         :command-line "npm start"
         :working-dir "~/Playground/www-admin-v2")
   (list :display "Tail error logs"
         :command-name "*exads-tail"
         :command-line "vagrant ssh web -c 'sudo -i tail -f /var/log/php/error.log'"
         :working-dir "~/sys-vagrant/code")
   (list :display "Start VM"
         :command-name "*exads-up"
         :command-line "vagrant up"
         :working-dir "~/sys-vagrant/code")
   (list :display "Stop VM"
         :command-name "*exads-down"
         :command-line "vagrant halt"
         :working-dir "~/sys-vagrant/code")
   ))

(use-package run-command
  :config
  (add-to-list 'run-command-recipes 'run-command-recipe-example))

(use-package multi-vterm
    :config
    (add-hook 'vterm-mode-hook
            (lambda ()
            (setq-local evil-insert-state-cursor 'box)
            (evil-insert-state)))
    (define-key vterm-mode-map [return]                      #'vterm-send-return)

    (setq vterm-keymap-exceptions nil)
    (evil-define-key 'insert vterm-mode-map (kbd "C-e")      #'vterm--self-insert)
    (evil-define-key 'insert vterm-mode-map (kbd "C-f")      #'vterm--self-insert)
    (evil-define-key 'insert vterm-mode-map (kbd "C-a")      #'vterm--self-insert)
    (evil-define-key 'insert vterm-mode-map (kbd "C-v")      #'vterm--self-insert)
    (evil-define-key 'insert vterm-mode-map (kbd "C-b")      #'vterm--self-insert)
    (evil-define-key 'insert vterm-mode-map (kbd "C-w")      #'vterm--self-insert)
    (evil-define-key 'insert vterm-mode-map (kbd "C-u")      #'vterm--self-insert)
    (evil-define-key 'insert vterm-mode-map (kbd "C-d")      #'vterm--self-insert)
    (evil-define-key 'insert vterm-mode-map (kbd "C-n")      #'vterm--self-insert)
    (evil-define-key 'insert vterm-mode-map (kbd "C-m")      #'vterm--self-insert)
    (evil-define-key 'insert vterm-mode-map (kbd "C-p")      #'vterm--self-insert)
    (evil-define-key 'insert vterm-mode-map (kbd "C-j")      #'vterm--self-insert)
    (evil-define-key 'insert vterm-mode-map (kbd "C-k")      #'vterm--self-insert)
    (evil-define-key 'insert vterm-mode-map (kbd "C-r")      #'vterm--self-insert)
    (evil-define-key 'insert vterm-mode-map (kbd "C-t")      #'vterm--self-insert)
    (evil-define-key 'insert vterm-mode-map (kbd "C-g")      #'vterm--self-insert)
    (evil-define-key 'insert vterm-mode-map (kbd "C-c")      #'vterm--self-insert)
    (evil-define-key 'insert vterm-mode-map (kbd "C-SPC")    #'vterm--self-insert)
    (evil-define-key 'normal vterm-mode-map (kbd "C-d")      #'vterm--self-insert)
    (evil-define-key 'normal vterm-mode-map (kbd ",c")       #'multi-vterm)
    (evil-define-key 'normal vterm-mode-map (kbd ",n")       #'multi-vterm-next)
    (evil-define-key 'normal vterm-mode-map (kbd ",p")       #'multi-vterm-prev)
    (evil-define-key 'normal vterm-mode-map (kbd "i")        #'evil-insert-resume)
    (evil-define-key 'normal vterm-mode-map (kbd "o")        #'evil-insert-resume)
    (evil-define-key 'normal vterm-mode-map (kbd "<return>") #'evil-insert-resume))

(defun me/elfeed-view ()
  (elfeed-update)
  (elfeed-goodies/setup)
  (elfeed))

(use-package elfeed
  :defer t
  :config
  (add-hook 'elfeed-show-mode-hook #'elfeed-update)
  (add-hook  'elfeed-show-mode-hook 'variable-pitch-mode)
  (map! "M-e" 'me/elfeed-view)
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
