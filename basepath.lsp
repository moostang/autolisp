;; ----------------------------------------------------------------- ;;
;; ----------------------------------------------------------------- ;;
;; AUTOLISP FUNCTION SIMILAR TO OS.PATH                              ;;
;; ------------------------------------                              ;;
;; FIND THE BASE PATH OF A GIVE FILE PATHNAME                        ;;
;;                                                                   ;;
;; CREATED ON: 20190711                                              ;;
;; WRITTEN BY: GYANENDRA GURUNG                                      ;;
;; ----------------------------------------------------------------- ;;

(defun basepath (path / pos posOld)

  (setq posOld 0)
  
  (setq pos (vl-string-search "\\" path posOld))

  (if (= pos nil)
    (progn    
      (setq pos (vl-string-search "/" path posOld))
    )      
  );; if  
  
  (setq output "")
  
  (while (/= pos nil)
    
    (setq output (strcat output (substr path (1+ posOld) (- pos posOld))))
    
    (setq posOld pos
          pos (vl-string-search "\\" path (1+ pos) )
    )    
    
    (if (= pos nil)
      (progn
        (setq pos (vl-string-search "/" path (1+ posOld)))	
      )
    );; if       
    
  );; while

  ;; (setq output (strcat 
);; defun
;; ----------------------------------------------------------------- ;;
;; ----------------------------------------------------------------- ;;

;; EXAMPLE USAGE

(basepath "C:\\MYFOLDER\\MYDOCUMENT\\MYPROGRAM.EXE")
