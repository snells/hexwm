;;;; hexwm.lisp

(in-package #:hexwm)
(defvar out *standard-output*)




(defun wm-output-created (output)
  (format out "output created~%") t)

(defun wm-output-destroyed (output)
  (format out "output destroyed~%"))

(defun wm-output-focus (output focus)
  (format out "output ~a focus~%" output)
  (output-focus output))
(defun wm-output-resolution (output size-from size-to)
  (declare (ignore output size-from size-to))
  (format out "output resolution~%"))
(defun wm-view-created (view)
  (format out "view TESTING THIS SHI
T created ~a~%" view)
  (view-set-state view +fullscreen+ t)
  (view-focus view)
  (view-bring-to-front view) t)
(defun wm-view-destroyed (view)
  (format out "view destroyed ~a~%" view))
(defun wm-view-focus (view focus)
  (format out "view focus ~a~%" view)
  (view-bring-to-front view)
  (view-set-state view +activated+ t)
  (view-focus view))
;(defun view-move-to-output (view output-from output-to))
;(defvar kb-event-delay nil)
;(defvar exec-delay nil)
(defun wm-keyboard-key (view time modifiers key sym state)
  (let ((bit (parse-mod-bit modifiers)))
    (cond ((/= 0 (logand bit 4)) ; ctrl
	   (cond  ((= sym 101) ; #\e
		   (format out "trying weston WHY NOT WORK~%")
		   (exec "weston-terminal"))
		  ((= sym #x31)
		   (format out "TRYING WESTON TERMINAL~%")
		   (exec)) ;"weston-terminal"))
		  ((= sym #x71) ; #\q
		   (let ((output (view-output view)))
		     (format out "closing view ~a~%" view)
		     (view-close view)))
		     ;(focus-view (get-topmost-view output))))
		  ((= sym #xff1b) ;#\Escape
		   (format out "terminating~%")
		   (wlc-terminate))
		 (t t)))
	  (t t))))
	   
(defun wm-pointer-button (view time modifiers button state)
  (focus-view view))
;(defun pointer-scroll (view time modifiers axis amount)) 
;(defun pointer-motion (view time origin))
;(defun touch-touch (view time modifiers type slot origin))
;(defun compositor-ready ())

(define-program main ()
  (run-wm '("hexwm") :threaded t 
	  :keyboard-key #'wm-keyboard-key))
  
;(defun main ()
					;:output-created #'wm-output-created
	  ;:output-destroyed #'wm-output-destroyed
	  ;:view-created #'wm-view-created))
	  ;:view-focus #'wm-view-focus))
	  ;:view-destroyed #'wm-view-destroyed))
