;;; packages.el --- BibTeX Layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2024 Sylvain Benner & Contributors
;;
;; Author: Joshua Ellis <josh@jpellis.me>
;; URL: https://github.com/JP-Ellis
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


(defconst bibtex-packages
  '(
    auctex
    (helm-bibtex :requires helm)
    (ivy-bibtex :requires ivy)
    (citar :requires vertico)
    (citar-embark :requires vertico)
    (citar-org-roam :requires vertico)
    markdown-mode
    org
    org-ref
    biblio
    (ebib :toggle bibtex-enable-ebib-support)))

(defun bibtex/post-init-auctex ()
  (spacemacs/set-leader-keys-for-major-mode 'latex-mode
    "ic" 'org-ref-insert-link))

(defun bibtex/init-helm-bibtex ()
  (use-package helm-bibtex
    :defer t
    :init
    (spacemacs/set-leader-keys-for-major-mode 'bibtex-mode
      "m" 'helm-bibtex)))

(defun bibtex/init-citar ()
  (use-package citar
    :init
    (dolist (hook '(LaTeX-mode-hook latex-mode-hook org-mode-hook))
      (add-hook hook 'citar-capf-setup))
    (setq citar-at-point-function 'embark-act)
    (spacemacs/set-leader-keys-for-major-mode 'bibtex-mode "m" 'citar-open)
    :config
    (defun citar-create-indicator (icons-set icon unicode func tag color)
      "Create a citar indicator with icon or unicode symbol based on display capabilities."
      (citar-indicator-create
       :symbol (if (or (display-graphic-p) (daemonp))
                   (funcall icons-set icon :face color :v-adjust -0.1)
                 unicode)
       :function func
       :padding "  "
       :tag tag))

    (setq citar-indicators
          (list (citar-create-indicator #'all-the-icons-faicon "file-o" "📄" #'citar-has-files "has:files" 'all-the-icons-green)
                (citar-create-indicator #'all-the-icons-octicon "link" "🔗" #'citar-has-links "has:links" 'all-the-icons-orange)
                (citar-create-indicator #'all-the-icons-material "speaker_notes" "📝" #'citar-has-notes "has:notes" 'all-the-icons-blue)
                (citar-create-indicator #'all-the-icons-faicon "circle-o" "◉" #'citar-is-cited "is:cited" 'all-the-icons-green)))
    (add-hook 'after-make-frame-functions
              (lambda (_) (citar-update-indicators)))))

(defun bibtex/init-citar-embark ()
  (use-package citar-embark
    :defer t
    :after (citar embark)
    :init
    (spacemacs/set-leader-keys-for-major-mode 'bibtex-mode
      "m" 'citar-embark)))

(defun bibtex/init-citar-org-roam ()
  (use-package citar-org-roam
    :defer t
    :after (citar embark)
    :init
    (citar-org-roam-mode)))

(defun bibtex/init-ivy-bibtex ()
  (use-package ivy-bibtex
    :defer t
    :init
    (spacemacs/set-leader-keys-for-major-mode 'bibtex-mode
      "m" 'ivy-bibtex)))

(defun bibtex/post-init-markdown-mode ()
  (spacemacs/set-leader-keys-for-major-mode 'markdown-mode
    "ic" 'org-ref-insert-link))

(defun bibtex/post-init-org ()
  (setq org-cite-insert-processor 'citar
        org-cite-follow-processor 'citar
        org-cite-activate-processor 'citar)
  (spacemacs/set-leader-keys-for-major-mode 'org-mode
    "ic" 'org-ref-insert-link)
  ;; Setup export processor; default csl/citeproc-el, with biblatex for
  ;; latex
  (setq org-cite-export-processors '((latex biblatex) (t csl))
        org-support-shift-select t)
  (require 'oc-biblatex)
  (require 'oc-csl))

(defun bibtex/init-org-ref ()
  (use-package org-ref
    :defer t
    :commands (org-ref-bibtex-next-entry
               org-ref-bibtex-previous-entry
               org-ref-insert-link
               org-ref-open-in-browser
               org-ref-open-bibtex-notes
               org-ref-open-bibtex-pdf
               org-ref-bibtex-hydra/body
               org-ref-bibtex-hydra/org-ref-bibtex-new-entry/body-and-exit
               org-ref-sort-bibtex-entry
               arxiv-add-bibtex-entry
               arxiv-get-pdf-add-bibtex-entry
               doi-utils-add-bibtex-entry-from-doi
               isbn-to-bibtex
               pubmed-insert-bibtex-from-pmid)
    :init
    (add-hook 'org-mode-hook (lambda () (require 'org-ref)))

    (cond ((configuration-layer/layer-used-p 'helm)
           (setq org-ref-completion-library 'org-ref-helm-bibtex))
          ((configuration-layer/layer-used-p 'ivy)
           (setq org-ref-completion-library 'org-ref-ivy-cite)))

    (evil-define-key 'normal bibtex-mode-map
      (kbd "C-j") 'org-ref-bibtex-next-entry
      (kbd "C-k") 'org-ref-bibtex-previous-entry
      "gj" 'org-ref-bibtex-next-entry
      "gk" 'org-ref-bibtex-previous-entry)

    (spacemacs/declare-prefix-for-mode 'bibtex-mode "ml" "lookup")
    (spacemacs/set-leader-keys-for-major-mode 'bibtex-mode
      ;; Navigation
      "j" 'org-ref-bibtex-next-entry
      "k" 'org-ref-bibtex-previous-entry

      ;; Open
      "b" 'org-ref-open-in-browser
      "n" 'org-ref-open-bibtex-notes
      "p" 'org-ref-open-bibtex-pdf

      ;; Misc
      "h" 'org-ref-bibtex-hydra/body
      "i" 'org-ref-bibtex-hydra/org-ref-bibtex-new-entry/body-and-exit
      "s" 'org-ref-sort-bibtex-entry

      ;; Lookup utilities
      "la" 'arxiv-add-bibtex-entry
      "lA" 'arxiv-get-pdf-add-bibtex-entry
      "ld" 'doi-utils-add-bibtex-entry-from-doi
      "li" 'isbn-to-bibtex
      "lp" 'pubmed-insert-bibtex-from-pmid)))

(defun bibtex/init-ebib ()
  (use-package ebib
    :defer t
    :init
    (spacemacs/set-leader-keys "ate" 'ebib)
    :config
    (setq ebib-bibtex-dialect 'biblatex)

    (evilified-state-evilify-map ebib-index-mode-map
      :mode ebib-index-mode
      :bindings
      "j" 'ebib-next-entry
      "k" 'ebib-prev-entry
      "J" 'evil-scroll-page-down
      "K" 'evil-scroll-page-up

      "gj" 'ebib-jump-to-entry
      "/" 'ebib-search
      "n" 'ebib-search-next
      ;; the following binding is a simple workaround for
      ;; https://github.com/joostkremers/ebib/issues/213
      [remap spacemacs/kill-this-buffer] 'ebib-quit)

    (spacemacs/set-leader-keys-for-major-mode 'ebib-index-mode
      "j" 'ebib-jump-to-entry
      "k" 'ebib-kill-entry
      "b" 'biblio-lookup)

    (evilified-state-evilify-map ebib-entry-mode-map
      :mode ebib-entry-mode)

    (evilified-state-evilify-map ebib-log-mode-map
      :mode ebib-log-mode)

    (require 'ebib-biblio)
    (evilified-state-evilify-map biblio-selection-mode-map
      :mode biblio-selection-mode
      :bindings
      "e" 'ebib-biblio-selection-import
      "B" 'ebib-biblio-import-doi
      (kbd "C-j") 'biblio--selection-next
      (kbd "C-k") 'biblio--selection-previous)))

(defun bibtex/init-biblio()
  (use-package biblio
    :defer t
    :config
    (evilified-state-evilify-map biblio-selection-mode-map
      :mode biblio-selection-mode
      :bindings
      (kbd "C-j") 'biblio--selection-next
      (kbd "C-k") 'biblio--selection-previous)))
