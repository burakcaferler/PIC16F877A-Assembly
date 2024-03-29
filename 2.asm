 LIST P=16F877A
    INCLUDE P16F877.INC
    radix dec
    __CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF

x EQU 0x20; x=5
y EQU 0x21; x=6
box EQU 0x22; box= depends on conditions
tmp1 EQU 0x23; tmp1=11
tmp2 EQU 0x24;tmp2=10
tmp3 EQU 0x25;tmp3=3
tmp4 EQU 0x26;tmp4=1
tmp5 EQU 0x27;tmp5=4
tmp6 EQU 0x28;tmp6=7
tmp7 EQU 0x29;tmp7=5
tmp8 EQU 0x30;tmp8=2
tmp9 EQU 0x31;tmp9=6
tmp10 EQU 0x32;tmp10=8   
 ;defining variables     
 
 org 0x00
main
    BANKSEL TRISD
    CLRF    TRISD
    BANKSEL PORTD
    
    
    MOVLW d'5' ;WREG=5
    MOVWF x    ;x = 5
   
    MOVLW d'6' ; WREG=6
    MOVWF y ; y=6
    
    
    ;if(x<0||x>11||y<0||y>10)
      ; x < 0
      BTFSS	x, 7	    ; Is x negative?
      GOTO	CHECK_IF_GT_11_LABEL
      GOTO      BOX_1;box=-1
      
CHECK_IF_GT_11_LABEL:
    ; Check if x > 11    
      MOVLW     d'11';WREG=11
      MOVWF     tmp1;tmp1=11
      
      
      MOVF	x, W        ;WREG=x
      SUBWF	tmp1	    ; WREG = tmp1 - x
      BTFSC	STATUS, C   
      GOTO CHECK_IF_Y_LESS
      GOTO BOX_1;box=-1
      
CHECK_IF_Y_LESS:
      ;y<0
       BTFSS	y, 7	    ; Is x negative?
       GOTO	CHECK_IF_Y_GT_10
       GOTO BOX_1;box=-1
CHECK_IF_Y_GT_10:
        ;Check if y > 10   
       MOVLW     d'10';WREG=10
       MOVWF     tmp2;tmp2=10
       MOVF	 y, W;WREG=y
       SUBWF	 tmp2	    ; WREG = tmp2 - y
       BTFSC	STATUS, C   
       GOTO  ELSE_IF_X_LESS_3
       GOTO	BOX_1;box=-1
      
      
      ;else if(x<=3)
ELSE_IF_X_LESS_3:
        MOVLW  d'3';WREG=3
        MOVWF  tmp3;tmp3=3
        MOVF	x, W		    ; WREG = x
	SUBWF	tmp3, W		    ; WREG = tmp3 - WREG
	BTFSS	STATUS, C	    ; 
	GOTO	ELSE_IF_X_LESS_7
	
	;if(y<=1)
ELSE_IF_Y_LESS_1:
        MOVLW     d'1';WREG=1
        MOVWF     tmp4;tmp4=1
        
        MOVF	y, W		    ; WREG = y
	SUBWF	tmp4, W		    ; WREG = tmp4 - WREG
	BTFSS	STATUS, C	    ; 
	GOTO	ELSE_IF_LESS_Y_4
	GOTO BOX_2;box=3
ELSE_IF_LESS_Y_4:
        MOVLW     d'4';WREG=4
        MOVWF tmp5;tmp5=4
        
        MOVF	y, W		    ; WREG = y
	SUBWF	tmp5, W		    ; WREG = tmp5 - WREG
	BTFSS	STATUS, C	    
	GOTO	ELSE_1
	GOTO BOX_3;box=2
ELSE_1:;else
          GOTO BOX_4;box=1
	;else if(x<=7)
ELSE_IF_X_LESS_7:
        MOVLW     d'7';WREG=7
        MOVWF tmp6;tmp6=7
        
        MOVF	x, W		    ; WREG = x
	SUBWF	tmp6, W		    ; WREG = tmp6 - WREG
	BTFSS	STATUS, C	    
	GOTO	ELSE_2
	
	
	;if(y<=5)
	MOVLW d'5';WREG=5
        MOVWF tmp7   ;tmp7=5
	
	MOVF	y, W		    ; WREG = y
	SUBWF	tmp7, W		    ; WREG = tmp7 - WREG
	BTFSS	STATUS, C	    
	GOTO	ELSE_3
	GOTO BOX_5;box=5
	
ELSE_3:;else
         GOTO BOX_6;box=4
ELSE_2:;else
          ;if(y<=2)
	   MOVLW     d'2';WREG=2
           MOVWF tmp8;tmp8=2
	  
	   MOVF	 y, W		    ; WREG = y
	   SUBWF tmp8, W	    ; WREG = tmp8 - WREG
	   BTFSS STATUS, C	    
	   GOTO	ELSE_IF_Y_LESS_6
	   GOTO BOX_7;box=9
	   ;else if(y<=6)
ELSE_IF_Y_LESS_6:
           MOVLW     d'6';WREG=6
           MOVWF tmp9;tmp9=6
           
           MOVF	 y, W		    ; WREG = y
	   SUBWF tmp9, W	    ; WREG = 6 - WREG
	   BTFSS STATUS, C	    
	   GOTO	ELSE_IF_Y_LESS_8
	   GOTO BOX_8;box=7
	   ;else if(y<=8)
ELSE_IF_Y_LESS_8:
           MOVLW     d'8';WREG=8
           MOVWF tmp10;tmp10=8
           
           MOVF	 y, W	       ; WREG = y
	   SUBWF tmp10, W      ; WREG = tmp10 - WREG
	   BTFSS STATUS, C     ; If 6>=y, then C must be SET
	   GOTO	ELSE_4
	   GOTO BOX_9;box=7
ELSE_4:;else
           GOTO BOX_10;box=6
BOX_1:
          MOVLW -d'1'
	  MOVWF box; box=-1
	  GOTO DISPLAY
BOX_2:
          MOVLW d'3';
	  MOVWF box;
	  GOTO DISPLAY
BOX_3:
	 MOVLW d'2'
	 MOVWF box;
	 GOTO DISPLAY
BOX_4:
          MOVLW d'1'
	  MOVWF box;
	  GOTO DISPLAY
BOX_5:
          MOVLW d'5'
	  MOVWF box;
	  GOTO DISPLAY
BOX_6:
          MOVLW d'4'
	  MOVWF box;
	  GOTO DISPLAY
BOX_7:
	  MOVLW d'9'
	  MOVWF box;
	  GOTO DISPLAY
BOX_8:
	  MOVLW d'8'
	  MOVWF box;
	  GOTO DISPLAY
BOX_9:
	  MOVLW d'7'
	  MOVWF box;
	  GOTO DISPLAY
BOX_10:
	  MOVLW d'6'
	  MOVWF box;
	  GOTO DISPLAY
	 	 
DISPLAY:
    
           MOVWF   PORTD ; PORTD = WREG
           GOTO    $      
   END ; End of the program   
      
      
     
	 

	 
         
	   
           
           
            
      
	   
	   
            
        
	
	
	
         
        
	 
	
	
	
	

         
    

	
	

      
      
       
      
    
    
    
    
    
    
  
    
    
    
    
    
    
    
    
    
    

    
   
 
      
	
	
	
	