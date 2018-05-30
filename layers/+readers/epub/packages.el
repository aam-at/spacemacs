;;; packages.el --- epub layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2020 Sylvain Benner & Contributors
;;
;; Author: Jeremy Dormitzer <jeremy.dormitzer@gmail.com>
;; Author: Alexander Matyasko <alexander.matyasko@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defconst epub-packages '(nov))

(defun epub/init-nov ()
  (use-package nov
    :defer t
    :mode ("\\.epub\\'" . nov-mode)
    :init
    (setq nov-save-place-file (concat spacemacs-cache-directory "nov-places")
          nov-text-width epub-nov-text-width)
    :config
    (progn
      (evilified-state-evilify-map nov-mode-map
        :mode nov-mode
        :bindings
        (kbd "H")             'nov-previous-document
        (kbd "L")             'nov-next-document
        (kbd "[")             'nov-previous-document
        (kbd "]")             'nov-next-document
        (kbd "gm")            'nov-display-metadata
        (kbd "gr")            'nov-render-document
        (kbd "gt")            'nov-goto-toc
        (kbd "gv")            'nov-view-source
        (kbd "gV")            'nov-view-content-source
        (kbd "RET")           'nov-browse-url
        (kbd "<follow-link>") 'mouse-face
        (kbd "<mouse-2>")     'nov-browse-url
        (kbd "TAB")           'shr-next-link
        (kbd "M-TAB")         'shr-previous-link
        (kbd "<backtab>")     'shr-previous-link
        (kbd "C-u")           'nov-scroll-up
        (kbd "C-d")           'nov-scroll-down
        (kbd "DEL")           'nov-scroll-down
        (kbd "<home>")        'beginning-of-buffer
        (kbd "<end>")         'end-of-buffer)

      (spacemacs/set-leader-keys-for-major-mode 'nov-mode
        "g" 'nov-render-document
        "v" 'nov-view-source
        "V" 'nov-view-content-source
        "m" 'nov-display-metadata
        "n" 'nov-next-document
        "]" 'nov-next-document
        "p" 'nov-previous-document
        "[" 'nov-previous-document
        "t" 'nov-goto-toc))))
