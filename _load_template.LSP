(vl-load-com)
(setq curTmpPlt "acadISO.dwt") 
    
    (setq tmpPltPath                                                          ; Get path for template files
      (vla-get-TemplateDWGPath
	(vla-get-Files
	  (vla-get-Preferences
	    (vlax-get-acad-Object)
          )
        )
      )
   )

(if (findfile (strcat tmpPltPath "\\" curTmpPlt))                             ; Check for existence of template file

  (progn
    (vla-activate                                                             ; if file exist, make it current
      (vla-Add
        (vla-get-Documents
          (vlax-get-acad-Object)
        )
        CurTmpPlt
      )
    )
  )
  (progn
    (alert (strcat "Cannot find " curTmpPlt))                                 ; if file not found, then alert. 
  )
)
  
  
    
	   