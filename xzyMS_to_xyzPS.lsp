;; ------------------------------------------------------------------------- ;;
;; ------------------------------------------------------------------------- ;;
;; Purpose: Converts modelspace coordinates to paperspace coordinates.       ;;
;; Limitation: Only for metric system. Unit of Modelspace is meters, layout  ;;
;;   is in millimeters. 
;; Created on: February 24, 2020                                             ;;
;; ------------------------------------------------------------------------- ;;
;; Example:
;;                                                                           ;;
;;   The following example sets the viewport's scale to match 1:1000
;;   horizontal scale, i.e. 1 mm = 1 meter.
;;
;; SET MODELSPACE MV PARAMTERS
;; (setq xCenter_MS  361625.3310
;;       yCenter_MS 6127156.4416
;;       zCenter_MS       0.0
;;       mvCenterPt_MS (vlax-3d-point xCenter_MS yCenter_MS zCenter_MS)
;; )
;; ROTATE VIEWPORT ;; 
;; (command "_.DVIEW" ""  "_TW" twistAngle "")
;; (vla-ZoomCenter (vlax-get-acad-object) mvCenterPt_MS magnification)
;; ;; APPLY ROTATION MATRIX TO ORIGIN ;; 
;; (setq rotated (rotationMatrix  xCenter_MS yCenter_MS twistAngle))
;; (setq halfWidthMV_MS  (/ halfWidthMV scaleFactor)
;;       halfHeightMV_MS (/ halfHeightMV scaleFactor)
;; )
;; (setq xOriginMV_MS (- (nth 0 rotated) halfWidthMV_MS)
;;       yOriginMV_MS (- (nth 1 rotated) halfHeightMV_MS)
;;       zOriginMV_MS       0.0
;;       mvOriginTriplet_MS (list xOriginMV_MS yOriginMV_MS zOriginMV_MS)
;; )
;; (setq mvOriginTripletSet (list mvOriginTriplet_MS mvOriginTriplet_PS scaleFactor twistAngle))
;; (setq rotated (rotationMatrix 361535.7488 6113575.1293 twistAngle))
;; (setq xTestPt_MS (nth 0 rotated)
;;       yTestPt_MS (nth 1 rotated)
;;       zTestPt_MS       0.0
;;      testTriplet_MS (list xTestPt_MS yTestPt_MS zTestPt_MS)
;; )
;; (setq output (xzyMS_to_xyzPS mvOriginTripletSet testTriplet_MS))
;;                                                                           ;;
;; ------------------------------------------------------------------------- ;;
;; ------------------------------------------------------------------------- ;;
(defun xzyMS_to_xyzPS (mvOrig_TripletSet searchTriplet_MS
		              / ms2psScaleFactor mvTwistAngle 
                       mvOrig_Triplet_MS mvOrig_Triplet_PS 		       
		               dX dY dZ dX_PS dY_PS dZ_PS x_PS y_PS z_PS)

  (setq mvOrig_Triplet_MS (nth 0 mvOrig_TripletSet)
        mvOrig_Triplet_PS (nth 1 mvOrig_TripletSet)  
        ms2psScaleFactor (nth 2 mvOrig_TripletSet)  
        mvTwistAngle (nth 3 mvOrig_TripletSet)  
  )  
  (setq dX (- (nth 0 searchTriplet_MS) (nth 0 mvOrig_Triplet_MS))
        dY (- (nth 1 searchTriplet_MS) (nth 1 mvOrig_Triplet_MS))
        dZ (- (nth 2 searchTriplet_MS) (nth 2 mvOrig_Triplet_MS))
  )
  ;; TEST OUTPUT ;; 
  ;; (print (strcat "dX: " (rtos dX) ", dY: " (rtos dY) ", dZ: " (rtos dZ)))
  (setq dX_PS (* ms2psScaleFactor dX)
	dY_PS (* ms2psScaleFactor dY)
	dZ_PS (* ms2psScaleFactor dZ)
  )
  ;; TEST OUTPUT ;; 
  ;; (print (strcat "dX_PS: " (rtos dX_PS) ", dY_PS: " (rtos dY_PS) ", dZ_PS: " (rtos dZ_PS)))
  (setq x_PS (+ (nth 0 mvOrig_Triplet_PS) dX_PS)
	y_PS (+ (nth 1 mvOrig_Triplet_PS) dY_PS)
	z_PS (+ (nth 2 mvOrig_Triplet_PS) dZ_PS)
  )
  ;; TEST OUTPUT ;; 
  ;; (print (strcat "x_PS: " (rtos x_PS) ", y_PS: " (rtos y_PS) ", z_PS: " (rtos z_PS)))	 
  (princ (list x_PS y_PS z_PS))
  
);; defun
