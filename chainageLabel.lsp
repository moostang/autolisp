;; ------------------------------------------------------------------------- ;;
;; ------------------------------------------------------------------------- ;;
;; FUNCTION chainage_label                                                   ;;
;; -----------------------                                                   ;;
;; Converts a numeric chainage value of XXXX into a string X+XXX             ;;
;;                                                                           ;;
;; INPUT:                                                                    ;;
;;                                                                           ;;
;;  chainage,                                                                ;;
;;       Chainage value (FLOAT)                                              ;;
;;                                                                           ;;
;; OUTPUT (GLOBAL):                                                          ;;
;;                                                                           ;;
;;                                                                           ;;
;; DEPENDENCIES: None                                                        ;;
;;                                                                           ;;
;; USAGE:                                                                    ;;
;;                                                                           ;;
;;    _$ (setq test_label (chainageLabel 123456)                             ;;
;;    _$ 123+456                                                             ;;
;;                                                                           ;;
;; Created on: May 31, 2019                                                  ;;
;; ------------------------------------------------------------------------- ;;
;; ------------------------------------------------------------------------- ;;
(defun chainageLabel (chainage / prefix suffix                
                     )
  (setq chainage (fix chainage))
  (if (< chainage 1000)
    (progn      
      (setq suffix (rtos chainage))      
      (while (< (strlen suffix) 3)
	    (setq suffix (strcat "0" suffix))
      );; while
	  (setq label (strcat "0+" suffix))
    );; progn	
    (progn 
      (setq prefix (substr (rtos (fix (/ chainage 1000))) 1)      
            suffix (substr (rtos chainage ) (+ (strlen prefix) 1) 3)
            label (strcat prefix "+" suffix)	      
      )
    );; progn
  );; if    
);; defun
;; ------------------------------------------------------------------------- ;;
;; ------------------------------------------------------------------------- ;;
