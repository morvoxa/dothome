;; -*- lexical-binding: t; -*-
;; =============================================================================
;; 1. INITIALIZATION & PACKAGE MANAGER
;; =============================================================================

;; Memisahkan file konfigurasi kustom otomatis agar tidak mengotori init.el
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror)

;; Setup package.el dan integrasi dengan repositori MELPA
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)


;; =============================================================================
;; 2. COSMETICS, THEMES, & SYSTEM PREFERENCES
;; =============================================================================

;; Download dan aktifkan tema Atom Dark
(unless (package-installed-p 'atom-dark-theme)
  (package-install 'atom-dark-theme))
(load-theme 'atom-dark t)

;; Pengaturan font utama menggunakan JetBrains Mono
(set-face-attribute 'default nil :font "JetBrains Mono Nerd Font" :height 120)

;; Mengatur lokasi penyimpanan berkas backup otomatis ke satu folder khusus
(setq backup-directory-alist `(("." . ,(expand-file-name "backups" user-emacs-directory))))


;; =============================================================================
;; 3. EVIL MODE CONFIGURATION (VIM EMULATION)
;; =============================================================================

;; Download Evil Mode jika belum terpasang
(unless (package-installed-p 'evil)
  (package-install 'evil))

;; Aktifkan Evil Mode secara global
(require 'evil)
(evil-mode 1)

;; Konfigurasi Keybindings Evil Mode
(with-eval-after-load 'evil
  ;; Reset navigasi bawaan Evil agar tidak menabrak / konflik dengan Corfu
  (define-key evil-insert-state-map (kbd "C-y") nil)
  (define-key evil-insert-state-map (kbd "C-n") nil)
  (define-key evil-insert-state-map (kbd "C-p") nil)

  ;; Pengaturan Leader Key (SPC) dan Normal State Maps
  (evil-set-leader 'normal (kbd "SPC"))
  (define-key evil-normal-state-map (kbd "<leader> f") 'find-file)
  (define-key evil-normal-state-map (kbd "<leader> o") 'cd)
  (define-key evil-normal-state-map (kbd "<leader> r") 'eval-buffer)
  (define-key evil-normal-state-map (kbd "<leader> c") 'compile)
  (define-key evil-normal-state-map (kbd "<leader> e") (lambda () (interactive) (find-file ".")))

  ;; Pengaturan Global Normal State Maps
  (evil-define-key 'normal 'global (kbd "<leader> x") 'kill-current-buffer)
  (evil-define-key 'normal 'global (kbd "<leader> q") 'kill-emacs)
  (evil-define-key 'normal 'global (kbd "<leader> w") 'save-buffer)
  (evil-define-key 'normal 'global (kbd "<leader> v") 'other-window)

  ;; Shortcut Escape cepat dari Insert Mode ke Normal Mode menggunakan "jk"
  (define-key evil-insert-state-map (kbd "j k") 'evil-normal-state))


;; =============================================================================
;; 4. IDO MODE (MINIBUFFER COMPLETION)
;; =============================================================================

;; Aktifkan Ido Mode bawaan beserta fitur pencarian fleksibelnya
(ido-mode 1)
(setq ido-enable-flex-matching t)
(setq ido-confirm-unique-completion nil)
(setq ido-auto-merge-work-directories-length -1)

;; Kustomisasi interaksi navigasi di dalam Ido Mode
(with-eval-after-load 'ido
  (define-key ido-file-completion-map (kbd "TAB") 'ido-complete)

  ;; Fungsi pintar: Tekan RET 1x langsung buka Dired jika target berupa direktori
  (defun my-ido-smart-enter ()
    (interactive)
    (let* ((current-match (car ido-matches))
           (typed-input ido-text)
           (target-path (if current-match
                            (expand-file-name current-match ido-current-directory)
                          (expand-file-name typed-input ido-current-directory))))
      (cond
       ((file-directory-p target-path)
        (setq ido-exit 'dired)
        (exit-minibuffer))
       (t
        (setq ido-exit 'file)
        (exit-minibuffer)))))

  (define-key ido-file-completion-map (kbd "RET") 'my-ido-smart-enter))


;; =============================================================================
;; 5. UTILITY PACKAGES (AVY & FORMATTING)
;; =============================================================================

;; Avy: Navigasi lompat teks cepat menggunakan 2 karakter (tombol "s" di Normal Mode)
(use-package avy
  :ensure t
  :bind
  (:map evil-normal-state-map
        ("s" . avy-goto-char-2)))

;; Otomatis merapikan indentasi (auto-indent) kode Emacs Lisp setiap kali file disimpan
(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (add-hook 'before-save-hook
                      (lambda ()
                        (save-excursion
                          (indent-region (point-min) (point-max))))
                      nil t)))

;; Format-All: Paket pemformat kode otomatis untuk berbagai bahasa pemrograman
(unless (package-installed-p 'format-all)
  (package-install 'format-all))
(require 'format-all)
(add-hook 'prog-mode-hook 'format-all-mode)
(add-hook 'before-save-hook 'format-all-buffer)
(add-hook 'format-all-mode-hook 'format-all-ensure-formatter)


;; =============================================================================
;; 6. LANGUAGE MODES & TREE-SITTER
;; =============================================================================

;; Tree-Sitter Auto: Penganalisis struktur kode modern untuk syntax highlighting
(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

;; Major Mode untuk Bahasa Rust
(unless (package-installed-p 'rust-mode)
  (package-install 'rust-mode))
(require 'rust-mode)

;; Major Mode untuk Bahasa TypeScript
(unless (package-installed-p 'typescript-mode)
  (package-install 'typescript-mode))
(require 'typescript-mode)

;; Major Mode untuk Bahasa Zig
(unless (package-installed-p 'zig-mode)
  (package-install 'zig-mode))
(require 'zig-mode)


;; =============================================================================
;; 7. COMPLETION ENGINE (CORFU)
;; =============================================================================

;; Corfu: Sistem drop-down auto-completion in-buffer yang ringan
(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-cycle t)
  :bind (:map corfu-map
              ("C-n" . corfu-next)
              ("C-p" . corfu-previous)
              ("C-y" . corfu-insert))
  :init
  (global-corfu-mode))
