;; ------------------------------------------------------------------------- ;;
;; ------------------------------------------------------------------------- ;;
;; Find pairs of coordinates for matchlines along a centerline.              ;;
;; Created on: March 02, 2019                                                ;;
;; ------------------------------------------------------------------------- ;;
;; ------------------------------------------------------------------------- ;;

(defun createStripMap(data rowCount fieldMXYZIndices matchlineInterval headerOption /
                      rowStartIndex overlapDistance fieldMIndex totalLength matchlineCount
					  beforeTriplet matchlineIndex mMatchline  afterTriplet pairList
					  )

  ;; Get index of first row ;;
  (setq rowStartIndex (getRowStartIndex headerOption))
  ;; Calculate overlapping distance ;; 
  (setq overlapDistance (* 0.10 matchlineInterval)) ;; 10% of matchlineInterval    
  ;; Get Index for mValue ;;
  (setq fieldMIndex (nth 0 fieldMXYZIndices))
  ;; Make list m values to position matchlines ;;  
  (setq totalLength (getFloat data rowCount fieldMIndex)
        matchlineCount (ceil (/ totalLength matchlineInterval) 1)
  )
  (print (strcat "totalLength: ;" (rtos totalLength) ", matchlineCount: " (itoa matchlineCount)))
  
  ;; Prepare empty list ;; 
  (setq matchlinePairList nil)

  ;; TEST OUTPUT ;;
  (print "Getting coordinates of first matchline pair")  (princ)
  (setq beforeTriplet (getMatchlineTriplet data rowCount headerOption (- 0 overlapDistance) fieldMXYZIndices))
  
  
  ;; TEST OUTPUT ;;
  (print (strcat "Looping over other matchlines. matchlineCount: " (itoa matchlineCount)))
  (setq matchlineIndex 1)    
  (repeat matchlineCount   
    (print (strcat "matchlineIndex: " (itoa matchlineIndex)))  
    (setq mMatchline (* (float matchlineIndex) matchlineInterval)
          afterTriplet (getMatchlineTriplet data rowCount headerOption mMatchline fieldMXYZIndices)
    )
	  
	;; Calculate central coordinates ;;	
	(setq centralCoordinates (getCentralCoordinates beforeTriplet afterTriplet))	
	;; Append to output list ;; 
    (setq pairList (list matchlineIndex beforeTriplet afterTriplet centralCoordinates)
          matchlinePairList (append matchlinePairList (list pairList))
		  beforeTriplet nil		  
          beforeTriplet afterTriplet
		  afterTriplet nil
		  pairList nil
		  centralCoordinates nil
	)
  (setq matchlineIndex (1+ matchlineIndex))	
  );; repeat
);; defun

(defun getMatchlineTriplet (data rowCount headerOption mValue fieldIndices / 
                                   fieldMIndex rowStartIndex rowIndex totalRows mNext 
                                   mDistance mNextIndex mNextTriplet mBeforeTriplet
                                   geomAtt mAngle mTriplet mBefore m0 mEnd)

  (if (< (length fieldIndices) 3)					 
    (progn
	  (alert "[getMatchlineTriplet] Length of fieldIndices is less than 3")
	  (exit)
	);; progn
  )  
  
  ;; Get Index for mValue ;;
  (setq fieldMIndex (nth 0 fieldIndices))		
  
  ;; Prepare fore iteration ;;
  (setq rowStartIndex (getRowStartIndex headerOption)
        rowIndex rowStartIndex
        totalRows (- rowCount rowStartIndex)		
  )  
  
  (setq m0   (getFloat data rowStartIndex fieldMIndex)
        mEnd (getFloat data rowCount      fieldMIndex)  
  )
  ;; TEST OUTPUT ;;
  (print (strcat "mValue: " (rtos mValue) ", m0: " (rtos m0) ", mEnd: " (rtos mEnd)))
  
  (cond
   ;; Condition 1: If mValue comes before first mvalue in data ;;
   ((< mValue m0)
     (progn
	   ;; TEST OUTPU ;;
	   (print "  Inside Condition 1")
	   (print rowStartIndex)
	   (print fieldIndices)
       (setq mNextTriplet   (getTriplet data    rowStartIndex    fieldIndices)	   )
       (setq mBeforeTriplet (getTriplet data (+ rowStartIndex 1) fieldIndices))
       (setq mBefore        (getFloat data   (+ rowStartIndex 1) fieldMIndex) )
       (setq mDistance (- mValue m0)) ;; (- m0 mValue) if bearing is in opposite direction  ;;
	   (print "  End of Condition 1")  	   
     );; progn	
   );; Condition 1
   
   ;; Condition 2 : For other m values ;;
   ( (and (> mValue m0) (<= mValue mEnd))
	(print "  Inside Condition 2")   
    ;; Iterate ;;
    (setq flagRepeat 1)
    (repeat totalRows
      (if (eq flagRepeat 1)
        (progn 	
          (setq mNext (getFloat data rowIndex fieldMIndex))		
  		(if (> mNext mValue)
  	      (progn
  	        (setq mNextIndex rowIndex		      
  	     		  mNextTriplet   (getTriplet data    mNextIndex    fieldIndices)
  	     		  mBeforeTriplet (getTriplet data (- mNextIndex 1) fieldIndices)
  				  mBefore        (getFloat data   (- mNextIndex 1) fieldMIndex)
  				  mDistance (- mValue mBefore)
  	     	)		
               (setq flagRepeat 0) ;; Set flag to 0 after finding correct m value ;;
  	      );; progn
  		);; if		
        );; progn
      );; if 
      (setq rowIndex (1+ rowIndex))	
    );; repeat 
   );; Condition 2   
   
   ;; Condition 3 : For last m value ;;
   ((> mValue mEnd)
	(print "  Inside Condition 3")      
    (progn
      (setq mNextTriplet   (getTriplet data    rowCount    fieldIndices)
            mBeforeTriplet (getTriplet data (- rowCount 1) fieldIndices)            
			mBefore        (getFloat data   (- rowCount 1) fieldMIndex)  
            mDistance (- mValue mEnd)
      )		        
    );; progn    
   );; Condition 3    
   
  );; cond 
  
  ;; Calculation ;;
  (setq geomAtt (getGeometryAttributes mBeforeTriplet mNextTriplet)
        mAngle (nth 3 geomAtt)		
   )
  (setq mTriplet (getNextCoordinates mBeforeTriplet mDistance mAngle))  
  
  ;; OUTPUT ;;
  (princ mTriplet)
);; defun 


(defun getTriplet (data row fieldIndices)
  (print "[getTriplet]")
  (print fieldIndices)
  
  (cond
   ((eq (length fieldIndices) 4)
      ;;  Check for nil Z values ;;
      (if (eq (nth 3 fieldIndices) nil)
        (setq zValue 0.0)
      )
	  
      (list (getFloat data row (nth 1 fieldIndices))
            (getFloat data row (nth 2 fieldIndices))   
            zValue
       )
   )		
   ((eq (length fieldIndices) 3)
      ;;  Check for nil Z values ;;
      (if (eq (nth 2 fieldIndices) nil)
        (setq zValue 0.0)
      )
   
       (list (getFloat data row (nth 0 fieldIndices))
             (getFloat data row (nth 1 fieldIndices))   
             zValue
        )
   )
   (alert "[getTriplet] Something wrong with fieldIndices")   
  );; cond	 
);; defun 

(defun getCentralCoordinates (m1Triplet m2Triplet / geomAtt hHalf)

  (setq geomAtt (getGeometryAttributes m1Triplet m2Triplet))
  (setq hHalf (* 0.5 (nth 2 geomAtt)))
  (setq xyCenter (getNextCoordinates m1Triplet hHalf (nth 3 geomAtt)))
  (princ (list (nth 0 xyCenter) (nth 1 xyCenter) (nth 2 xyCenter) (nth 3 geomAtt)))
  
);; defun 

(defun getNextCoordinates (baseTriplet extendeDistance angleDegrees / xNew yNew)
  (setq xNew (+ (nth 0 baseTriplet) (* extendeDistance (cos (deg2rad angleDegrees))))
        yNew (+ (nth 1 baseTriplet) (* extendeDistance (sin (deg2rad angleDegrees))))
        zNew 0.0		
  )
  ;; TEST OUTPUT ;;
  ;; (princ (strcat "xNew: " (rtos xNew) ", yNew: " (rtos yNew)))(princ)
  (list xNew yNew zNew)
);; defun 


(defun getGeometryAttributes (pt1Triplet pt2Triplet / b p h aDeg)
  (setq b (- (nth 0 pt2Triplet) (nth 0 pt1Triplet))
        p (- (nth 1 pt2Triplet) (nth 1 pt1Triplet))
		h (sqrt (+ (* b b) (* p p)))
		aDeg (bearing (nth 0 pt1Triplet) (nth 1 pt1Triplet) (nth 0 pt2Triplet) (nth 1 pt2Triplet)) 
  )	
  ;; TEST OUTPUT ;;
  ;; (print (strcat "b: " (rtos b) ", p: " (rtos p) ", h: " (rtos h) ", angle: " (rtos aDeg)))
  (list b p h aDeg)
);; defun 


;; ------------------------------------------------------------------------- ;;  
;; GET BEARING                                                               ;;
;; ------------------------------------------------------------------------- ;;
;; Created on: 2020-02-14
;; ------------------------------------------------------------------------- ;;
(defun bearing (x1 y1 x2 y2)  
  (if (/= (- x2 x1) 0.0)
    (rad2deg (atan (- y2 y1) (- x2 x1))) ;; (rad2deg (atan (/ (- y2 y1) (- x2 x1)))) ;; 
	(if (< (- y2 y1) 0)
      (rad2deg (- 0 (/ pi 2.0)))
      (rad2deg (/ pi 2.0))
    )	  
  )
)

(defun getRowStartIndex (headerOption)
  (if (eq headerOption "TRUE")
    (princ 2)
    (princ 1)
  )
);; defun 
