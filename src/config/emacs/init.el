;; -*- lexical-binding: t; -*-
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; font fix
(set-face-attribute 'default nil :font "JetBrains Mono Nerd Font" :height 100)
;; evil fix fix
(setq-default tab-width 2)          ; Lebar tampilan karakter tab
(setq-default evil-shift-width 2)   ; Jarak geser saat pakai << atau >>
(setq-default standard-indent 2)

(defun my-unified-find-file ()
  (interactive)
  (let ((locked-dir default-directory))
    (call-interactively 'find-file)
    (setq default-directory locked-dir)))


(use-package evil
  :ensure t
  :init
  (evil-mode 1)
  :config
  (with-eval-after-load 'evil

    (define-key evil-insert-state-map (kbd "C-y") nil)
    (define-key evil-insert-state-map (kbd "C-n") nil)
    (define-key evil-insert-state-map (kbd "C-p") nil)
    (evil-set-leader 'normal (kbd "SPC"))
    (define-key evil-insert-state-map (kbd "TAB") 
								(lambda () 
									(interactive)
									(execute-kbd-macro (kbd "M-i"))))
    (define-key evil-normal-state-map (kbd "<leader> f") 'my-unified-find-file)
    (define-key evil-normal-state-map (kbd "<leader> o") 'cd)
    (define-key evil-normal-state-map (kbd "<leader> r") 'eval-buffer)
    (define-key evil-normal-state-map (kbd "<leader> c") 'compile)
    (define-key evil-normal-state-map (kbd "<tab>") 'indent-for-tab-command)
    (define-key evil-normal-state-map (kbd "<leader> e") (lambda () (interactive) (find-file "."))))
  (define-key evil-normal-state-map (kbd "C-i") 'scroll-down-command)
  (define-key evil-normal-state-map (kbd "<tab>") 'indent-for-tab-command)
  (evil-define-key 'normal 'global (kbd "<leader> x") 'kill-current-buffer )
  (evil-define-key 'normal 'global (kbd "<leader> q") 'about-emacs)
  ;;write
  (evil-define-key 'normal 'global (kbd "<leader> w") 'save-buffer)
  (evil-define-key 'normal 'global (kbd "<leader> v") 'other-window))



(require 'dired)
(put 'dired-find-alternate-file 'disabled nil)

(with-eval-after-load 'dired
  ;; dired map
  (define-key dired-mode-map (kbd "a")  #'dired-create-empty-file)
  (define-key dired-mode-map (kbd "y") #'dired-copy-filename-as-kill)
  (define-key dired-mode-map (kbd "d") #'dired-do-flag-delete)
  (define-key dired-mode-map (kbd "u")  #'dired-unmark)
  
  (when (bound-and-true-p evil-mode)
    (evil-define-key 'normal dired-mode-map 
      (kbd "h") 'dired-up-directory
      (kbd "l") 'dired-find-alternate-file)))
;;; auto remove dired buffer
(defun my-dired-reuse-buffer-advice (orig-fun &rest args)
  (if (file-directory-p (dired-get-file-for-visit))
      (dired-find-alternate-file)
    (apply orig-fun args)))




;; j k ke normal mode
(use-package key-chord
  :ensure t
  :config
  (key-chord-mode 1)
  (key-chord-define evil-insert-state-map "jk" 'evil-normal-state))


;; colorshcme
(load-theme 'modus-vivendi t)
(setq compile-command "")
;;ido 
(require 'ido)
(ido-mode 1)
(ido-everywhere 1)
(setq ido-enable-flex-matching t)
(setq ido-use-virtual-buffers t)

(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

(use-package avy
  :ensure t
  :bind
  (:map evil-normal-state-map
        ("s" . avy-goto-char-2)))
;;formtter
(use-package apheleia
  :ensure t
  :init
  (apheleia-global-mode 1))
;;tree sitter
(use-package treesit-auto
  :ensure t
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))
;; auto pairs
(setq electric-pair-pairs
      '(
        (?\{ . ?\})
        (?\' . ?\')
        (?\` . ?\`)
        (?\< . ?\>)
        ))
(electric-pair-mode 1)


;;(use-package ivy
;;:ensure t
;;:diminish
;;:config
;;(ivy-mode 1)
  ;;;; Mengaktifkan pencocokan fleksibel (mirip flex matching di ido)
;;(setq ivy-re-builders-alist
;;'((t . ivy--regex-plus)))
;;(setq ivy-use-virtual-buffers t)
;;(setq ivy-count-format "(%d/%d) "))
;;(use-package counsel
;;:ensure t
;;:after ivy
;;:config
;;(counsel-mode 1))
;;(use-package ivy-prescient
;;:ensure t
;;:after counsel
;;:config
  ;;;; Mengingat riwayat pilihan sebelumnya
;;(prescient-persist-mode 1)
;;(ivy-prescient-mode 1))
;;
;;(use-package nerd-icons-ivy-rich
;;:ensure t
;;:after counsel
;;:init
;;(nerd-icons-ivy-rich-mode 1)
;;(ivy-rich-mode 1))

;;avy
;;;; completion lsp
;;(use-package corfu
;;:ensure t
;;:custom
;;(corfu-auto t)
;;(corfu-cycle t)
;;(corfu-auto-delay 0.0)      ; Instan tanpa jeda layaknya VS Code
;;(corfu-auto-prefix 1)       ; Ketik 1 huruf langsung memicu popup
;;:bind (:map corfu-map
;;("C-n" . corfu-next)
;;("C-p" . corfu-previous)
;;("C-y" . corfu-insert))
;;:init
;;(global-corfu-mode)
;;(corfu-popupinfo-mode 1))
;;
;;(unless (package-installed-p 'yasnippet)
;;(package-install 'yasnippet))
;;(require 'yasnippet)
;;(yas-global-mode 1)
;;
;;(use-package eglot
;;:ensure nil
;;:config
  ;;;; Gunakan setq murni untuk keamanan jalur server
;;(setq eglot-server-programs
;;'((rust-mode . ("rust-analyzer"))
;;((typescript-ts-mode tsx-ts-mode ) . ("vtsls" "--stdio"))
;;((  c-ts-mode c++-ts-mode) . ("clangd"))))
;;
  ;;;; Jembatan filter Corfu agar Eglot tidak menyembunyikan data completion
;;(setq completion-category-overrides '((eglot (styles basic substring)))))
;;
;;;; =====================================================================
;;;; FORCE AUTO-START EGLOT
;;;; =====================================================================
;;;; Daftarkan semua mode sekaligus dalam sebuah list
;;(dolist (hook '(c-ts-mode-hook
;;typescript-ts-mode-hook
;;rust-mode-hook
;;tsx-ts-mode-hook
;;c++-ts-mode-hook))
;;(add-hook hook #'eglot-ensure))
;;;;shell exec
