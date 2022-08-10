#+TITLE: Emacs doom configuration
#+LANGUAGE: en
#+PROPERTY: header-args :tangle yes :cache yes :results silent :padline no

Place your private configuration here! Remember, you do not need to run 'doom sync' after modifying this file!

Some functionality uses this to identify you, e.g. GPG configuration, email clients, file templates and snippets. It is optional.

#+BEGIN_SRC emacs-lisp
(setq user-full-name "DC"
      user-mail-address "des@riseup.net")
#+END_SRC

Doom exposes five (optional) variables for controlling fonts in Doom:

- `doom-font' -- the primary font to use
- `doom-variable-pitch-font' -- a non-monospace font (where applicable)
- `doom-big-font' -- used for `doom-big-font-mode'; use this for
  presentations or streaming.
- `doom-unicode-font' -- for unicode glyphs
- `doom-serif-font' -- for the `fixed-pitch-serif' face

See 'C-h v doom-font' for documentation and more examples of what they accept. For example:

setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
     doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))

If you or Emacs can't find your font, use 'M-x describe-font' to look them up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to refresh your font settings. If Emacs still can't find your font, it likely wasn't installed correctly. Font issues are rarely Doom issues!

There are two ways to load a theme. Both assume the theme is installed and available. You can either set `doom-theme' or manually load a theme with the `load-theme' function. This is the default:

#+BEGIN_SRC emacs-lisp
(setq doom-theme 'doom-nord-light)
#+END_SRC

This determines the style of line numbers in effect. If set to `nil', line
numbers are disabled. For relative line numbers, set this to `relative'.

#+BEGIN_SRC emacs-lisp
(setq display-line-numbers-type t)
#+END_SRC

If you use `org' and don't want your org files in the default location below, change `org-directory'. It must be set before org loads!
#+BEGIN_SRC emacs-lisp
(setq org-directory "~/org/")
#+END_SRC

Whenever you reconfigure a package, make sure to wrap your config in an
  (after! PACKAGE
    (setq x y))

The exceptions to this rule:

  - Setting file/directory variables (like `org-directory')
  - Setting variables which explicitly tell you to set them before their
    package is loaded (see 'C-h v VARIABLE' to look up their documentation).
  - Setting doom variables (which start with 'doom-' or '+').

Here are some additional functions/macros that will help you configure Doom.

- `load!' for loading external *.el files relative to this one
- `use-package!' for configuring packages
- `after!' for running code after a package has loaded
- `add-load-path!' for adding directories to the `load-path', relative to
  this file. Emacs searches the `load-path' when you load packages with
  `require' or `use-package'.
- `map!' for binding new keys

To get information about any of these functions/macros, move the cursor over the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
This will open documentation for it, including demos of how they are used.
Alternatively, use `C-h o' to look up a symbol (functions, variables, faces, etc).

You can also try 'gd' (or 'C-c c d') to jump to their definition and see how they are implemented.

* Custom packages

This section contains custom packages and package configurations. Most of the configurations here are copy/pasted from the package repositories README.md or other sources. I added attribution/source wherever possible.

** Blamer
This package adds a blame legend besides the current line in version-controlled files.

It's somewhat handy but at the same time I can't see how I can jump to the diff for that blame, so I can't make it fully useful to me.

#+BEGIN_SRC emacs-lisp
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
#+END_SRC

TODO: Find out how to jump to the blame commit.

** Better Jumper
#+begin_src emacs-lisp
;; Better jump (remember jump list)
(use-package better-jumper
  :ensure t
  :config
  (better-jumper-mode +1))
(with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map (kbd "C-o") 'better-jumper-jump-backward)
  (define-key evil-motion-state-map (kbd "<C-i>") 'better-jumper-jump-forward))
#+end_src* General configs

** Super save
#+begin_src emacs-lisp
;; https://github.com/bbatsov/super-save
(use-package super-save
  :ensure t
  :config
  (super-save-mode +1))
#+end_src


* Custom keybindings

#+begin_src emacs-lisp
;; Comment or uncomment region with M-/
(map! :ne "M-/" #'comment-or-uncomment-region)

(map! :leader :desc "Dashboard" "d" #'+doom-dashboard/open)

;; Search with deadgrep
(map! :ne "SPC r" #'deadgrep)
#+end_src

* Magit
** Multi-git

#+begin_src emacs-lisp
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
#+end_src

* Project management
- Projectile
#+begin_src emacs-lisp
(after! projectile
   (setq
        projectile-project-search-path '("~/sys-vagrant/code/")
   )
)

(setq doom-modeline-enable-word-count t)
#+end_src

- Treemacs
#+begin_src emacs-lisp
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


#+end_src

* UI
- Show git gutter for unsaved changes, https://github.com/doomemacs/doomemacs/issues/2377#issuecomment-576117218
#+begin_src emacs-lisp
(after! git-gutter
  (setq git-gutter:update-interval 0.5))

#+end_src

- Center isearch: https://www.reddit.com/r/emacs/comments/6ewd0h/comment/dieb3dc/?utm_source=share&utm_medium=web2x&context=3
#+begin_src emacs-lisp
(advice-add 'evil-ex-search-next :after
            (lambda (&rest x) (evil-scroll-line-to-center (line-number-at-pos))))
(advice-add 'evil-ex-search-previous :after
            (lambda (&rest x) (evil-scroll-line-to-center (line-number-at-pos))))

#+end_src

- https://github.com/andre-r/centered-cursor-mode.el
#+begin_src emacs-lisp
(use-package centered-cursor-mode
  :demand
  :config
  ;; Optional, enables centered-cursor-mode in all buffers.
  (global-centered-cursor-mode))
#+end_src

- Ctrl+P / command launcher-like for M-x
#+begin_src emacs-lisp
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
#+end_src
