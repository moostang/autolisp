;; GET SELECTION ;;
(setq ss (ssget "_X" (list (cons 0 "INSERT") (cons 2 "att_blk"))))

;; GET NAME OF FIRST IN SELECTION ;;
(setq blkName (ssname ss 0))

;; CONVERT TO OBJECT
(setq blkObj (vlax-ename->vla-object blkName))

;; ITERATE THROUGH ATTRIBUTES

(foreach att (vlax-safearray->list (vlax-variant-value (vla-getAttributes blkObj)))
  (print (vla-get-TagString att))
  (print (vla-get-TextString att))
)
