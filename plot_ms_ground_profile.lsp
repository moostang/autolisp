; --------------------------------------------------------------------------- ;
; --------------------------------------------------------------------------- ;
; FUNCTION plot_ms_ground_profile
; --------------------------------------------------------------------------- ;
; Plots ground profile in the model space of AutoCAD
;
; INPUT
;    data     Safearray containing values for x-axis of the profile. In this
;             case, we are dealing with CHAINAGE values stored in column 1.
;             Row 1 contain header fields, which have to be skipped. 
;   rowCount  Number of rows of input data
;
; OUTPUT (Graphical)
;
; DEPENDENCIES
; The variables rowCount and colCount are obtained from GETROWCOUNT function
; 
; USAGE
; Used by the main_program.lsp as:
; 
;      (_plot_ms_ground_profile data rowCount )
;
; Created on: 2019/04/09 (moostang, Calgary)
; Last Modified: 2019/04/09 (moostang, CALGARY)
; --------------------------------------------------------------------------- ;
(defun _plot_ms_ground_profile (data rowCount /
			        acDoc mspac pspace xCoord x0 elv0 stn0 elv stn
			        pt1 pt2 myLine i)
  (vl-load-com)

  (setq acDoc (vla-get-activeDocument (vlax-get-acad-Object ))         ; set active Document
        mspace (vla-get-modelSpace acDoc)                              ; Set modelSpace
  )
  

  (progn
    
    ; Read lat and lon values from safearray
    (setq i 2                                                                 ; Start from row 2 as file has header	  
	  x0     (atof (vlax-variant-value (vlax-safearray-get-element data i 3)))      ; x-coordinate values stored in column 3
	  elv0   (atof (vlax-variant-value (vlax-safearray-get-element data i 4)))      ; y-coordinate values stored in column 2
          stn0   (atof (vlax-variant-value (vlax-safearray-get-element data i 1)))      ; chainage values stored in column 1
          pt1    (vlax-3d-point x0 (+ msProfOriginY (* elv0 vertExag)) 0)                  ; Set variable as GLOBAL	  
    )

    (setq i (+ i 1))

    (repeat (- rowCount 2)

      (setq elv    (atof (vlax-variant-value (vlax-safearray-get-element data i 4)))      ; y-coordinate values stored in column 2
            stn    (atof (vlax-variant-value (vlax-safearray-get-element data i 1)))      ; chainage values stored in column 1
	    xCoord (+ x0 (- stn stn0) )
            pt2    (vlax-3d-point xCoord (+ msProfOriginY (* elv vertExag)) 0)
	    myLine (vla-addLine mspace pt1 pt2)
	    pt1    pt2
	    
	    i      (+ i 1)
      )
      (print (* elv vertExag))
    ); repeat

  );progn

  (vla-regen acadDocument acActiveViewport)
  
);defun

; --------------------------------------------------------------------------- ;
; --------------------------------------------------------------------------- ;
