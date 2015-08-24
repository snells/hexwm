(in-package :hexwm)

(defun focus-space (num)
  (setf (output-mask (focused-output)) (ash 1 num))
  (focus-topmost (focused-output))
  (relayout (focused-output)))


(defun move-to-space (view num)
  (when (/= view 0)
    (setf (view-mask view) (ash 1 num))
    (focus-topmost (view-output view))))


(let ((current 0)
      (count 1))
  (defun make-group ()
    (incf count))
  (defun select-group (num)
    (cond ((or (< num 0) (>= num count))
	   (format out "Trying to select group that does not exists~%"))
	  (t (setf current num)
	     (focus-space num))))
  (defun next-group ()
    (let ((new (+ current 1)))
      (cond ((< new count)
	     (select-group new))
	    (t (select-group 0)))))
  (defun previous-group ()
    (let ((new (- current 1)))
      (cond ((>= new 0)
	     (select-group new))
	    (t (select-group (- count 1))))))

  (defun move-to-group (view num)
    (if (and (< num count)
	     (>= num 0))
	(move-to-space view num)
	(format out "Trying to move view to space that does not exists~%"))))
   
