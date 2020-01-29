
;; ------------------------------------------------------------------------- ;;
;; ------------------------------------------------------------------------- ;;
;; PROGRAM NAME: PLOT X, Y, Z DATA AS A LINE
;; DATE CREATED: 2020-01-29, 13:30
;; ------------------------------------------------------------------------- ;;
;; INPUT DATA:
;; 
;;   xyzData, <ARRAY> Array containing x, y, z, and other data
;;   rowTotal, <INT> Total number of rows in xyzData
;;   indexX,  <INT> nth column containing x coordinate values in xyzData
;;   indexY,  <INT> nth column containing y coordinate values in xyzData
;;   indexZ,  <INT> nth column containing z coordinate values in xyzData
;;   headerOption, <TEXT> "TRUE" if header exist in xyzData, else "FALSE"
;;
;; ------------------------------------------------------------------------- ;;
(defun xyzToLine (xyzData rowTotal indexX indexY indexZ headerOption)

  (vl-load-com)

  (setq acDoc (vla-get-activeDocument (vlax-get-acad-Object ))         ; set active Document
        mspace (vla-get-modelSpace acDoc)                              ; Set modelSpace
  )
  
  (progn

    ;; CHECK IF HEADER IS PRESENT IN INPUT DATA ;;
    (if (eq headerOption "TRUE")
      (setq rowIndexStart 2)
    )
    
    ;; READ COORDINATES OF FIRST POINT ;;
    (setq rowIndex rowIndexStart
	  x0  (getFloat xyzData rowIndex indexX)
	  y0  (getFloat xyzData rowIndex indexY)
    )
    (if (/= indexZ nil)
      (setq z0  (getFloat xyzData rowIndex indexZ))
      (setq z0 0.0)          
    )
    (setq pt1 (vlax-3d-point x0 y0 z0))    
	
    ;; ITERATE OVER REMAINING DATA ROWS ;;
    (setq rowIndex (1+ rowIndex))    
    (repeat (- rowTotal rowIndexStart)

      (setq x  (getFloat xyzData rowIndex indexX)
            y  (getFloat xyzData rowIndex indexY)
      )
      (if (/= indexZ nil)
        (setq z (getFloat xyzData rowIndex indexZ))
        (setq z 0.0)          
      )      
      (setq pt2 (vlax-3d-point x y z))
      
      (vla-addLine mspace pt1 pt2)
      
      (setq pt1 pt2	    
	    rowIndex (1+ rowIndex)
      )
    ); repeat

  );progn  
  
);; defun

;; ------------------------------------------------------------------------- ;;
;; ------------------------------------------------------------------------- ;;
