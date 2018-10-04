;;; This file converts the bogus unconnected power and ground pins in the cells
;;; used by v2lvs to convert.
;;; There is probably a way to configure v2lvs but I don't see it...
;;;
;;; Also changes all upper case n[0-9]+ nodes to nx[0-9]+
;;; Case is irrelevant to hpsice... sigh.

(defun convert-v2lvs ()
  "Adds power and ground correctly to an Artisan library"
  ;; All Artisan cells we are using end with "A12TR"
  ;; They also end with VDD VSS
  (interactive)
  (let ((case-fold-search nil))
    (goto-char (point-min))
    (while (re-search-forward "A12TR" nil t)
      (backward-word 2)
      (kill-word 1)
      (insert "VSS")
      (backward-word 2)
      (kill-word 1)
      (insert "VDD")
      (re-search-forward "A12TR" nil t))
    ;; convert upper case nodes to avoid symbol name clashes
    (goto-char (point-min))
    (while (re-search-forward " N\\([0-9]+\\) " nil t)
      (backward-word 1)
      (delete-char 1)
      (insert "nx")))
    ;; convert connected netlists
  (let ((case-fold-search t)
	here)
    (goto-char (point-min))
    (while (re-search-forward "^\* *.CONNECT *\\([][0-9a-zA-Z_]+\\) *\\([][0-9a-zA-Z_]+\\)" nil t)
      (setq here (point))
      (let* ((from (match-string 2))
	     (to   (match-string 1))
	     (cnt  0)
	     (endpt (re-search-forward ".ENDS"))
	     (sstring (format "\\([^][0-9a-zA-Z_]\\)\\(%s\\)\\([^][0-9a-zA-Z_]\\)" from)))
	(goto-char here)
	(while (re-search-forward sstring endpt t)
	  (delete-region (match-beginning 2) (match-end 2))
	  (backward-char 1)
	  (insert to)
	  (setq cnt (+ 1 cnt)))
	;; no netlist signal found, so reverse replace.
	(when (zerop cnt)
	  (setq sstring (format "\\([^][0-9a-zA-Z_]\\)\\(%s\\)\\([^][0-9a-zA-Z_]\\)" to))
	  (goto-char here)
	  (while (re-search-forward sstring nil t)
	    (delete-region (match-beginning 2) (match-end 2))
	    (backward-char 1)
	    (insert from)
	    (setq cnt (+ 1 cnt))))
	(goto-char here)
	(beginning-of-line)
	(insert (format "*** updated %d ASSIGNs: " cnt))
	(goto-char here))))
  ;; search for unconnected nets
  (let ((case-fold-search t)
	endpt match)
    (goto-char (point-min))
    ;; pass the .connect commands because they have " #"'s...
    (while (re-search-forward ".connect" nil t)
      (setq endpt (re-search-forward ".ENDS"))
      (re-search-backward "\.CONNECT " nil t)
      (beginning-of-line 2)
      (if (re-search-forward " \\([0-9]+\\) " endpt t)
	  (progn
	    (setq match (match-string 1))
	    (re-search-backward "\.CONNECT " nil t)
	    (beginning-of-line 2)
	    (insert (format "*** WARNING - unconnected net %s exists in design\n" match))
	    ))
      (goto-char endpt))))

