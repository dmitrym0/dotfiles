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
 '(org-roam-capture-templates
   '(("d" "default" plain "%?" :target
      (file+head "${slug}.org" "#+title: ${title}
")
      :unnarrowed t)))
 '(package-selected-packages
   '(better-defaults org-link-beautify virtualenv org lua-mode org-timeline org-gcal anki-editor wakatime-mode leetcode todoist org-anki xter-color xterm-color mocha-snippets import-js highlight-indent-guides rainbow-identifiers rainbow-delimiters org-download orderless expand-region org-superstar helm-ag dumb-jump dumbjump groovy-mode org-pomodoro indent-guide blacken which-key use-package treemacs-projectile tabbar origami org-roam org-plus-contrib org-bullets immaterial-theme helm fzf elpy dimmer color-theme-modern beacon all-the-icons))
 '(require-final-newline nil)
 '(safe-local-variable-values
   '((org-use-property-inheritance "calendar-id")
     (org-use-property-inheritance "FOO" "BAR")))
 '(wakatime-cli-path "/Users/dmitry/Library/Python/2.7/bin/wakatime")
 '(wakatime-python-bin nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(add-to-list 'exec-path "/opt/homebrew/bin")
(setq org-gcal-client-id "401590537325-hcoi6qoqu5gi6ofptuff2d3ifb41fied.apps.googleusercontent.com"
      org-gcal-client-secret "jgwx-RCNdO00BBP0Uj-udCww")

(setq wakatime-api-key "dda2eefc-4355-424a-aa6c-35ec09a44d59")
(setq org-roam-v2-ack t)

(setq debug-on-error t)
(add-hook 'org-agenda-mode-hook 'buffer-disable-undo)
