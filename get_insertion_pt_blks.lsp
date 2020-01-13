; --------------------------------- ;
; Get the insertion point of blocks ;
; --------------------------------- ;
; Created 2019-04-05                ;
; --------------------------------- ;

(setq j 0)

(repeat (length blkLyrList)

  (progn
  
    (setq name (nth j blkLyrList)
	  ss (ssget "X" (list (cons 0 "INSERT") (cons 8 name) ) )  
    )

    (setq i 0)

    (repeat (sslength ss)

      (setq ent (ssname ss i)
            entObj (vlax-ename->vla-object ent)
       )

      ;; There might be more than one attributes. Thus, we use foreach
      (foreach att (vlax-invoke entObj 'GetAttributes) 
	      (setq blkAtt (vla-get-TextString att))
      )
      (if (= blkAtt Nil)
	      (setq blkAtt "")
      )
      
      (setq outList (strcat name "," (vla-get-EffectiveName entObj) "," blkAtt ","
                           (rtos (car      (vlax-get entObj 'InsertionPoint))) ","
			                     (rtos (car (cdr (vlax-get entObj 'InsertionPoint))))
                    ); strcat
	    ); setq

      (setq i (1+ i))
      (print outList)
      (write-line outList file1)
      (princ)
      
    ); repeat
    
  ); progn
  
  (setq j (1+ j))
); repeat
