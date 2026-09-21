;; -*- lexical-binding: t; -*-
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; FONT CONFIG
(set-face-attribute 'default nil :font "JetBrains Mono Nerd Font" :height 100)
;; INDENT CONFIG
(setq-default tab-width 2)
(setq-default evil-shift-width 2)
(setq-default standard-indent 2)

(defun my/kill-other-buffers ()
  "Menutup semua buffer file lain, kecuali buffer aktif."
  (interactive)
  (let* ((current (current-buffer))
         (buffers-to-kill
          (cl-remove-if-not (lambda (buf)
                              (and (not (eq buf current))
                                   (buffer-file-name buf)))
                            (buffer-list))))
    (if (null buffers-to-kill)
        (message "Tidak ada buffer lain yang perlu ditutup!")
      (dolist (buf buffers-to-kill)
        (kill-buffer buf))
      (message "Berhasil menutup %d buffer file!" (length buffers-to-kill)))))

;; EVIL MODE CONFIG
(use-package evil
  :ensure t
  :init
  (evil-mode 1)
  :config
  (with-eval-after-load 'evil
		;; LEADER KEY SPACE
    (evil-set-leader 'normal (kbd "SPC"))
		;; FIX EVIL TAB
    (define-key evil-insert-state-map (kbd "TAB") 
								(lambda () 
									(interactive)
									(execute-kbd-macro (kbd "M-i"))))
    (define-key evil-normal-state-map (kbd "<leader> r") 'my/kill-other-buffers)
    (define-key evil-normal-state-map (kbd "<leader> c") 'compile)
    (define-key evil-normal-state-map (kbd "<leader> x") 'kill-current-buffer)
    (define-key evil-normal-state-map (kbd "<leader> q") 'about-emacs)
    (define-key evil-normal-state-map (kbd "<leader> w") 'save-buffer)
    (define-key evil-normal-state-map (kbd "<leader> e") 'dired-jump)
    (define-key evil-normal-state-map (kbd "<leader> v") 'other-window)))
;; FZF CONFIG 
(use-package fzf
  :ensure t
  :init
  (defun my/fzf-project-files ()
    "Langsung cari file pakai fzf di dalam project root aktif saat ini."
    (interactive)
    (if-let ((proj (project-current)))
        (let ((default-directory (project-root proj)))
          (fzf-find-file))
      (fzf-find-file)))

  (with-eval-after-load 'evil
    (evil-define-key 'normal 'global (kbd "<leader>f") 'my/fzf-project-files))

  :config
  (setq fzf/window-height 40))


;; DIRED REMAP
(require 'dired)
(put 'dired-find-alternate-file 'disabled nil)

(with-eval-after-load 'dired
	(define-key dired-mode-map (kbd "a")  #'dired-create-empty-file)
	
	(when (bound-and-true-p evil-mode)
		(evil-define-key 'normal dired-mode-map 
			(kbd "h") 'dired-up-directory
			(kbd "l") 'dired-find-alternate-file)))

;; JK REMAP 
(use-package key-chord
	:ensure t
	:config
	(key-chord-mode 1)
	(key-chord-define evil-insert-state-map "jk" 'evil-normal-state))


;; COLOSCHEME
(load-theme 'modus-vivendi t)
(setq compile-command "")
;; ENV PATH FIX
(use-package exec-path-from-shell
	:ensure t
	:config
	(exec-path-from-shell-initialize))

(use-package avy
	:ensure t
	:bind
	(:map evil-normal-state-map
				("s" . avy-goto-char-2)))
;; FORMATTER
(use-package apheleia
	:ensure t
	:init
	(apheleia-global-mode 1))
;; AUTO TREESITTER
(use-package treesit-auto
	:ensure t
	:custom
	(treesit-auto-install 'prompt)
	:config
	(treesit-auto-add-to-auto-mode-alist 'all)
	(global-treesit-auto-mode))
;; AUTOPAIRS
(setq electric-pair-pairs
			'(
				(?\{ . ?\})
				(?\' . ?\')
				(?\` . ?\`)
				(?\< . ?\>)
				))
(electric-pair-mode 1)
;; COMPILE TRUE COLOR

(use-package xterm-color
  :ensure t
  :init
  (setq compilation-environment '("TERM=xterm-256color"))
  
  :config
  (defun my/xterm-color-compilation-filter (orig-fun proc string)
    (funcall orig-fun proc (xterm-color-filter string)))
  
  (advice-add 'compilation-filter :around #'my/xterm-color-compilation-filter))
(defun my/switch-to-compilation-window (proc)
  "Memaksa kursor aktif pindah ke jendela proses kompilasi baru."
  (run-at-time "0.1 sec" nil
               (lambda (p)
                 (let ((win (get-buffer-window (process-buffer p) 'visible)))
                   (when win
                     (select-window win))))
               proc))

(add-hook 'compilation-start-hook #'my/switch-to-compilation-window)
