;; -*- lexical-binding: t; -*-
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror)
;; ====================================================================
;; PACKAGE REGISTER
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; ====================================================================
;; FONT CONFIG
(set-face-attribute 'default nil :font "JetBrains Mono Nerd Font" :height 100)

;; ====================================================================
;; INDENT CONFIG
(setq-default tab-width 2)
(setq-default evil-shift-width 2)
(setq-default standard-indent 2)
(setq make-backup-files nil)
(setq-default display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)


;; ====================================================================
;; EVIL MODE CONFIG
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
        (message "No Buffer")
      (dolist (buf buffers-to-kill)
        (kill-buffer buf))
      (message "%d Buffer closed!" (length buffers-to-kill)))))
(defun my/next-file-buffer ()
  (interactive)
  (let ((starting-buffer (current-buffer)))
    (next-buffer)
    (while (and (not (eq (current-buffer) starting-buffer))
                (not (buffer-file-name)))
      (next-buffer))))
(defun my/previous-file-buffer ()
  (interactive)
  (let ((starting-buffer (current-buffer)))
    (previous-buffer)
    (while (and (not (eq (current-buffer) starting-buffer))
                (not (buffer-file-name)))
      (previous-buffer))))
(use-package evil
  :ensure t
  :init
  (evil-mode 1)
  :config
  (with-eval-after-load 'evil
		(define-key evil-insert-state-map (kbd "C-y") nil)
		;; LEADER KEY SPACE
    (evil-set-leader 'normal (kbd "SPC"))
		(evil-set-initial-state 'dired-mode 'normal)
		;; FIX EVIL TAB
    (define-key evil-insert-state-map (kbd "TAB") 
								(lambda () 
									(interactive)
									(execute-kbd-macro (kbd "M-i"))))
		(define-key evil-normal-state-map (kbd "<leader> f") 'find-file)
		(define-key evil-normal-state-map (kbd "<leader> c") 'compile)
		(define-key evil-normal-state-map (kbd "<leader> e") (lambda () (interactive) (find-file ".")))
		(define-key evil-normal-state-map (kbd "C-l") 'my/next-file-buffer)
		(define-key evil-normal-state-map (kbd "C-h") 'my/previous-file-buffer)
    (define-key evil-normal-state-map (kbd "<leader> r") 'my/kill-other-buffers)
    (define-key evil-normal-state-map (kbd "<leader> x") 'kill-current-buffer)
    (define-key evil-normal-state-map (kbd "<leader> q") 'about-emacs)
    (define-key evil-normal-state-map (kbd "<leader> w") 'save-buffer)
    (define-key minibuffer-local-map (kbd "C-p") 'previous-history-element)
    (define-key minibuffer-local-map (kbd "C-n") 'next-history-element)
    (define-key evil-normal-state-map (kbd "<leader> v") 'other-window)))
;; ====================================================================
;; DIRED REMAP
(require 'dired)
(put 'dired-find-alternate-file 'disabled nil)
(with-eval-after-load 'dired
	(define-key dired-mode-map (kbd "a")  #'dired-create-empty-file)
	(define-key dired-mode-map (kbd "f") nil)
	(define-key dired-mode-map (kbd "c") nil)
	(define-key dired-mode-map (kbd "SPC") nil))

;; ====================================================================
;; FZF CONFIG & IDO
(ido-mode 1)
(defun my/ido-custom-keys ()
	"Konfigurasi remap tombol khusus untuk Ido-mode."
	(define-key ido-completion-map (kbd "C-n") 'ido-next-match)
	(define-key ido-completion-map (kbd "C-p") 'ido-prev-match)
	(define-key ido-completion-map (kbd "RET") 'ido-select-text))

(add-hook 'ido-setup-hook #'my/ido-custom-keys)

;; ====================================================================
;; JK REMAP 
(use-package key-chord
	:ensure t
	:config
	(key-chord-mode 1)
	(key-chord-define evil-insert-state-map "jk" 'evil-normal-state))

;; ====================================================================
;; COLOSCHEME
(load-theme 'modus-vivendi t)
(setq compile-command "")

;; ====================================================================
;; ENV PATH FIX
(use-package exec-path-from-shell
	:ensure t
	:config
	(exec-path-from-shell-initialize))

;; ====================================================================
;;JUMP
(use-package avy
	:ensure t
	:bind
	(:map evil-normal-state-map
				("s" . avy-goto-char-2)))

;; ====================================================================
;; AUTOPAIRS
(setq electric-pair-pairs
			'(
				(?\{ . ?\})
				(?\' . ?\')
				(?\` . ?\`)
				))
(electric-pair-mode 1)

;; ====================================================================
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

;; ====================================================================
;; COMPILE COMMAND CUSTOMIZE
(defun my-compile-prompt-advice (orig-fun prompt &rest args)
	"Mengubah prompt read-shell-command khusus saat kompilasi agar menampilkan pwd."
	(if (string-prefix-p "Compile command: " prompt)
			(let* ((clean-pwd (abbreviate-file-name default-directory))
						 (pwd-info (propertize (format " (in %s)" clean-pwd) 'face 'shadow))
						 (new-prompt (format "Compile command%s: " pwd-info)))
				(apply orig-fun new-prompt args))
		(apply orig-fun prompt args)))
(advice-add 'read-shell-command :around #'my-compile-prompt-advice)
;;FORMATTER
(use-package apheleia
	:ensure t
	:init
	(apheleia-global-mode +1)
	:config
	(setf (alist-get 'oxfmt apheleia-formatters) 
				'("apheleia-npx" "oxfmt" inplace))
	(setf (alist-get 'js-mode apheleia-mode-alist) 'oxfmt)
	(setf (alist-get 'js-ts-mode apheleia-mode-alist) 'oxfmt)
	(setf (alist-get 'typescript-mode apheleia-mode-alist) 'oxfmt)
	(setf (alist-get 'typescript-ts-mode apheleia-mode-alist) 'oxfmt)
	(setf (alist-get 'tsx-ts-mode apheleia-mode-alist) 'oxfmt)
	(setf (alist-get 'html-ts-mode apheleia-mode-alist) 'oxfmt)
	(setf (alist-get 'json-ts-mode apheleia-mode-alist) 'oxfmt)
	(setf (alist-get 'css-ts-mode apheleia-mode-alist) 'oxfmt))

;; ====================================================================

;;(use-package fzf
;;:ensure t
;;:init
;;(defun my/fzf-project-files ()
;;(interactive)
;;(if-let ((proj (project-current)))
;;(let ((default-directory (project-root proj)))
;;(fzf-find-file))
;;(fzf-find-file)))
;;
;;(with-eval-after-load 'evil
;;(evil-define-key 'normal 'global (kbd "<leader>f") 'my/fzf-project-files))
;;:config
;;(setq fzf/window-height 40))


;; ====================================================================
;; Konfigurasi Web Development dengan Dukungan Tree-sitter (-ts)
;; ====================================================================

;;;; AUTO TREESITTER
;;(use-package treesit-auto
;;:ensure t
;;:custom
;;(treesit-auto-install 'prompt)
;;:config
;;(treesit-auto-add-to-auto-mode-alist 'all)
;;(global-treesit-auto-mode))
;;
;;
;;;; 1. Setup Corfu (Frontend tampilan popup yang cepat & bersih)
;;(use-package yasnippet
;;:ensure t
;;:config
;;(yas-global-mode 1))
;;(use-package yasnippet-snippets
;;:ensure t
;;:after yasnippet)
;;(use-package company
;;:ensure t
;;:defer t
;;:init
;;(add-hook 'after-init-hook 'global-company-mode)
;;:config
;;(setq company-minimum-prefix-length 2
;;company-idle-delay 0.0)
;;(define-key company-mode-map (kbd "C-y") 'company-complete-selection)
;;
;;
;;(setq company-backends '((company-capf :with company-yasnippet company-dabbrev-code)
;;company-files
;;company-keywords
;;company-dabbrev))
;;(add-hook 'eglot-managed-mode-hook
;;(lambda ()
;;(setq-local company-backends '((company-capf :with company-yasnippet company-dabbrev-code)
;;company-files
;;company-keywords)))))
;;
;;(use-package company-box
;;:ensure t
;;:after company
;;:hook (company-mode . company-box-mode))
;;
;;
;;(use-package eglot
;;:ensure t
;;:defer t
;;:hook ((html-ts-mode . eglot-ensure)
;;(tsx-ts-mode  . eglot-ensure)
;;(js-ts-mode   . eglot-ensure)
;;(css-ts-mode   . eglot-ensure)
				 ;;;;low-level
;;(c-ts-mode   . eglot-ensure)
;;(c++-ts-mode      . eglot-ensure))
;;:config
;;(add-to-list
;;'eglot-server-programs
;;'((tsx-ts-mode css-ts-mode js-ts-mode html-ts-mode)
;;. ("emmet-language-server" "--stdio")))
;;(add-to-list
;;'eglot-server-programs
;;'((c-ts-mode c++-ts-mode)
;;. ("clangd"))))
