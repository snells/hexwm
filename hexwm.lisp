;;;; hexwm.lisp

(in-package #:hexwm)
(defvar out *standard-output*)


	   

(defun main ()
  (run-wm '("hexwm") :threaded t
	  :keyboard-key #'keyboard-key
	  :output-created #'output-created
	  :output-destroyed #'output-destroyed
	  :view-created #'view-created
	  :view-focus #'view-focused
	  :view-destroyed #'view-destroyed
	  :pointer-button #'pointer-button))
