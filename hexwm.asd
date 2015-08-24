;;;; hexwm.asd

;(defpackage :hexwm-system (:use :cl  :asdf) (:export :component))
;(in-package :hexwm-system)
;(defvar components '((:file "package")
;		     (:file "hexwm" :depends-on ("package"))
;		     #+eclbuild (:file "prologue" :depends-on ("package"))))

;(ql:quickload :lisp-executable)
;(eval-when (:compile-toplevel :load-toplevel :execute)
;  (asdf:load-system "lisp-executable"))


(asdf:defsystem #:hexwm
  :description "Describe hexwm here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :depends-on (#:cl-wlc)
  :serial t
  :components ((:file "package")
	       (:file "util")
	       (:file "view")
	       (:file "space")
	       (:file "key")
	       (:file "callback")
	       (:file "layout")
	       (:file "group")
	       (:file "init")
	       (:file "hexwm")))
					


