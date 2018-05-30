;;; packages.el --- epub layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2024 Sylvain Benner & Contributors
;;
;; Author: Jeremy Dormitzer <jeremy.dormitzer@gmail.com>
;; Author: Alexander Matyasko <alexander.matyasko@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.


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
