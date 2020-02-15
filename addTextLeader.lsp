;; ------------------------------------------------------------------------- ;;
;; ------------------------------------------------------------------------- ;;
;; ------------------------------------------------------------------------- ;;
;; ------------------------------------------------------------------------- ;;
;;                       addTextLeader.lsp                                   ;;
;; ------------------------------------------------------------------------- ;;
;; ------------------------------------------------------------------------- ;;
;; ------------------------------------------------------------------------- ;;
;; PROGRAM NAME: ADD TEXT LEADER                                             ;;
;; DATE CREATED: 2020-01-31                                                  ;;
;; ------------------------------------------------------------------------- ;;
;; MODIFIED ON 2020-02-11:                                                   ;;
;; -----------------------                                                   ;;
;; 1. INCLUDE OPTION TO CHOOSE BETWEEN MODELSPACE AND PAPERSPACE.            ;;
;; MODIFIED ON 2020-02-14:                                                   ;;
;; -----------------------                                                   ;;
;; 1. UPDATED LABELLING METHOD to not overlap each other.                    ;;
;; ------------------------------------------------------------------------- ;;
;; ------------------------------------------------------------------------- ;;
(defun addTextLeader (x0 y0 spaceOption label leaderType dViewTwistAngle textHeight
		       labelAttachmentPointStyle textWidth textStyle leaderStyle dogLength
		       /
		       x1 x2 x3 y1 y2 y3 insertionPoint points txtObj leaderObj
		       workSpace acDoc
		       )

  (vl-load-com)

  (setq acDoc (vla-get-activeDocument (vlax-get-acad-Object ))         ; set active Document
  )
  ;; ----------------------------------------------------------------------- ;;
  ;; Setup workspace                                                         ;;
  ;; ----------------------------------------------------------------------- ;;  
  (if (eq spaceOption 0)
    (setq workSpace (vla-get-modelSpace acDoc)) 
    (setq workSpace (vla-get-paperSpace acDoc)) 
  )  
  ;; --------------------------------------------------------------------- ;;
  ;; Text rotation angle  
  ;; --------------------------------------------------------------------- ;;
  (setq tAngle (- 90.0 dViewTwistAngle))
  (if (< tAngle 0.0)
    (setq textRotationAngle (+ 360.0 tAngle))
    (setq textRotationAngle tAngle)
  )
  ;; --------------------------------------------------------------------- ;;
  ;; Get coordinates for insertion point
  ;; --------------------------------------------------------------------- ;;
  ;; ----------------------------------------------------------------------  ;;
  ;;                                                                         ;;
  ;;                    L                                              ;;
  ;;                    A									                          ;;
  ;;                    B                                              ;;
  ;;                    E                                              ;;
  ;;                    L                                              ;;
  ;;			              |                                              ;;
  ;;			              |                                              ;;
  ;;			              |<----- leaderDistance      					 ;;
  ;;			              |						                         ;;
  ;;dogAngle ___        |                                              ;;
  ;;			       \     /                                               ;;
  ;;			        \   /                                                ;;
  ;;			         \ / <------- dogLength                              ;;
  ;;			          /                                                  ;;
  ;;                                                                         ;;
  ;;                                                                         ;;
  ;; The dogAngle determines whethere the label tilts toward the left or     ;;
  ;; right. The currectn algorithm has been programmed to tilt towards the   ;;
  ;; right with an angle = 45 degrees.                                       ;;
  ;;                                                                         ;;
  ;; ----------------------------------------------------------------------- ;; 
  (setq dogAngle 45.0
        dogExtensionX (* dogLength (sin (deg2rad (+ viewportTwistAngle dogAngle))))
        dogExtensionY (* dogLength (cos (deg2rad (+ viewportTwistAngle dogAngle))))
  )  
  (setq leaderDistance 20.0)  
  (setq x1 (+ x0   dogExtensionX)
        y1 (+ y0   dogExtensionY )
        x1Add (* leaderDistance (cos (deg2rad textRotationAngle))) 
        y1Add (* leaderDistance (sin (deg2rad textRotationAngle)))
  )
  (setq x2 (+ x1 x1Add)
        y2 (+ y1 y1Add)
  )  
  ;; --------------------------------------------------------------------- ;;
  ;; Define coordinates for vertices of leader                             ;;
  ;; --------------------------------------------------------------------- ;;
  ;; The third vertex only becomes important if the
  ;; arrowheadsize is fixed.    
  (setq points (vlax-make-safearray vlax-vbDouble '(0 . 8)))			  
  ;; Starting Vertex
  (vlax-safearray-put-element points  0 x0  )
  (vlax-safearray-put-element points  1 y0  )    
  (vlax-safearray-put-element points  2 0.0 )    
  ;; Second Vertex
  (vlax-safearray-put-element points  3 x1  )
  (vlax-safearray-put-element points  4 y1  )
  (vlax-safearray-put-element points  5 0.0 )			                			  
  ;; Third Vertex				  
  (vlax-safearray-put-element points  6 x2  )
  (vlax-safearray-put-element points  7 y2  )
  (vlax-safearray-put-element points  8 0.0 )  
  
  ;; ------------------------------------------------------- ;;
  ;; Make Text Object
  ;; ------------------------------------------------------- ;;  
  (setq mLeader (vla-AddMLeader workSpace points 0))  
  (vlax-put-property mLeader 'TextString label)  
  (vla-put-TextRotation mLeader (deg2rad textRotationAngle)  )
  (vla-put-TextBackgroundFill mLeader 1)  
  (vlax-put-property mLeader 'DoglegLength 10)  
  
);; defun
;; ------------------------------------------------------------------------- ;;
;; ------------------------------------------------------------------------- ;;
