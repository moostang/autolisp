;; ------------------------------------------------------------------------- ;;
;; PROGRAM NAME: UPDATE ATTRIBUTE OF BLOCK
;; DATE CREATED: 2020-01-31
;; ------------------------------------------------------------------------- ;;
;; blkName, Name of block
;; tags, Name of tag. Can also be a list of tag names
;; labels, Label. Can also be a list of labels
;; ------------------------------------------------------------------------- ;;
(defun updateAttributes (blkName tags labels /
			 ss block attributes errObj att
			 tagLength labelLength finalLength index
			 tag label 
			 ) 
  
  (vl-load-com)
  (setq acDoc (vla-get-activeDocument (vlax-get-acad-Object ))
  )
  ;; ----------------------------------------------------------------------- ;;		  
  ;; Find block definition and read list of band names                       ;;
  ;; ----------------------------------------------------------------------- ;;
  (setq ss (ssget "_X" (list (cons 0 "INSERT") (cons 2 blkName))))
  (setq block (ssname ss 0))
  (setq blkObj (vlax-ename->vla-object block)
        attributes (vlax-safearray->list 
                     (vlax-variant-value 
                       (vla-getAttributes blkObj)))   
  );; setq
  ;; ----------------------------------------------------------------------- ;;
  ;; Update attributes                                                       ;;
  ;; ----------------------------------------------------------------------- ;;
  (setq errObj	(vl-catch-all-apply 'length (list tags)))
  (if (eq (vl-catch-all-error-p errObj) T)
    ;; --------------------------------------------------------------------- ;;
    ;; ONLY ONE TAG AND ONE LABEL
    (foreach att attributes
      (if (eq (vla-get-TagString att) tags)
        (vla-put-TextString att labels)
      )
    );; foreach
    ;; --------------------------------------------------------------------- ;;
    ;; MULTIPLE ATTRIBUTES IN BLOCK
    (progn
      ;; --------------------------------------------------------------------- ;;
      (setq tagLength (length tags)
            labelLength (length labels)	    
      )
      ;; --------------------------------------------------------------------- ;;
      ;; CHECK IF LENGTH OF TAGS AND LABELS ARE EQUAL
      (if (> (abs (- tagLength labelLength)) 0)
	(progn
          (print (strcat "!WARNING!\nLength of tags (" (itoa tagLength) ") and "
                         "length of labels (" (itoa labelLength) ") do not match.")
          )	  
        );; progn
      );; if
      ;; --------------------------------------------------------------------- ;;
      (setq index 1)
      (foreach att attributes
        (setq tag   (nth (- tagLength index) tags)
              label (nth (- labelLength index) labels)
        )
	(if (eq (vla-get-TagString att) tag)
	  (vla-put-TextString att label)
	)
	(setq index (1+ index))	
      );; foreach
    );; progn    
  );; if
(print (strcat "Attributes for block (" blkName ") udpated."))
  
);; defun
;; ------------------------------------------------------------------------- ;;
;; ------------------------------------------------------------------------- ;;
