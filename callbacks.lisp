(in-package :hexwm)

(defun view-focus (view focus)
  (if (= (view-output view) (focused-output))
      (set-view-state view +activated+ focus)))

(defun view-created (view)
  (if (= (view-output view) (focused-output))
      (focus-view view)
      (setf (output-active-view (view-output view)) view))
  (relayout (view-output view)))

(defun view-destroyed (view)
  (if (= focused-view view)
      (setf focused-view 0))
  (let ((parent (view-parent view)))
    (cond ((/= 0 parent)
	   (setf (view-parent view) 0)
	   (focus-view parent))
	  (t (focus-topmost (view-output view))))))


      
