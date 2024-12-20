(setq user-emacs-directory (file-truename "~/.emacs.d/"))
(setq org-directory (file-truename "~/org-roam/"))

(require 'package)
(add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/") t)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)
(push (expand-file-name "extra" user-emacs-directory) load-path)
(push (expand-file-name "./elpa/project-0.8.1") load-path)
(use-package projectile :ensure t)
(use-package wakatime-mode :ensure t)

(message "Load custom file.")
(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file)
