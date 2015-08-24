(in-package :hexwm)



(add-keymap 'group "g" '(default-map))
(add-keybind 'default-map "e" (lambda (view) (exec "weston-terminal")))
(add-keybind 'default-map "q" (lambda (view) (view-close view)
				      (focus-topmost (view-output view))))
(add-keybind 'default-map "n" #'focus-next-view)
(add-keybind 'default-map "p" #'focus-previous-view)
(add-keybind 'default-map "C-q" (lambda (view) (wlc-terminate)))
(defun add-group-bind (bind fn)
  (add-keybind '(default-map group) bind fn))
(add-group-bind "c" (lambda (view) (make-group)))
(add-group-bind "n" (lambda (view) (next-group)))
(add-group-bind "p" (lambda (view) (previous-group)))

(defmacro add-group-focus-bind (num)
  `(add-keybind '(default-map group) ,(mkstr num) (lambda (view)
						    (declare (ignore view))
						 ;;; default group is 0 so we -1
						    (select-group ,(- num 1)))))
(add-group-focus-bind 1)
(add-group-focus-bind 1)
(add-group-focus-bind 2)
(add-group-focus-bind 3)
(add-group-focus-bind 4)
(add-group-focus-bind 5)
(add-group-focus-bind 6)
(add-group-focus-bind 7)
(add-group-focus-bind 8)
(add-group-focus-bind 9)

(add-keymap 'move "m" '(default-map group))

(defmacro add-group-move-bind (num)
  `(add-keybind '(default-map group move) ,(mkstr num) (lambda (view)
							 (move-to-group view ,(- num 1)))))

(add-group-move-bind 1)
(add-group-move-bind 2)
(add-group-move-bind 3)
(add-group-move-bind 4)
(add-group-move-bind 5)
(add-group-move-bind 6)
(add-group-move-bind 7)
(add-group-move-bind 8)
(add-group-move-bind 9)

(init-handle-key)



;(add-keymap 'group-move "m" '(default-map group))


;(make-keybind 'default-map "c" (lambda (view) (exec "weston-terminal")))
;(make-keybind 'default-map "q" (lambda (view) (view-close view)
;				       (focus-topmost (view-output view))))
;
;
;(let ((toggle t))
;  (defun set-v-state (view state)
;    (cond (toggle (setf toggle nil)
;		  (view-set-state view state t))
;	  (t (setf toggle t)
;	     (view-set-state view state nil)))))
;
;(defun set-fullscreen (view)
;  (set-v-state view +fullscreen+))
;(defun set-activated (view)
;  (set-v-state view +activated+))
;(defun set-maximized (view)
;  (set-v-state view +maximized+))
;(defun set-managed (view)
;  (set-v-state view +unmanaged+))
;
;
;
;;(make-keybind 'default-map "1" #'set-fullscreen)
;;(make-keybind 'default-map "2" #'set-activated)
;;(make-keybind 'default-map "3" #'set-maximized)
;;(make-keybind 'default-map "4" #'set-managed)
;;(make-keybind 'default-map "5" (lambda (view) (let* ((o (view-output view))
;;						     (r (output-resolution o)))
;;						(format out "view geo ~a ~%" (view-geometry view))
;;						(setf (view-geometry view) (list (list 0 0) r))
;;						(format out "view geo ~a ~%" (view-geometry view)))))
;
;(make-keybind 'default-map "C-q" (lambda (view) (declare (ignore view)) (wlc-terminate)))
;
;
;(make-keybind 'default-map "m" (lambda (view) (declare (ignore view))
;				       (exec "bemenu-run")))
;
;
;(make-keymap 'group-map "C-e g")
;(defun make-group-keybind (keys fn)
;  (make-keybind 'group-map keys fn))
;(defmacro group-bind-ignore-view (keys fn)
;  `(make-group-keybind ,keys (lambda (view)
;			       (declare (ignore view))
;			       (,fn))))
;(group-bind-ignore-view "n" next-group)
;(group-bind-ignore-view "p" previous-group)
;(group-bind-ignore-view "c" make-group)
;
;(defmacro select-group-bind (num)
;  `(make-keybind 'default-map ,(mkstr num) (lambda (view)
;					     (declare (ignore view))
;					     (select-group ,num))))
;
;(select-group-bind 0)
;(select-group-bind 1)
;(select-group-bind 2)
;(select-group-bind 3)
;(select-group-bind 4)
;(select-group-bind 5)
;(select-group-bind 6)
;(select-group-bind 7)
;(select-group-bind 8)
;(select-group-bind 9)
;
;;(make-keymap 'group-move-map "")
;(defmacro group-move-to-bind (num)
;  `(make-keybind 'group-map ,(mkstr num) (lambda (view)
;						(move-to-group view ,num))))
;
;(group-move-to-bind 0)
;(group-move-to-bind 1)
;(group-move-to-bind 2)
;(group-move-to-bind 3)
;(group-move-to-bind 4)
;(group-move-to-bind 5)
;(group-move-to-bind 6)
;(group-move-to-bind 7)
;(group-move-to-bind 8)
;(group-move-to-bind 9)


