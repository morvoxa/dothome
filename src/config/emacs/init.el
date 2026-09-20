;; Set up package.el to work with MELPA  -*- lexical-binding: t; -*-
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror)
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; Download Evil
(unless (package-installed-p 'evil)
  (package-install 'evil))
(unless (package-installed-p 'atom-dark-theme)
  ;; Download Colorscheme
  (package-install 'atom-dark-theme))
(load-theme 'atom-dark t)
;; backup
(setq backup-directory-alist `(("." . ,(expand-file-name "backups" user-emacs-directory))))
;; Enable Evil
(require 'evil)
(evil-mode 1)
(set-face-attribute 'default nil :font "JetBrains Mono Nerd Font" :height 120)
(with-eval-after-load 'evil
  (evil-set-leader 'normal (kbd "SPC"))
  (define-key evil-normal-state-map (kbd "<leader> f") 'find-file)
  (define-key evil-normal-state-map (kbd "<leader> o") 'cd)
  (define-key evil-normal-state-map (kbd "<leader> r") 'eval-buffer)
  (define-key evil-normal-state-map (kbd "<leader> c") 'compile)
  (evil-define-key 'normal 'global (kbd "<leader> x") 'kill-current-buffer)
  (evil-define-key 'normal 'global (kbd "<leader> q") 'kill-emacs)
  (define-key evil-insert-state-map (kbd "j k") 'evil-normal-state)
  (evil-define-key 'normal 'global (kbd "<leader> w") 'save-buffer)
  (define-key evil-normal-state-map (kbd "<leader> e") 
	      (lambda () (interactive) (find-file ".")))

  (evil-define-key 'normal 'global (kbd "<leader> v") 'other-window))

;;ido
(ido-mode 1)
(setq ido-enable-flex-matching t)
(setq ido-confirm-unique-completion nil)
(setq ido-auto-merge-work-directories-length -1)

(with-eval-after-load 'ido
  (define-key ido-file-completion-map (kbd "TAB") 'ido-complete)

  (defun my-ido-smart-enter ()
    (interactive)
    (let* ((current-match (car ido-matches))
           (typed-input ido-text)
           (target-path (if current-match
                            (expand-file-name current-match ido-current-directory)
                          (expand-file-name typed-input ido-current-directory))))
      
      (cond
       ;; Jika itu direktori, arahkan ke Dired lalu keluar dalam 1x enter
       ((file-directory-p target-path)
        (setq ido-exit 'dired)
        (exit-minibuffer))
       
       ;; Jika file baru atau file biasa, langsung keluar dan buat/buka file
       (t
        (setq ido-exit 'file)
        (exit-minibuffer)))))

  (define-key ido-file-completion-map (kbd "RET") 'my-ido-smart-enter))
;; Jump fast
(use-package avy
  :ensure t
  :bind
  (:map evil-normal-state-map
        ("s" . avy-goto-char-2))) 
;; lisp formater
(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (add-hook 'before-save-hook
                      (lambda ()
                        (save-excursion
                          (indent-region (point-min) (point-max))))
                      nil t)))

;;format-all
(unless (package-installed-p 'format-all)
  (package-install 'format-all))
(require 'format-all)
(add-hook 'prog-mode-hook 'format-all-mode)
(add-hook 'before-save-hook 'format-all-buffer)
