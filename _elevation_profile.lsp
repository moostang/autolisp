; DRAW ELEVATION PROFILE
; ----------------------
; This program draws (a) an elevation profile along the E-W direction,
; (b) include axis lines, (c) annotate points, and (d) draw hatches under
; some of the points.

(vl-load-com) 
(setq acadDocument (vla-get-activeDocument (vlax-get-acad-Object )))        ; set active Document
(setq mspace (vla-get-modelSpace acadDocument))                             ; Set modelSpace

(setq file (getfiled "Select CSV file" "" "csv" 16))                        ; Get CSV file 

; (a) Draw profile along E-W direction
; ------------------------------------
(setq xValues '())
(progn
  (setq fso        (vlax-create-object "Scripting.FileSystemObject")
	fileobject (vlax-invoke fso "GetFile" file)
	openfileas (vlax-invoke fileobject "OpenasTextStream" 1 0)
	)
  (setq temp (vlax-invoke openfileas "ReadLine"))
  (setq pos (vl-string-search "," temp 0))
  (setq pt1 (substr temp 1 pos))                                           ; Read z value (height)
  (setq pt2 (substr temp (+ pos 2) (strlen temp)))                         ; Read m value (EASTING)
  									   ; Read y value (NORTHING) 
  (setq startPoint (vlax-3d-point (atof pt1) (atof pt2) 0))		   ; Prepare Start Point of LINE feature

  
  (while (= (vlax-get openfileas "AtEndOfStream") 0)                       ; while end-of-file is FALSE (0)

    (setq temp (vlax-invoke openfileas "ReadLine"))
    (setq pos (vl-string-search "," temp 0))
    (setq pt1 (substr temp 1 pos))
    (setq pt2 (substr temp (+ pos 2) (strlen temp)))

    (setq endPoint   (vlax-3d-point (atof pt1)  (atof pt2) 0))
  
    (setq myLine (vla-addLine mspace startPoint endPoint))
    (setq starPoint endPoint)
  )
    
  (vlax-release-object openfileas)
  (vlax-release-object fileobject)
  (vlax-release-object fso       )

)