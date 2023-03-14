 LIST P=16F877A
    INCLUDE P16F877.INC
    radix dec
    __CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF

zib0 EQU 0x20; zib0=1
zib1 EQU 0x21; zib1=2
zib EQU 0x22;  zib
i EQU 0x23; i=2
N EQU 0x24; N=13
tmp1 EQU 0x25;
tmp2 EQU 0x26;
tmp3 EQU 0x27;

   
    org 0x00
main
    BANKSEL TRISB
    MOVLW   0xFF
    MOVWF   TRISB
    CLRF    TRISD
    BANKSEL PORTD
    CLRF PORTD
   
   
  MOVLW d'1'; WREG=1;
  MOVWF zib0; zib0=1
 
  MOVLW d'2';WREG=2
  MOVWF zib1; zib1=2
 
  MOVLW d'13'; WREG=13
  MOVWF N; N=13
 
  MOVLW d'2'    ; WREG = 1
  MOVWF i    ; i = WREG
  
loopBegin
  BTFSC PORTB, 3
  GOTO loopBegin
  
loop_begin
; Check if i<=N? If not, we will terminate the loop
; The loop terminates when i > N or N < i.
  MOVF i, W    ; WREG = i
  SUBWF N, W    ; WREG = N - i
  BTFSS STATUS, C    ; No carry means N < i. Carry means N >= i or i <= N
  GOTO loop_end    ; when i > N, the loop terminates
loop_body    ; 
 MOVLW 0x3f; WREG=0x3f
 ANDWF zib1,W; zib1&WREG
 MOVWF tmp1; tmp1=zib1&WREG

 MOVLW 0x05;WREG=0x05
 IORWF zib0,W; zib0|WREG
 MOVWF tmp2; tmp2= zib0|WREG

 ADDWF tmp1,W;WREG=tmp1+WREG
 MOVWF tmp3; tmp3=WREG

 MOVF zib1,W; WREG=zib1
 MOVWF zib0; zib0=WREG =zib1

 MOVF tmp3,W; WREG= tmp3;
 MOVWF zib1; WREG= zib1
 
loopBegin1
  BTFSC PORTB, 3
  GOTO loopBegin1
 
   MOVF tmp3,W
   MOVWF PORTD
   CALL Delay250ms
  
  INCF i, F    ; i++
  GOTO loop_begin
loop_end:
         
       GOTO    $      
 

Delay250ms:
j	EQU	    0x70		    ; Use memory slot 0x70
k	EQU	    0x71		    ; Use memory slot 0x71
	MOVLW	    d'250'		    ; 
	MOVWF	    j			    ; j = 250
Delay250ms_OuterLoop
	MOVLW	    d'250'
	MOVWF	    k			    ; k = 250
Delay250ms_InnerLoop	
	NOP
	DECFSZ	    k, F		    ; k--
	GOTO	    Delay250ms_InnerLoop

	DECFSZ	    j, F		    ; j?
	GOTO	    Delay250ms_OuterLoop    
	RETURN
   END ; End of the program  
   


