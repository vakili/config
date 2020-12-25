;; custom layer for using emacs-direnv in spacemacs
;; see http://magnus.therning.org/posts/2020-06-22-000-better-nix-setup-for-spacemacs.html#cb1-7
(defconst direnv-packages
  '(direnv))

(defun direnv/init-direnv ()
  (use-package direnv
    :init
    (direnv-mode)))
