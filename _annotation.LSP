; ------------------------------------------------------------------------ ;
; ------------------------------------------------------------------------ ;
; NON-OVERLAPPING ANNOTATION                                               ;
; ------------------------------------------------------------------------ ;
; This program creates NON-OVERLAPPING labels that is associated with a    ;
; leader at each station.                                                  ;
;

; ------------------------------------------------------------------------ ;
; ------------------------------------------------------------------------ ;
;                     D E F I N E   V A R I A B L E S                      ;
;                     -------------------------------                      ;
;
; Directories
(setq fDir "//")

; Profile variables
(setq xAxisInterval 1000                                                     ; Distance between each 
      textHeight      10)                                                    ; Height of Text


; ------------------------------------------------------------------------ ;
; ------------------------------------------------------------------------ ;
; Main Program
(vl-load-com)
(setq acadDocument (vla-get-activeDocument (vlax-get-acad-Object))
      mspace (vla-get-modelSpace acadDocument)
)

(setq file (strcat fDir "elevation5_mtext.csv")) ; Get CSV file

(setq data (vlax-make-safearray vlax-vbVariant '(1 . 21) '(1 . 3)))     ; Create array to store CSV data


; ----------------------------------------------------------------------;
;                      R E A D   C S V   F I L E                        ;
; ----------------------------------------------------------------------;
(progn
  (setq fso        (vlax-create-object "Scripting.FileSystemObject")
	fileobject (vlax-invoke fso "GetFile" file)
	openfileas (vlax-invoke fileobject "OpenasTextStream" 1 0)
	)

  (setq i 1)                                                               ; Counter for arrayy index
  
  (setq temp (vlax-invoke openfileas "ReadLine"))
  
  (setq pos1 (vl-string-search "," temp 0)                                ; Find position of 1st seperator
        pos2 (vl-string-search "," temp (+ pos1 1))                       ; Find position of 2nd seperator
  )
  (setq stn (substr temp 1 pos1)                                          ; Prepare x value (station)
        elv (substr temp (+ pos1 2) (- (- pos2 pos1) 1))                  ; Prepare z value (elevation)
        txt (substr temp (+ pos2 2) (strlen temp))                        ; Prepare z value (elevation)
  )
  
  (vlax-safearray-put-element data i 1 stn)                                ; Put into array
  (vlax-safearray-put-element data i 2 elv)                                ; Put into array
  (vlax-safearray-put-element data i 3 txt)                                ; Put into array
  (setq i (+ i 1))

  
  (while (= (vlax-get openfileas "AtEndOfStream") 0)                       ; while end-of-file is FALSE (0)

    (setq temp (vlax-invoke openfileas "ReadLine"))

    (setq pos1 (vl-string-search "," temp 0)                                ; Find position of 1st seperator
          pos2 (vl-string-search "," temp (+ pos1 1))                       ; Find position of 2nd seperator
    )
	  
    (setq stn (substr temp 1 pos1)                                          ; Prepare x value (station)
          elv (substr temp (+ pos1 2) (- (- pos2 pos1) 1))                  ; Prepare z value (elevation)
          txt (substr temp (+ pos2 2) (strlen temp))                        ; Prepare z value (elevation)
    )
    
    (vlax-safearray-put-element data i 1 stn)                                ; Put into array
    (vlax-safearray-put-element data i 2 elv)                                ; Put into array
    (vlax-safearray-put-element data i 3 txt)                                ; Put into array
    (setq i (+ i 1))

  )

  (vlax-release-object openfileas)
  (vlax-release-object fileobject)
  (vlax-release-object fso       )

)
; ----------------------------------------------------------------------;
;
;
;
;
; ----------------------------------------------------------------------;
;                  L A B E L S   A N D   L E A D E R S                  ;
; ----------------------------------------------------------------------;
(setq leaderType acLineWithArrow)

(setq l (length (vlax-safearray->list data)))                                  ; Get length of array
(setq addX 0
      xShift (+ textHeight 5)                                                  ; Correct x for overlap
      i 1
)
(repeat l

  (setq x (atof (vlax-variant-value (vlax-safearray-get-element data i 1)))    ; Read array and set up x-y coordinates
        y 0                                                                    ; Keep all labels at same level 
        txt     (vlax-variant-value (vlax-safearray-get-element data i 3))
  )

  (progn                                                                       ; Set coordinates to leader
    (setq points (vlax-make-safearray vlax-vbDouble '(0 . 8)))                 ; Make empty array for leader orientation
                                                                               ; Needs to be created each time to refresh safearray                                                                          
    (vlax-safearray-put-element points 0 x)
    (vlax-safearray-put-element points 1 y)

    (vlax-safearray-put-element points 3 x)
    (vlax-safearray-put-element points 4 (+ y 15))
  )

  (if (> i 1)                                                                  ; Execute after first station has been labelled
    (if (< (- x xOld) 0)                                                       ; Check if current location lies west (before) or
                                                                               ; east (after) last plotted location. 
      (progn
	(setq addX (+ xShift (- xOld x))
	)
      )
      (progn
        (setq addX xShift
        )
      )
    )
  )
  
  (setq xHat (+ x addX)                                                        ; new location for label
        InsertionPt (vlax-3d-point xHat (+ y 25) 0)                            ; add more to y if leader is conjusted
        annotationObject (vla-addMText mspace InsertionPt 1 txt)
   )
  (vlax-put-property annotationObject 'Rotation 1.5708)                        ; Rotate to -90 degrees
  (vlax-put-property annotationObject 'Height textHeight)	              
  (setq leaderObj (vla-AddLeader mspace points annotationObject leaderType))   

  (setq i (+ i 1)
        xOld xHat
  )    
)
