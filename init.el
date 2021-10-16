;; Setup ;;

(setq user-emacs-directory "~/.emacs.d") 
(setq inhibit-startup-message t)
(setq initial-buffer-choice "~/.emacs.d/OrgFiles/Hello.org")
;; (setq initial-buffer-choice "~/.emacs.d/Hello.org")
(setq make-backup-files nil)
(require 'package)

(setq package-archives '(
			 ;; ("melpa-stable" . "http://stable.melpa.org/packages/")
			 ("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))

(package-initialize)
;;(package-refresh-contents)
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

;; Packages ;;

(use-package org
  :ensure t)
(require 'org-tempo)
(require 'org-capture)
(setq org-ellipsis "↴")

;; making org mode prettier, reference below
;; https://zzamboni.org/post/beautifying-org-mode-in-emacs/

(use-package org-bullets
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(let* ((variable-tuple
	(cond ((x-list-fonts "ETBembo")         '(:font "ETBembo"))
	    ((x-list-fonts "Menlo") '(:font "Menlo")) ;; just using this font for now
	    ((x-list-fonts "Source Sans Pro") '(:font "Source Sans Pro"))
	    ((x-list-fonts "Verdana")         '(:font "Verdana"))
	    ((x-list-fonts "Lucida Grande")   '(:font "Lucida Grande"))
	    ((x-family-fonts "Sans Serif")    '(:family "Sans Serif"))
	    (nil (warn "Cannot find a Sans Serif Font.  Install Source Sans Pro."))))
	;;(base-font-color     (face-foreground 'default nil 'default))
	;;(headline           `(:inherit default :weight bold :foreground ,base-font-color)))
	(headline           `(:inherit default :weight bold)))
(custom-theme-set-faces
    'user
    `(org-level-8 ((t (,@headline ,@variable-tuple))))
    `(org-level-7 ((t (,@headline ,@variable-tuple))))
    `(org-level-6 ((t (,@headline ,@variable-tuple))))
    `(org-level-5 ((t (,@headline ,@variable-tuple))))
    `(org-level-4 ((t (,@headline ,@variable-tuple :height 1.1))))
    `(org-level-3 ((t (,@headline ,@variable-tuple :height 1.25))))
    `(org-level-2 ((t (,@headline ,@variable-tuple :height 1.5))))
    `(org-level-1 ((t (,@headline ,@variable-tuple :height 1.75))))
    `(org-document-title ((t (,@headline ,@variable-tuple :height 2.0 :underline nil))))))

(use-package evil
  :ensure t
  :config
  (evil-mode 1))

;; (use-package helm
;;   :ensure t)
;; (require 'helm-config)

(use-package ivy
  :ensure t
  :config
  (ivy-mode 1))

(use-package slime
  :ensure t)
;; (load (expand-file-name "~/.quicklisp/slime-helper.el"))
(setf inferior-lisp-program "/usr/local/bin/sbcl")

(use-package org-journal
  :ensure t)

(use-package plantuml-mode
  :ensure t)

(if (package-installed-p 'plantuml-mode)
  (progn
    (setq plantuml-jar-path "/Users/mitchshiotani/.emacs.d/Java/plantuml.1.2021.8.jar")
    (setq plantuml-default-exec-mode 'jar)))

(use-package auto-complete
  :ensure t
  :config
  (auto-complete-mode 1))

(use-package neotree
  :ensure t)
;; (global-set-key [f8] 'neotree-toggle)
(global-set-key (kbd "C-c a") 'neotree-toggle)
(evil-define-key 'normal neotree-mode-map (kbd "TAB") 'neotree-enter)
(evil-define-key 'normal neotree-mode-map (kbd "SPC") 'neotree-quick-look)
(evil-define-key 'normal neotree-mode-map (kbd "q") 'neotree-hide)
(evil-define-key 'normal neotree-mode-map (kbd "RET") 'neotree-enter)
(evil-define-key 'normal neotree-mode-map (kbd "g") 'neotree-refresh)
(evil-define-key 'normal neotree-mode-map (kbd "n") 'neotree-next-line)
(evil-define-key 'normal neotree-mode-map (kbd "p") 'neotree-previous-line)
(evil-define-key 'normal neotree-mode-map (kbd "A") 'neotree-stretch-toggle)
(evil-define-key 'normal neotree-mode-map (kbd "H") 'neotree-hidden-file-toggle)

;; Auto close parens
;; found from: https://stackoverflow.com/questions/5195963/emacs-auto-compelete-paren-indent-and-new-line-how-to

(define-minor-mode c-helpers-minor-mode
  "This mode contains little helpers for C developement"
  nil
  ""
  '(((kbd "{") . insert-c-block-parentheses))
)

(defun insert-c-block-parentheses ()
  (interactive)
  (insert "{")
  (newline)
  (newline)
  (insert "}")
  (indent-for-tab-command)
  (previous-line)
  (indent-for-tab-command))

;; ssh for Tramp
(setq tramp-default-method "ssh")

;; enabling minor modes globally
;; in case I end up wanting to do that:
;; https://stackoverflow.com/questions/16048231/how-to-enable-a-non-global-minor-mode-by-default-on-emacs-startup

;; enable word wrapping
(toggle-truncate-lines 1) 

;; set line numbers
(global-set-key (kbd "C-c l") 'display-line-numbers-mode)
(setq display-line-numbers-type 'relative)

;; Theme ;;

(use-package zenburn-theme
  :ensure t)
;; (load-theme 'zenburn t)
(load-theme 'deeper-blue t)
(set-face-attribute 'default nil :height 150)

;; Org mode ;;

(setq org-todo-keywords
  '((sequence "TODO"
      "MAYBE"
      ;; "NEXT"
      "DOING"
      ;; "WAITING"
      ;; "DELEGATED"
      "|"
      "DONE"
      "DEFERRED")))

;; trying out GTD on org mode, following this:
;; https://emacs.cafe/emacs/orgmode/gtd/2017/06/30/orgmode-gtd.html

(setq org-agenda-files '("~/.emacs.d/gtd/"
                         ;; "~/.emacs.d/gtd/gtd.org"
                         ;; "~/.emacs.d/gtd/tickler.org"))
                         "~/.emacs.d/OrgFiles/"))

(setq org-capture-templates '(("t" "Todo [inbox]" entry
                               (file+headline "~/.emacs.d/gtd/inbox.org" "Tasks")
                               "* TODO %i%?")
                              ("T" "Tickler" entry
                               (file+headline "~/.emacs.d/gtd/tickler.org" "Tickler")
                               "* %i%? \n %U")))

(setq org-refile-targets '(("~/.emacs.d/gtd/gtd.org" :maxlevel . 3)
                           ("~/.emacs.d/gtd/someday.org" :level . 1)
                           ("~/.emacs.d/gtd/tickler.org" :maxlevel . 2)))

;; keybinding for org-capture, should be C-c C-c by default but wasn't working for some reason
(global-set-key (kbd "C-c c") 'org-capture)
(setq org-src-preserve-indentation t)

;; Etc ;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#3F3F3F" "#CC9393" "#7F9F7F" "#F0DFAF" "#8CD0D3" "#DC8CC3" "#93E0E3" "#DCDCCC"])
 '(company-quickhelp-color-background "#4F4F4F")
 '(company-quickhelp-color-foreground "#DCDCCC")
 '(custom-safe-themes
   '("e6df46d5085fde0ad56a46ef69ebb388193080cc9819e2d6024c9c6e27388ba9" "ea5822c1b2fb8bb6194a7ee61af3fe2cc7e2c7bab272cbb498a0234984e1b2d9" default))
 '(fci-rule-color "#383838")
 '(nrepl-message-colors
   '("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3"))
 '(package-selected-packages
   '(auto-complete-mode neotree auto-complete plantuml-mode org-journal slime use-package ivy helm evil elscreen))
 '(pdf-view-midnight-colors '("#DCDCCC" . "#383838"))
 '(plantuml-jar-args nil)
 '(show-paren-mode t)
 '(vc-annotate-background "#2B2B2B")
 '(vc-annotate-color-map
   '((20 . "#BC8383")
     (40 . "#CC9393")
     (60 . "#DFAF8F")
     (80 . "#D0BF8F")
     (100 . "#E0CF9F")
     (120 . "#F0DFAF")
     (140 . "#5F7F5F")
     (160 . "#7F9F7F")
     (180 . "#8FB28F")
     (200 . "#9FC59F")
     (220 . "#AFD8AF")
     (240 . "#BFEBBF")
     (260 . "#93E0E3")
     (280 . "#6CA0A3")
     (300 . "#7CB8BB")
     (320 . "#8CD0D3")
     (340 . "#94BFF3")
     (360 . "#DC8CC3")))
 '(vc-annotate-very-old-color "#DC8CC3"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(toggle-menu-bar-mode-from-frame 0)
(toggle-tool-bar-mode-from-frame 0)
(toggle-scroll-bar -1)

(set-face-attribute 'default nil :font "Noto Sans Mono-11" )
(set-frame-font "Noto Sans Mono-11" nil t)

;; (evil-ex-define-cmd "ls" "buffers")
;; (evil-ex-define-cmd "buffers" 'buffer-menu-toggle-files-only)

;; Put autosave files (ie #foo#) and backup files (ie foo~) in ~/.emacs-backups/.
(custom-set-variables
  '(auto-save-file-name-transforms '((".*" "~/.emacs-backups/autosaves/\\1" t)))
  '(backup-directory-alist '((".*" . "~/.emacs-backups/backups/"))))

;; create the autosave dir if necessary, since emacs won't.
(make-directory "~/.emacs-backups/autosaves/" t)
(make-directory "~/.emacs-backups/backups/" t)
