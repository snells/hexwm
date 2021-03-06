(in-package :hexwm)


(defun mkstr (&rest args)
  (let ((text (with-output-to-string (ss)
		(dolist (item args)
		  (cond ((stringp item)
			 (write-string item ss))
			((characterp item)
			 (write-char item ss))
			((atom item)
			 (write item :stream ss))
			((consp item)
			 (dolist (x item)
			   (write-string (mkstr x) ss))))))))
	text))
