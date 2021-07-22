(require 'package)
(setq package-archives
      (append package-archives
              '(("melpa" . "https://melpa.org/packages/")
		("org" . "https://orgmode.org/elpa/"))))
(package-initialize)


(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(unless (package-installed-p 'org-plus-contrib)
  (use-package org
      :ensure org-plus-contrib))

;; Load Org-Babel defined config
(org-babel-load-file "~/dotfiles/config.org")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(js2-strict-missing-semi-warning nil)
 '(package-selected-packages
   '(org-anki xter-color xterm-color mocha-snippets import-js highlight-indent-guides rainbow-identifiers rainbow-delimiters org-download orderless expand-region org-superstar helm-ag dumb-jump dumbjump groovy-mode org-pomodoro indent-guide blacken which-key use-package treemacs-projectile tabbar origami org-roam org-plus-contrib org-bullets immaterial-theme helm fzf elpy dimmer color-theme-modern beacon all-the-icons))
 '(require-final-newline nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
