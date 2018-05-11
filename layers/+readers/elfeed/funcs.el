(defun elfeed-mark-all-as-read ()
  (interactive)
  (when (y-or-n-p "Do you want to mark all as read? ")
    (mark-whole-buffer)
    (elfeed-search-untag-all-unread)))


(defun elfeed-mark-all-as-unread ()
  (interactive)
  (when (y-or-n-p "Do you want to mark all as unread? ")
    (mark-whole-buffer)
    (elfeed-search-tag-all-unread)))


;;function to support syncing .elfeed between machines
;;makes sure elfeed reads index from disk before launching
(defun spacemacs//elfeed-load-db-and-open ()
  "Wrapper to load the elfeed db from disk before opening"
  (interactive)
  (elfeed)
  (elfeed-update))
