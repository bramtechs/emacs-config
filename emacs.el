(custom-set-variables
 '(inhibit-startup-message t)
 '(inhibit-splash-screen t)
 '(initial-scratch-message nil))

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(load-file "packages.el")

(when (bound-and-true-p use-exwm)
  (require 'exwm)
  ;; Set the initial workspace number.
  (setq exwm-workspace-number 4)
  ;; Make class name the buffer name.
  (add-hook 'exwm-update-class-hook
            (lambda () (exwm-workspace-rename-buffer exwm-class-name)))
  ;; Global keybindings.
  (setq exwm-input-global-keys
        `(([?\s-r] . exwm-reset) ;; s-r: Reset (to line-mode).
          ([?\s-w] . exwm-workspace-switch) ;; s-w: Switch workspace.
          ([?\s-&] . (lambda (cmd) ;; s-&: Launch application.
                       (interactive (list (read-shell-command "$ ")))
                       (start-process-shell-command cmd nil cmd)))
          ;; s-N: Switch to certain workspace.
          ,@(mapcar (lambda (i)
                      `(,(kbd (format "s-%d" i)) .
                        (lambda ()
                          (interactive)
                          (exwm-workspace-switch-create ,i))))
                    (number-sequence 0 9))))
  ;; Enable EXWM
  (exwm-enable))

(when (eq system-type 'windows-nt)
  (with-eval-after-load 'grep
    ;; fix grep on windows
    ;; findstr can handle the basic find|grep use case
    (grep-apply-setting 'grep-find-template
                        "findstr /S /N /D:. /C:<R> <F>")
    (setq find-name-arg nil)))

;; make emacs shut up
(setq ring-bell-function 'ignore)
(setq set-message-beep 'silent)

;; Tab size is 4 spaces
(setq-default indent-tabs-mode nil)
(setq tab-width 4)
(setq indent-line-function 'insert-tab)

;; Use MYSYS find command over the Windows one which doesn't work
(if (eq system-type 'windows-nt)
    (setq find-program "C:\\msys64\\usr\\bin\\find.exe"))

;; performance tweaks
(setq inhibit-double-buffering t)

;; always be up to date
(global-auto-revert-mode 't)

;; show clock
(setq display-time-day-and-date t
   display-time-24hr-format t)
(display-time)

;; nowrap
(set-default 'truncate-lines t)

;; reduce some friction
(setq use-short-answers t)
(setq kill-buffer-query-functions
  (remq 'process-kill-buffer-query-function
         kill-buffer-query-functions))

;; vscode-like file opening
(global-set-key (kbd "C-x p") 'project-find-file)

;; turn off dumb auto-indent in config files
(add-hook 'conf-mode-hook (lambda () (electric-indent-local-mode -1)))

;; Ctrl x,c,v :: Conflicts with emacs sometimes.
;; Workarounds:
;; - Press the prefix key twice very quickly (within 0.2 seconds),
;; - press the prefix key and the following key within 0.2 seconds, or
;; - use the SHIFT key with the prefix key, i.e. C-S-x or C-S-c.
(cua-mode t)
(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
(transient-mark-mode 1)               ;; No region when it is not highlighted
(setq cua-keep-region-after-copy t)

;; switch to header
(global-set-key (kbd "C-x <return>") 'ff-find-other-file)

;; multi cursors
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C-S-<mouse-1>") 'mc/add-cursor-on-click)

(if (eq system-type 'windows-nt)
    (progn
      (global-set-key (kbd "C-x j") 'windmove-swap-states-right)
      (global-set-key (kbd "C-x J") 'windmove-swap-states-left))
  (progn
    ;; window swapping
    (global-set-key (kbd "M-s-<right>") 'windmove-swap-states-right)
    (global-set-key (kbd "M-s-<left>") 'windmove-swap-states-left)
    (global-set-key (kbd "M-s-<up>") 'windmove-swap-states-up)
    (global-set-key (kbd "M-s-<down>") 'windmove-swap-states-down)

    ;; move between windows
    (global-set-key (kbd "s-<right>") 'windmove-right)
    (global-set-key (kbd "s-<left>") 'windmove-left)
    (global-set-key (kbd "s-<up>") 'windmove-up)
    (global-set-key (kbd "s-<down>") 'windmove-down)))

;; markdown preview
(custom-set-variables
 '(markdown-command "pandoc"))

(global-hl-todo-mode)

(add-to-list 'hl-todo-keyword-faces
             '("NOCHECKIN"   . "#FFFF00"))
(add-to-list 'hl-todo-keyword-faces
             '("SLOW"   . "#6ea5ff"))
(add-to-list 'hl-todo-keyword-faces
             '("DEPRECATED"   . "#7d7d7d"))

;; Fix MacOS' weird Home and End keys
(when (eq system-type 'darwin)
  (use-package emacs
    :config
    (global-set-key (kbd "<home>") 'move-beginning-of-line)
    (global-set-key (kbd "<end>") 'move-end-of-line)
    (global-set-key (kbd "S-<home>") (lambda () (interactive)
                                       (push-mark)
                                       (move-beginning-of-line)))
    (global-set-key (kbd "S-<end>") (lambda () (interactive)
                                      (push-mark)
                                      (move-end-of-line)))))

;; org mode
(setq org-support-shift-select 't)

;; auto open shader-mode
(add-to-list 'auto-mode-alist '("\\.vs\\'" . shader-mode))
(add-to-list 'auto-mode-alist '("\\.fs\\'" . shader-mode))
(add-to-list 'auto-mode-alist '("\\.vert\\'" . shader-mode))
(add-to-list 'auto-mode-alist '("\\.frag\\'" . shader-mode))

;; set theme
(load-file "github-dark-dimmed-theme.el")
(load-file "github-light-theme.el")
(load-file "github-dark-theme.el")

(add-to-list 'custom-theme-load-path "~/dev/emacs-config")
(add-to-list 'custom-theme-load-path "C:/dev/emacs-config") ;; windows

(defun dark-mode ()
  (interactive)
  (load-theme 'custom-emacs t))
  ;;(load-theme 'github-dark t))
  ;;(load-theme 'jetbrains-darcula t))

(defun light-mode ()
  (interactive)
  (load-theme 'github-light t))
  ;;(load-theme 'leuven t))

(defun no-fruit-salad ()
  (interactive)
  (load-file "eziam-themes.el")
  (load-theme 'eziam-dark t))

(dark-mode)
;;(no-fruit-salad)

;; fix weird indentation in INI-files
(add-hook 'conf-mode (lambda (electric-indent-mode nil)))

;; auto remove trailing whitespace
(add-hook 'before-save-hook 'my-prog-nuke-trailing-whitespace)

(defun my-prog-nuke-trailing-whitespace ()
  (when (derived-mode-p 'prog-mode)
    (delete-trailing-whitespace)))

;; etags
(setq tags-revert-without-query 1)

;; Support colors in compilation mode
(require 'ansi-color)
(add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)
(require 'compile)
(setq compilation-last-buffer nil)

;; restore files
(global-set-key (kbd "C-x r") 'revert-buffer-quick)

;; save all modified buffers without asking before compilation
(setq compilation-ask-about-save nil)
(setq grep-save-buffers t)

;; cursed mode to fix scrolling with laptop touchpads
;; almost makes emacs feel like a modern editor
;; (pixel-scroll-precision-mode t)

;; auto kill process when recompiling
(setq compilation-always-kill t)
(setq compilation-scroll-output t)

(defun edit-config ()
  (find-file
   (cond
    ((eq system-type 'windows-nt) "C:/dev/emacs-config/emacs.el")
    ((file-exists-p "~/dev/emacs-config/emacs.el") "~/dev/emacs-config/emacs.el")
    (t "/mnt/c/dev/emacs-config/emacs.el"))))

;; auto-revert-mode might be slow, so try to disable it
(with-eval-after-load 'magit-autorevert
  (defalias 'magit-auto-revert-buffers 'auto-revert-buffers)
  (magit-auto-revert-mode -1))

;; keybindings
(global-set-key (kbd "<f2>") (lambda () (interactive) (edit-config)))

;; map zoom to sane bindings
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

;; configure text font and size
(defun set-global-font-size (size)
  "Set the global font size while keeping the current font family."
  (interactive "nFont size: ")
  (let* ((font (face-attribute 'default :font))
         (family (font-get font :family)))
    (set-frame-font (format "%s-%d" family size) nil t)))

(if (eq system-type 'darwin)
    (set-global-font-size 16)
  (set-global-font-size 12))

;; shorthands
(defun mwb ()
  (interactive)
  (mark-whole-buffer))
(defun mhb ()
  (interactive)
  (mark-whole-buffer))

;; discover (quick way to clone repos)
(defun discover (repo)
  (interactive "sRepo: ")
  (let ((repo-link (if (not (or (string-prefix-p "https://" repo) (string-prefix-p "git@" repo)))
                       (setq repo-link (concat "git@github.com:" repo ".git")) repo))
        (output-dir (if (eq system-type 'windows-nt) "C:\\dev\\" "~/dev/")))
    (magit-clone-regular repo-link output-dir nil)))

;; autocomplete word
(global-set-key (kbd "C-<tab>") 'dabbrev-expand)

(setq compilation-error-regexp-alist
    (cons '("^\\([0-9]+>\\)?\\(\\(?:[a-zA-Z]:\\)?[^:(\t\n]+\\)(\\([0-9]+\\)) : \\(?:fatal error\\|warnin\\(g\\)\\) C[0-9]+:" 2 3 nil (4))
     compilation-error-regexp-alist))

(setq mouse-wheel-scroll-amount (quote (3)))

;; stop fat-fingering suspend shortcut
(global-unset-key "\C-x\C-z")
(put 'suspend-frame 'disabled t)

;; stop fat-fingering quit shortcut
(global-unset-key "\C-x\C-c")

;; build and run keys
;; Windows

(defun run-script (script-name)
  "Run the specified SCRIPT-NAME (either 'build' or 'run') if found in a dominating directory."
  (interactive)
  (let ((ps-script (locate-dominating-file default-directory (concat script-name ".ps1")))
        (cmd-script (locate-dominating-file default-directory (concat script-name ".cmd"))))
    (cond
     (ps-script
      (let ((default-directory ps-script))
        (compile (concat "powershell.exe -File " script-name ".ps1"))))
     (cmd-script
      (let ((default-directory cmd-script))
        (compile (concat script-name ".cmd"))))
     (t (message "No %s script found" script-name)))))

(defun run-build-script ()
  "Run the build script if found in a dominating directory."
  (interactive)
  (run-script "build"))

(defun run-run-script ()
  "Run the run script if found in a dominating directory."
  (interactive)
  (run-script "run"))

;; Linux / Mac

(defun run-makefile (&optional task)
  "Run the closest Makefile found from the current directory."
  (interactive)
  (setq makefile-folder (locate-dominating-file default-directory "Makefile"))
  (if makefile-folder
      (progn
        (setq makefile (concat makefile-folder "Makefile"))
        (compile (concat "make -f \'" makefile "\' -C \'" makefile-folder "\' -b " task))
        (message "Makefile %s is being run." makefile))
    (message "No Makefile found.")))

;; Shared

(defun build-project ()
  (setq compilation-scroll-output 'first-error) ;; stop compilation scroll on first error
  (if (eq system-type 'windows-nt)
      (run-build-script)
    (run-makefile)))

(defun run-project ()
  (setq compilation-scroll-output 't) ;; auto scroll compilation buffer
  (if (eq system-type 'windows-nt)
      (run-run-script)
    (run-makefile "run")))

(global-set-key (kbd "<f5>") (lambda () (interactive) (build-project)))
(global-set-key (kbd "<f6>") (lambda () (interactive) (run-project)))
(global-set-key (kbd "<f7>") 'compile)

;; Copyright snippets
(defun mit-license ()
  (interactive)
  (goto-char (point-min))
  (insert "MIT License\n\n")
  (insert "Copyright (c) " (format-time-string "%Y") ". Doomhowl Interactive - bramtechs/brambasiel\n\n")
  (insert "Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the \"Software\"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE."))

(defun add-copyright ()
  (interactive)
  (goto-char (point-min))
  (insert "/*\n")
  (insert " * Copyright (c) " (format-time-string "%Y") ". Doomhowl Interactive - All Rights Reserved\n")
  (insert " * Redistribution and use in source and binary forms, with or without modification are not permitted\n")
  (insert " * without the prior written permission of Doomhowl Interactive.\n")
  (insert " *\n")
  (insert " * File created on: " (format-time-string "%d-%m-%Y") "\n")
  (insert " */\n\n"))

(defun add-copyright-mit ()
  (interactive)
  (goto-char (point-min))
  (insert "/*\n")
  (insert " * Copyright (c) " (format-time-string "%Y") ". Doomhowl Interactive - bramtechs/brambasiel\n")
  (insert " * MIT License. Absolutely no warranty.\n")
  (insert " * \n")
  (insert " * File created on: " (format-time-string "%d-%m-%Y") "\n")
  (insert " */\n\n"))

(defun my-cc-mode-setup ()
  "Custom setup for C/C++ files and headers."

  (c-set-style "stroustrup")
  (setq c-doc-comment-style '((c-mode . gtkdoc)
                              (c++-mode . doxygen)))

  (c-set-offset 'innamespace 0)

  (if (eq system-type 'berkeley-unix)
        ;; GhostBSD using fish for some stupid reason and I can't be
        ;; bothered how to edit PATH properly
      (setq clang-format-executable "/usr/local/llvm20/bin/clang-format"))
  (clang-format-on-save-mode t)

  (when (and (buffer-file-name)
             (not (file-exists-p (buffer-file-name)))
             (or (string-match "\\.\\(c\\|cpp\\|h\\|hpp\\|cc\\|hh\\|java\\)\\'" (buffer-file-name))))
    ;; Insert a header if the file is new
    (add-copyright)

    ;; check if header add pragma once
    (if (string-match "\\.\\(h\\|hpp\\|hh\\)\\'" (buffer-file-name))
        (insert "#pragma once\n\n"))

    ;; Check if not C file, but C++
    (if (string-match "\\.\\(cpp\\|hpp\\|cc\\|hh\\)\\'" (buffer-file-name))
      (insert "namespace "))

    ;; Move the cursor to the end of the header
    (goto-char (point-max))
    (message "Added license text for this file")))

;; Add the function to C and C++ mode hooks
(add-hook 'c-mode-hook 'my-cc-mode-setup)
(add-hook 'c++-mode-hook 'my-cc-mode-setup)
(add-hook 'objc-mode-hook 'my-cc-mode-setup)

(defun my-d-mode-hook ()
  "Custom D mode settings."
  (setq c-basic-offset 4)
  (c-set-style "stroustrup")) ;; Set indentation level to 4 spaces

(add-hook 'd-mode-hook 'my-d-mode-hook)

;; Associate .inc files with c++-mode
(add-to-list 'auto-mode-alist '("\\.inc\\'" . c++-mode))

(load-file "gemini.el")
(message "Loaded entire config successfully")
