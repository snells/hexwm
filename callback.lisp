(in-package :hexwm)

(defun output-created (output)
  (format out "output created~%") t)

(defun output-destroyed (output)
  (format out "output destroyed~%"))

(defun output-focused (output focus)
  (format out "output ~a focus~%" output)
  (output-focus output t))

(defun wm-output-resolution (output size-from size-to)
  (declare (ignore output size-from size-to))
  (format out "output resolution~%"))

(defun view-created (view)
    (let* ((o (view-output view))
	   (r (output-resolution o)))
      (format out "reso ~a~%" r)
      (setf (view-geometry view) (list '(0 0) r))
      (view-focus view)
      (view-set-state view +fullscreen+ t)
      (view-bring-to-front view) t))

(defun view-destroyed (view)
  (format out "view destroyed ~a~%" view)
  (focus-topmost (view-output view)))

(defun view-focused (view focus)
    (view-bring-to-front view)
    (view-set-state view +activated+ t)
    (view-focus view))

;(defun view-move-to-output (view output-from output-to))

(defun keyboard-key (view time modifiers key sym state)
    (let ((bit (parse-mod-bit modifiers)))
      (cond  ((and (equal state :pressed) (< sym 255))
	      (handler-case (handle-key view bit sym)
		(error (e) (format out "error while handling key~%")
		       (format out "error ~a~%" e))))
	     (t (format out "key not handled~%") nil))))

(setf callback-keyboard-key #'keyboard-key)

(defun pointer-button (view time modifiers button state)
  (focus-view view))
;(defun pointer-scroll (view time modifiers axis amount)) 
;(defun pointer-motion (view time origin))
;(defun touch-touch (view time modifiers type slot origin))
;(defun compositor-ready ())
