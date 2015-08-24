(in-package :hexwm)


(defmacro map-boundp (map)
  `(boundp ',map))

;;;
;;; keymap = (name prefix submap) 
;;; submap = list of keymaps and pairs
;;; pair = (bind function)
;;; bind is list of keys "C-f" = (4 101)
;;; see init.lisp for how to add keymaps and key-binds to maps

;;; *all-maps* list of keymaps
(defvar *all-maps*
  '((default-map (4 101) nil))) 

(defun make-keymap (symb prefix)
  (let ((bind (parse-bind prefix)))
    (list symb bind nil)))

(defun form-new-keymap (symb prefix &optional roots)
  (let ((new (make-keymap symb prefix)))
    (labels ((fn (maps root)
	       (cond ((or (null maps)
			  (null roots))
		      (cons new maps))
		     ((equal symb (caar maps))
		      (format t "Keymap already exists, not adding map ~a~%" symb))
		     ((equal (car root) (caar maps))
		      (cons (list (caar maps) (cadar maps) (fn (caddar maps) (cdr root)))
			    (cdr maps)))
		     (t 
		      (cons (car maps) (fn (cdr maps) root))))))
      (fn *all-maps* roots))))

(defun map-sub (map)
  (caddr map))
(defun map-prefix (map)
  (if (symbolp (car map))
      (cadr map) nil))
(defun map-name (map)
  (let ((name (car map)))
    (if (symbolp name)
	name nil)))
	

(defun add-keymap (symb prefix &optional roots)
  (setf *all-maps* (form-new-keymap symb prefix roots)))

(defun get-keymap (symbs &optional (map *all-maps*))
  (if (atom symbs) (setf symbs (list symbs)))
  (cond ((null map) nil)
	((null symbs) nil)
	((equal (car symbs) (caar map))
	 (if (null (cdr symbs))
	     (car map)
	     (get-keymap (cdr symbs) (map-sub (car map)))))
	(t (get-keymap symbs (cdr map)))))

(defun get-next-level-by-bind (bind &optional (map *all-maps*))
  (cond ((null map) nil)
	((and (map-prefix (car map)) (compare-binds bind (map-prefix (car map))))
	 (map-sub (car map)))
	((and (not (map-prefix (car map)))
	      (compare-binds bind (caar map)))
	 (car map))
	(t (get-next-level-by-bind bind (cdr map)))))

(defun set-keymap (symbs new &optional (map *all-maps*))
  (cond ((null map) nil)
	((null symbs) nil)
	((and (equal (car symbs) (caar map))
	      (null (cdr symbs)))
	 (cons new (cdr map)))
	((equal (car symbs) (caar map))
	 (cons (list (map-name (car map)) (map-prefix (car map))
		     (set-keymap (cdr symbs) new (map-sub (car map))))
	       (cdr map)))
	(t (cons (car map) (set-keymap symbs new (cdr map))))))

(defun (setf set-keymap) (val symbs new &optional (map *all-maps*))
  (setf val (set-keymap symbs new map)))



(defun first-bind (str)
  (let ((ret 0))
    (dotimes (y (length str))
      (when (char-equal #\space (aref str y))
	(setf ret y)
	(return)))
    (if (zerop ret) (length str) ret)))

(defun parse-mod-num (c)
  (case c
    (#\C 4) ; ctrl
    (#\M 8) ; alt
    (#\H 64) ; win-key
    (otherwise
     (format out "Unknown mod ~a on keybind~%" c) 0)))

(defun get-mod-char (num)
  (case num
    (4 #\C)
    (8 #\M)
    (64 #\H)
    (otherwise #\?)))
	 

(defun parse-binds (str)
  (let ((len-str (length str)))
    (if (zerop len-str) nil)
    (let* ((mod 0) (key 0)
	   (split (first-bind str))
	   (bind (subseq str 0 split))
	   (len (length bind))
	   (rest (if (= split len-str) nil (subseq str (+ split 1)))))
      (cons 
       (cond ((= 1 len) (list 0 (char-code (aref bind 0))))
	     ((= 2 len) (error "Malformed keybind ~a" bind))
	     ((= 3 len) (list (parse-mod-num (aref bind 0))
			      (char-code (aref bind 2))))
	     (t (error "Malformed keybind ~a~%" bind)))
       (if rest (parse-bind rest))))))

(defun parse-bind (str)
  (car (parse-binds str)))

(defun make-keybind (bind fn)
  (list (parse-bind bind) fn))


(defun compare-binds (bind bind2)
  (if (and (= (car bind) (car bind2))
	   (= (cadr bind) (cadr bind2))) t nil))
      ;(if (and (= mod (car bind)) (= key (cadr bind))) t nil))

(defun remove-bind (bind binds)
  (cond ((null binds) nil)
	((symbolp (car binds))
	 (cons (car binds) (remove-bind bind (cdr binds))))
	((compare-binds bind (car binds))
	 (cdr binds))
	(t (cons (car binds) (remove-bind bind (cdr binds))))))

(defun get-keybind (bind binds)
  (cond ((null binds) nil)
	((symbolp (caar binds))
	 (get-keybind bind (cdr binds)))
	((compare-binds bind (caar binds))
	 (car binds))
	(t (get-keybind bind (cdr binds)))))
	 

(defun add-keybind (maps bind fn)
  (setf bind (parse-bind bind))
  (labels ((fn (map names)
	     (cond ((null map) nil)
		   ((null names) nil)
		   ((and (equal (car names) (caar map))
			 (null (cdr names)))
		    (cons (list (map-name (car map))
				(map-prefix (car map))
				(if (null fn)
				    (remove-bind bind (map-sub (car map)))
				    (cons (list bind fn) (map-sub (car map)))))
			  (cdr map)))
		   ((equal (car names) (caar map))
		    (cons (list (map-name (car map))
				(map-prefix (car map))
				(fn (map-sub (car map)) (cdr names)))
			  (cdr map)))
		   (t (cons (car map) (fn (cdr map) names))))))
    (setf *all-maps* (fn *all-maps* (if (atom maps) (list maps) maps)))))
		      

;;; '(4 101) => "C-f"
(defun text-bind-from-numbers (binds)
  (setf binds (list binds))
  (let ((str ""))
    (dolist (bind binds)
      (let ((mod (car bind))
	    (key (code-char (cadr bind))))
	(if (zerop mod)
	    (setf str (mkstr str key))
	    (setf str (mkstr (get-mod-char mod) #\- key)))))
    str))
	


;;; return nil - pressed key goes to currently focused application
;;; return t and no application get the key press
(let ((prefix nil)
      (full-bind nil)
      (map *all-maps*)
      (map-binds nil))

  (defun init-handle-key ()
    (setf map *all-maps*))

  (defun handle-key (view mod key)
    (let ((bind (list mod key)))
      (let ((sub-map (get-next-level-by-bind bind map)))
	(cond ((null sub-map)
	       (setf map *all-maps*)
	       (if full-bind (format out "bind ~a does not exists~%" (mkstr full-bind #\space (text-bind-from-numbers bind))))
	       (setf full-bind nil)
	       nil)
	      ((consp (caar sub-map))
	       (setf full-bind (mkstr full-bind #\space (text-bind-from-numbers bind)))
	       (setf map sub-map) t)
	      (t
	       (let ((fn (cadr sub-map)))
		 (setf map *all-maps*)
		 (if fn (funcall fn view) (format out "function on bind ~a does not exists~%" 
						  (mkstr full-bind #\space (text-bind-from-numbers bind))))
		 t)))))))

