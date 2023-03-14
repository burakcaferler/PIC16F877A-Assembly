    ;152120201144-Burak CAFERLER
    LIST P=16F877A
    INCLUDE P16F877.INC
    radix dec
    __CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF

x EQU 0x20;
y EQU 0x21;
N EQU 0x22;
A EQU 0x23;
tmp EQU 0x63
tmp1 EQU 0x64
Q1 EQU 0x65
sum EQU 0x66
i EQU 0x67
j EQU 0x68
noElements EQU 0x69
R_L EQU 0x70
R_H EQU 0x71
 t EQU 0x72
 tmp2 EQU 0x73
 tmp3 EQU 0x74
 noElement equ 0x75
 
org 0x00
main
 MOVLW d'112'
 MOVWF x;
 
 MOVLW d'100'
 MOVWF y;
 
 MOVLW d'125'
 MOVWF N;
 
 CALL GenerateNumbers
 MOVWF noElement
 CALL AddNumbers
 MOVWF sum
 CALL DisplayNumbers
 
   
    
    
 Multiply:
    MOVF y,W
    MOVWF tmp3
    CLRF    R_L		; R_L = 0
    CLRF    R_H		; R_H = 0
    MOVF    y, F	; Y = Y
    BTFSC   STATUS, Z	; Is Y==0?
    RETURN		; Return from the function if Y == 0

    MOVF   x,W		; WREG = X
   
   
    Mult8x8_Loop
     ADDWF   R_L, F	; R_L = R_L + WREG
     BTFSC   STATUS, C	; Is there a carry from this addition?
     INCF    R_H, F	; R_H = R_H + 1
     DECFSZ  tmp3, F	; Y = Y-1
     GOTO    Mult8x8_Loop
     MOVF R_L,W
     ADDWF R_L,W
     ADDWF R_H,W 
     RETURN		; Return from the function
    
    		; End of the program
    
    
    
    
    
  GenerateNumbers:
    MOVLW   A		;WREG = &A[0]
    MOVWF   FSR		;FSR =  &A[0] 
    CLRF    noElements	;COUNT = 0 
    loop_begin1:
     MOVF N,W;
     SUBWF x,W; x-N
     BTFSC STATUS,C; if x<N the C must not set
     GOTO CHECK_Y
      if_statement:
        MOVF y,W;
	ADDWF x,W; WREG=x+y
	MOVWF tmp;
	BTFSS tmp,0
	GOTO else_statement
	CALL Multiply
	MOVWF   INDF
        INCF    FSR,F
        INCF    noElements,F	;count++
	INCF x,f ; 
	GOTO loop_begin1
	
	
      else_statement:
       MOVF y,W
       ADDWF x,W;WREG=x+y
       MOVWF tmp1; tmp1= x+y
       
       CALL DIV1
       MOVWF   INDF
       INCF    FSR,F
       INCF    noElements,F
       MOVLW d'3'
       ADDWF y,f
       GOTO loop_begin1
      
       DIV1:;tmp/3
        CLRF    Q1		; Q = 0 (Quotient, i.e., the result
	MOVLW    d'3'		; WREG = 3
	MOVWF t
	MOVF tmp1,W
	MOVWF tmp2
       Divide_Loop
         MOVF t,W
         SUBWF   tmp2, W		; WREG = tmp1 - WREG
         BTFSS   STATUS, C	; Was the result of the previous subtraction less than 0?
         GOTO    Division_End	; If (X < Y) we are done ;
         INCF    Q1, F		; Q++
         MOVWF   tmp2		; tmp1 = WREG
         GOTO    Divide_Loop
    
        Division_End
          MOVF Q1,W
           RETURN
    loop_begin2:
      CHECK_Y:
        MOVF N,W;
        SUBWF y,W; y-N
        BTFSC STATUS,C; if y<N the C must not set
        GOTO loop_end
        GOTO if_statement
    loop_end:
       
       RETURN
       
  AddNumbers:
      CLRF sum; sum=0
      CLRF i; i=0
      MOVLW A
      MOVWF FSR
        loop_start:
      
        MOVF    INDF, W	    ; WREG <- A[FSR] (Load the array element pointed to by the FSR into WREG)
        ADDWF   sum, F	    ; sum = sum + WREG 
	INCF    FSR, F	    ; Increment FSR so that in points to the next array element
        DECFSZ noElements,F
        GOTO    loop_start 
    loop_endd:
         MOVF sum,W
	 RETURN
	 
    DisplayNumbers:
    BANKSEL TRISD
    CLRF TRISD
    MOVLW   0xFF
    MOVWF   TRISB
    BANKSEL PORTD
    
    button_loop
    BTFSC PORTB, 3
    GOTO button_loop
    CALL Delay250ms
    
    MOVF sum,W
    MOVWF PORTD
    
    CLRF j;j=0
    MOVLW A
    MOVWF FSR
       
     
    loop_starttt:
    button_loop1:
    BTFSC PORTB, 3
    GOTO button_loop1
    MOVLW d'5'
    SUBWF j,W;
    BTFSC STATUS,C
    GOTO loop_enddd
    
    
       MOVF    INDF, W	    ; WREG <- A[FSR] (Load the array element pointed to by the FSR into WREG)
       MOVWF PORTD
       CALL Delay250ms

       INCF    FSR, F	    ; Increment FSR so that in points to the next array element
       INCF  j, F   ; j = j + 1
    GOTO    loop_starttt    



Delay250ms:
k	EQU	    0x76		    ; Use memory slot 0x70
l	EQU	    0x77		    ; Use memory slot 0x71
	MOVLW	    d'250'		    ; 
	MOVWF	    k			    ; j = 250
Delay250ms_OuterLoop
	MOVLW	    d'250'
	MOVWF	    l			    ; k = 250
Delay250ms_InnerLoop	
	NOP
	DECFSZ	    l, F		    ; k--
	GOTO	    Delay250ms_InnerLoop

	DECFSZ	    k, F		    ; j?
	GOTO	    Delay250ms_OuterLoop    
	RETURN
loop_enddd:
    GOTO    $   
    
    END