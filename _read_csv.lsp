; Program to read CSV file
;; Written by: Gyanendra Gurung                                              ;;
(vl-load-com) 
(setq acDoc (vla-get-activeDocument (vlax-get-acad-Object ))         ; set active Document
)
; Directories
(setq fDir "YOUR DIRECTORY"
      fName "YOURCSVFILE.csv"
      file (strcat fDir fName)
)

; Check the number of columns and rows of the input CSV file 
(progn
  (setq fso (       vlax-create-object "Scripting.FileSystemObject")
	filObj (    vlax-invoke fso "GetFile" file)
	openfileas (vlax-invoke filObj "OpenasTextStream" 1 0)
  )
  
  (setq rowCount 0)                                                            ; Set row index as 0 as counting begins at top
  
  (while (= (vlax-get openfileas "AtEndOfStream") 0)                           ; Iterate for each row
     
    (setq rowCount (+ rowCount 1)
	  temp (vlax-invoke openfileas "ReadLine")                             ; Read line
	  totalLength (strlen temp)                                            ; Complete length of readline
	  pos1 0)                                                              ; First position of 'comma'

    ; Begin iteration
    
    (setq pos2 (vl-string-search "," temp pos1)                                ; Set second position of 'comma'
	  colWidth (- pos2 pos1)                                               ; Width of Column
	  pos1 (+ pos2 1)                                                      ; Assign new value for first position
	  colcount 1
     )
    
    (progn                                                                     
      (while (/= nil (vl-string-search "," temp pos1))                         ; Iterate for each column
        (setq pos2 (vl-string-search "," temp pos1)
  	      colWidth (- pos2 pos1)
	      pos1 (+ pos2 1)
	      colCount (+ colcount 1)                                          ; Set index for each columnn
	)	
      ); while
      (setq colCount (+ colcount 1))                                           ; Set index for last column
    ); progn

  ); while

  (alert (strcat "File " fName
		 " has " (itoa colCount)
		 " columns and " (itoa rowCount)
                 " rows.")
   )

  (vlax-release-object openfileas)
  (vlax-release-object     filObj)
  (vlax-release-object        fso)
); progn

; Create array to store CSV data
(setq data (vlax-make-safearray vlax-vbVariant (cons 1 rowCount) (cons 1 colCount)))

; Read CSV file again, but this time put it inside array
(progn
  (setq fso        (vlax-create-object "Scripting.FileSystemObject")
	fileObj (vlax-invoke fso "GetFile" file)
	openfileas (vlax-invoke fileObj "OpenasTextStream" 1 0)
	)

  (setq rowCount 0)                                                         ; Counter for array index
  (while (= (vlax-get openfileas "AtEndOfStream") 0)
    
    (setq rowCount (+ rowCount 1)
	  temp (vlax-invoke openfileas "ReadLine")
	  totalLength (strlen temp)
	  pos1 0
    )

    
    ; Begin iteration
    (setq pos2 (vl-string-search "," temp pos1)
	  colWidth (- pos2 pos1)
	  colCount 1
    )
    ; Put data for first column
    (vlax-safearray-put-element data rowCount colCount (substr temp (+ pos1 1) colWidth))

    (setq pos1 (+ pos2 1))

    (progn
      
      (while (/= nil (vl-string-search "," temp pos1))
        (setq pos2 (vl-string-search "," temp pos1)
	      colWidth (- pos2 pos1)
	      colCount (+ colCount 1)
	)

	; Put data in each column
        (vlax-safearray-put-element data rowCount colCount (substr temp (+ pos1 1) colWidth))
	
        (setq pos1 (+ pos2 1))
      ); while
      (setq colWidth (- totalLength pos1)
	      colCount (+ colCount 1)
      )
      ; Put data in last column
      (vlax-safearray-put-element data rowCount colCount (substr temp (+ pos1 1) colWidth))      
      
    ); progn
    
  ); while

  (vlax-release-object openfileas)
  (vlax-release-object fileObj)
  (vlax-release-object fso       )

)



