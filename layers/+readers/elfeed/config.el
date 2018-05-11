;;; config.el --- elfeed Layer configuration File for Spacemacs
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


;;; Variables

(defvar elfeed-enable-web-interface nil
  "If non nil start a web server to consult the database in a web browser.")

(defvar elfeed-enable-goodies t
  "If non nil enable elfeed-goodies (split-pane...).")

(defvar elfeed-spacemacs-layout-name "@Elfeed"
  "Name used in the setup for `spacemacs-layouts' micro-state")

(defvar elfeed-spacemacs-layout-binding "f"
  "Binding used in the setup for `spacemacs-layouts' micro-state")
