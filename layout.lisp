(in-package :hexwm)

(defvar screens '())

; lu = left or up
; rd = right or down
(defclass screen ()
  ((width :accessor width :initarg :width)
   (height :accessor height :initarg :height)
   (x :accessor x :initarg :x)
   (y :accessor y :initarg :y)
   (focus :accessor focus :initarg :focus :initform nil)
   (view :accessor view :initarg :view :initform 0)
   (split :accessor split :initarg :split :initform nil)
   (sub-screen-lu :accessor sub-screen-lu :initarg :sub-screen-lu :initform nil)
   (sub-screen-rd :accessor sub-screen-rd :initarg :sub-screen-rd :initform nil)))

(defun make-screen (x y w h)
  (make-instance 'screen :width w :height h :x x :y y))

(defmethod split-screen ((screen screen) split)
  (cond ((or (eq split 'horizontal)
	     (eq split 'vertical))
	 (setf (split screen) split)
	 (let* ((vertp (if (eq split 'vertical) t nil))
		(w (if vertp (floor (width screen) 2) (width screen)))
		(h (if vertp (height screen) (floor (heigh screen) 2)))
		(x-lu (x screen))
		(x-rd (if vertp (+ (x screen) w) (x screen)))
		(y-lu (if vertp (y screen) (+ (y screen) h)))
		(y-rd (y screen)))
	   (setf (sub-screen-lu screen) (make-screen x-lu y-lu w h)
		 (sub-screen-rd screen) (make-screen x-rd y-rd w h))
	   (when (view screen)
	     (setf (view (sub-screen-lu screen)) (view screen)
		   (view screen) 0))))
	(t (format out "Error splitting screen ~a, unknown split ~a~%" screen split))))

(defmethod change-focus ((s1 screen) (s2 screen))
  (when (focus s1)
    (setf (focus s1) nil
	  (focus s2) t)))

(defmethod focus-right-most ((screen screen))
  (walk-screen-rd screen (lambda (s) (setf (focus s) t))))
(defmethod focus-left-most ((screen screen))
  (walk-screen-lu screen (lambda (s) (setf (focus s) t))))

    

(defun walk-screen (s fn)
  (funcall fn s)
  (when (split s)
    (walk-screen (sub-screen-lu s) fn)
    (walk-screen (sub-screen-rd s) fn)))

(defun walk-screen-rd (s fn)
  (funcall fn s)
  (when (split s)
    (walk-screen-rd (sub-screen-rd s) fn)))

(defun walk-screen-lu (s fn)
  (funcall fn s)
  (when (split s)
    (walk-screen-lu (sub-screen-lu s) fn)))

(defun remove-focus (screen)
  (setf (focus screen) nil))

(defun remove-focus-from-all (screen)
  (walk-screen screen (lambda (s) (setf (focus s) nil))))

(let ((ret nil))
  (defun get-last-rd (screen)
    (setf ret nil)
    (walk-screen-rd screen (lambda (s)
			  (when (null (split s))
			    (setf ret s))))
    ret)
  (defun get-last-lu (screen)
    (setf ret nil)
    (walk-screen-lu screen (lambda (s)
			     (when (null (split s))
			       (setf ret s))))
    ret))

(defmethod focus-left ((screen screen))
  (when (focus screen)
    (let ((rd (sub-screen-rd screen))
	  (lu (sub-screen-lu screen)))
      (cond ((null (split screen))
	     (setf (focus screen) nil)
	     nil)
	    ((and (null (split rd))
		    (focus rd))
	     (remove-focus rd)
	     (focus-right-most lu) t)
	    ((foucs rd)
	     (focus-left rd))
	    (t (focus-left lu))))))
  
(defmethod focus-right ((screen screen))
  (when (focus screen)
    (let ((rd (sub-screen-rd screen))
	  (lu (sub-screen-lu screen)))
      (cond ((null (split screen))
	     (setf (focus screen) nil)
	     nil)
	    ((and (null (split lu))
		  (focus lu))
	     (remove-focus lu)
	     (focus-left-most rd) t)
	    ((focus lu)
	       (focus-right lu))
	    (t (focus-right rd))))))







(defun relayout (output)
  (let ((r (output-resolution output)))
    (if (null (car r))
	(return-from relayout))
    (let ((views (output-views-masked output))
	  (width (car r))
	  (heigh (cadr r)))
      (dolist (v views)
	(let* ((parent (view-parent v))
	       (g (view-geometry v))
	       (s (geometry-size g)))
	  (if (view-splashp v)
	      (setf (view-geometry v)
		    (list (list (- (floor w 2) (floor (car s) 2))
				(- (floor h 2) (floor (cadr s) 2)))
			  s))
	      (setf (view-geometry v) (list (list 0 0) r)))
	  (if (= (view-state v) +activated+)
	      (return-from relayout)))))))



	    
			       
	  
