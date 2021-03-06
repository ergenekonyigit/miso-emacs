(add-hook 'prog-mode-hook 'linum-relative-mode)
(add-hook 'prog-mode-hook 'rabbit-mode)
(add-hook 'prog-mode-hook 'company-mode)
(add-hook 'prog-mode-hook 'git-gutter-mode)
(add-hook 'prog-mode-hook 'show-paren-mode)

(add-hook 'conf-mode-hook 'linum-relative-mode)
(add-hook 'conf-mode-hook 'rabbit-mode)
(add-hook 'conf-mode-hook 'company-mode)
(add-hook 'conf-mode-hook 'git-gutter-mode)
(add-hook 'conf-mode-hook 'show-paren-mode)

(add-hook 'prog-mode-hook (lambda ()
			    (interactive)
			    (local-set-key (kbd "M-i e") 'counsel-flycheck)
			    (local-set-key (kbd "M-i f") 'lsp-execute-code-action)
			    (local-set-key (kbd "M-i r") 'lsp-rename)
			    (local-set-key (kbd "M-i j") 'counsel-semantic-or-imenu)
			    (local-set-key (kbd "M-i w") 'write)
			    (local-set-key (kbd "M-i <up>") 'magit-push-current-to-upstream)
			    (local-set-key (kbd "M-i <down>") 'magit-pull-from-upstream)
			    ))

(defvar counsel-flycheck-history nil
  "history for `counsel-flycheck'")

(defun counsel-flycheck ()
  (interactive)
  (if (not (bound-and-true-p flycheck-mode))
      (message "Flycheck mode is not available or enabled")
    (ivy-read "Error: "
              (let ((source-buffer (current-buffer)))
                (with-current-buffer
                    (or (get-buffer flycheck-error-list-buffer)
                        (progn
                          (with-current-buffer
                              (get-buffer-create flycheck-error-list-buffer)
                            (flycheck-error-list-mode)
                            (current-buffer))))
                  (flycheck-error-list-set-source source-buffer)
                  (flycheck-error-list-reset-filter)
                  (revert-buffer t t t)
                  (split-string (buffer-string) "\n" t " *")))
              :action (lambda (s &rest _)
                        (-when-let* ( (error (get-text-property 0 'tabulated-list-id s))
                                      (pos (flycheck-error-pos error)) )
                          (goto-char (flycheck-error-pos error))))
              :history 'counsel-flycheck-history
              :caller 'counsel-flycheck)))
