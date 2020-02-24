;; ------------------------------------------------------------------------- ;;
;; ------------------------------------------------------------------------- ;;
;; Purpose: Set the magnification of the viewport to match the Horizontal    ;;
;;   Scale.                                                                  ;;
;; Limitation: Only for metric system. Unit of Modelspace is meters, layout  ;;
;;   is in millimeters. 
;; Created on: February 24, 2020                                             ;;
;; ------------------------------------------------------------------------- ;;
;; Example:
;;                                                                           ;;
;;   The following example sets the viewport's scale to match 1:1000
;;   horizontal scale, i.e. 1 mm = 1 meter.
;;
;;   (setq horizontalScale 1000.0)
;;   (setq heightMV 492.6414)
;;   (setq magnification (setMVHorizontalScale horizontalScale heightMV))
;;   (setq zCenterPt (vlax-3d-point 365366 6119059 0))
;;   (vla-ZoomCenter (vlax-get-acad-object) zCenterPt magnification)
;;                                                                           ;;
;; ------------------------------------------------------------------------- ;;
;; ------------------------------------------------------------------------- ;;
(defun setMVHorizontalScale (horizontalScale heightMV / OneMeterInMM)
      
  (setq oneMeterInMM 1000.0) ;; 1 Meter = 1000 mm ;; 
  (setq factor (/ OneMeterInMM horizontalScale))
  
  (princ (* HeightMV (/ 1.0 factor))) ;; returns magnification ;; 
      
);; defun  
