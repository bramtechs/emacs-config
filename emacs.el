(custom-set-variables
 '(inhibit-startup-message t)
 '(inhibit-splash-screen t)
 '(initial-scratch-message nil))

(cua-mode 1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(load-theme 'tango-dark)

(setq ring-bell-function 'ignore)
(setq set-message-beep 'silent)

;; no wrap
(set-default 'truncate-lines t)

(setq use-short-answers t)

;; vscode-like file opening
(global-set-key (kbd "C-x p") 'project-find-file)

(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
(transient-mark-mode 1)               ;; No region when it is not highlighted
(setq cua-keep-region-after-copy t)

;; switch to header
(global-set-key (kbd "C-x <return>") 'ff-find-other-file)

;; autocomplete word
(global-set-key (kbd "C-<tab>") 'dabbrev-expand)

;; compile key
(global-set-key (kbd "<f7>") 'compile)

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

;; auto kill process when recompiling
(setq compilation-always-kill t)
(setq compilation-scroll-output t)

;; save all modified buffers without asking before compilation
(setq compilation-ask-about-save nil)
(setq grep-save-buffers t)

(defun edit-config ()
  (find-file
   (cond
    ((eq system-type 'windows-nt) "C:/dev/emacs-config/emacs.el")
    ((file-exists-p "~/dev/emacs-config/emacs.el") "~/dev/emacs-config/emacs.el")
    (t "/mnt/c/dev/emacs-config/emacs.el"))))

;; shorthands
(defun mwb ()
  (interactive)
  (mark-whole-buffer))
(defun mhb ()
  (interactive)
  (mark-whole-buffer))

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

;; map zoom to sane bindings
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

(defun my-cc-mode-setup ()
  "Custom setup for C/C++ files and headers."

  (c-set-style "stroustrup")
  (setq c-doc-comment-style '((c-mode . gtkdoc)
                              (c++-mode . doxygen)))

  (c-set-offset 'innamespace 0)

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
    (message "Added license text for this file"))

  (setq tab-width 4)
  (setq standard-indent 4)
  (setq c-basic-offset 4))

;; Add the function to C and C++ mode hooks
(add-hook 'c-mode-hook 'my-cc-mode-setup)
(add-hook 'c++-mode-hook 'my-cc-mode-setup)
(add-hook 'objc-mode-hook 'my-cc-mode-setup)

;; Melpa
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)
