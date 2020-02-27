;; Select a line in the drawing and extract its xyz values

(defun extractXYZValuesFromLine ( / selectedLine i xyzList ent current_line)
  (setq selectedLine (ssget))
  (setq i 0)
  (setq xyzList (list))
  (repeat (sslength selectedLine)
    (setq ent (ssname selectedLine i) )
    (setq current_line (vlax-ename->vla-object ent))
    (setq xyzList (append xyzList (list (safearray-value (vlax-variant-value (vla-get-StartPoint current_line))))))
  );; repeat
  (princ xyzList)
);; defun 
