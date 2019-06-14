;; Program to get the column number of specific field name in a table array. 
;; 
;; Usage:
;;      (getPosition table_Array_Format Name_of_Field Number_of_Columns)
;;

(defun getPosition (data FieldName colCount /
                    i 		    
                   )

  ;; FieldName variable is CaSe-SeNsItIvE
  
  (setq i 1
	iPosition nil
	notExist 0)
  (repeat colCount    
    (if (= (vlax-variant-value (vlax-safearray-get-element data 1 i)) FieldName)
      (progn
	(setq iPosition i)        
      );; progn      
    );; if
    (setq i (1+ i))    
  );; repeat
  (princ)
  (if (= iPosition nil)
    (progn
      (print (strcat "Field Name " FieldName " does not exist. Please use a valid name."))      
      (princ)
    )
  );; if
  (princ)
  iPosition
);; defun    
