(in-package :hexwm)

(defvar focused-view 0)

(defun raise-all (view)
  (let ((parent (view-parent view)))
    (when (/= parent 0)
      (raise-all parent)
      (let ((views (output-views (view-output view))))
	(dolist (v views)
	  (cond ((or (= v view) (/= (view-parent v) parent)))
		(t (view-bring-to-front v))))))
    (view-bring-to-front view)))


(defun focus-view (view)
  (when (/= view focused-view)
    (when (/= 0 view)
      (let ((views (output-views (view-output view))))
	(dolist (v views)
	  ;; focusing parent instead of child view if there is parent
	  (when (= view (view-parent v))
	    (focus-view v)
	    (return-from focus-view)))
	(raise-all view))))
  (view-focus view)
  (setf focused-view view))

(defun focus-topmost (output)
  (let ((views (output-views-masked output)))
    (if views
	(focus-view (car views))
	(focus-view 0))))

  

(defun focus-output (output)
  (output-focus output t)
  (focus-topmost (focused-output))
  (relayout output))

(defun output-by-index (num)
  (let ((outputs (get-outputs)))
    (if (< num (length outputs))
	(nth num outputs)
	0)))

(defun move-to-output (view num)
  (let ((output (output-by-index num)))
    (cond ((zerop output))
	  (t (setf (view-mask view) (output-mask output))
	     (setf (view-output view) output)
	     (focus-output output)))))

(defun output-active-view (output)
  (let ((views (output-views output)))
    (dolist (v views)
      (if (= (view-state v) +activated+)
	  (return-from output-active-view v)))
    0))

(defun (setf output-active-view) (view output)
  (dolist (v (output-views output))
    (set-view-state v +activated+ (if (= v view) t nil))))

(defun view-move-to-output (view from to)
  (relayout rom)
  (relayout to)
  (if (/= 0 (logand (view-state view) +activated+))
      (setf (output-active-view to) view))
  (focus-topmost from))



(defun focus-next-view (view)
  (focus-view (get-next-view view)))
(defun focus-previous-view (view)
  (focus-view (get-previous-view view)))
