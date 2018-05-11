;;; packages.el --- elfeed Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2024 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
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


(setq elfeed-packages
      '(elfeed
        (elfeed-goodies :toggle elfeed-enable-goodies)
        elfeed-org
        (elfeed-web :toggle elfeed-enable-web-interface)
        persp-mode))

(defun elfeed/init-elfeed ()
  (use-package elfeed
    :defer t
    :init (spacemacs/set-leader-keys "are" 'elfeed)
    :config
    (progn
      (defalias 'elfeed-search-tag-all-star
        (elfeed-expose #'elfeed-search-tag-all 'star)
        "Add the `star' tag to all selected entries.")

      (defalias 'elfeed-search-untag-all-star
        (elfeed-expose #'elfeed-search-untag-all 'star)
        "Remove the `star' tag from all selected entries.")

      (defalias 'elfeed-search-tag-all-fav
        (elfeed-expose #'elfeed-search-tag-all 'fav)
        "Add the `fav' tag to all selected entries.")

      (defalias 'elfeed-search-untag-all-fav
        (elfeed-expose #'elfeed-search-untag-all 'fav)
        "Remove the `fav' tag from all selected entries.")

      (evilified-state-evilify-map elfeed-search-mode-map
        :mode elfeed-search-mode
        :eval-after-load elfeed-search
        :bindings
        "R"  'elfeed-mark-all-as-read
        "U"  'elfeed-mark-all-as-unread
        "*"  'elfeed-search-tag-all-star
        "!"  'elfeed-search-untag-all-star
        "f"  'elfeed-search-tag-all-fav
        "F"  'elfeed-search-untag-all-fav
        "c"  'elfeed-db-compact
        "gr" 'elfeed-update
        "gR" 'elfeed-search-update--force
        "gu" 'elfeed-unjam
        "o"  'elfeed-load-opml
        "w"  'elfeed-web-start
        "W"  'elfeed-web-stop)
      (evilified-state-evilify-map elfeed-show-mode-map
        :mode elfeed-show-mode
        :eval-after-load elfeed-show
        :bindings
        (kbd "C-j") 'elfeed-show-next
        (kbd "C-k") 'elfeed-show-prev)
      (evil-define-key 'visual elfeed-search-mode-map
        "+"  'elfeed-search-tag-all
        "-"  'elfeed-search-untag-all
        "b"  'elfeed-search-browse-url
        "y"  'elfeed-search-yank))))

(defun elfeed/pre-init-elfeed-goodies ()
  (spacemacs|use-package-add-hook elfeed
    :post-config
    (progn
      (elfeed-goodies/setup)
      (evil-define-key 'evilified elfeed-show-mode-map
        "o" 'elfeed-goodies/show-ace-link))))

(defun elfeed/init-elfeed-goodies ()
  (use-package elfeed-goodies :commands elfeed-goodies/setup))

(defun elfeed/pre-init-elfeed-org ()
  (when (boundp 'rmh-elfeed-org-files)
    (spacemacs|use-package-add-hook elfeed
      :pre-config (elfeed-org))))

(defun elfeed/init-elfeed-org ()
  (use-package elfeed-org
    :defer t
    :if (boundp 'rmh-elfeed-org-files)))

(defun elfeed/init-elfeed-web ()
  (use-package elfeed-web
    :defer t
    :commands elfeed-web-stop
    :init (when elfeed-enable-web-interface
            ;; TODO check if the port is already in use
            ;; hack to force elfeed feature to be required before elfeed-search
            (require 'elfeed)
            (elfeed-web-start))))

(defun elfeed/post-init-persp-mode ()
  (spacemacs|define-custom-layout elfeed-spacemacs-layout-name
    :binding elfeed-spacemacs-layout-binding
    :body
    (progn
      (defun spacemacs-layouts/add-elfeed-buffer-to-persp ()
        (persp-add-buffer (current-buffer)
                          (persp-get-by-name
                           elfeed-spacemacs-layout-name)))
      (spacemacs/add-to-hooks 'spacemacs-layouts/add-elfeed-buffer-to-persp
                              '(elfeed-search-mode
                                elfeed-show-mode))
      (call-interactively 'spacemacs//elfeed-load-db-and-open))))
