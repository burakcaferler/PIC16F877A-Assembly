    LIST P=16F877A
    INCLUDE P16F877.INC
    radix dec
    __CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF

MOVE_LEFT EQU 0x20
MOVE_RIGHT EQU 0x21
dir EQU 0x22
val EQU 0x23
count EQU 0x24

 
    
   org 0x00
main
  BANKSEL TRISD 
  CLRF TRISD
  BANKSEL TRISB
  CLRF TRISD
  BANKSEL PORTB
  CLRF TRISB
  
  
  MOVLW d'0'
  MOVWF MOVE_LEFT
  MOVLW d'1'
  MOVWF MOVE_RIGHT
  
  MOVF MOVE_LEFT,W
  MOVWF dir
  
  MOVLW 0x1
  MOVWF val
  
  CLRF count
  
  
loop_begin: 
    
    MOVF val,W
    MOVWF PORTD
    
    CALL DELAY
    INCF count,f
    
    if_statement_1:
     MOVLW d'15'
     SUBWF count,W
     BTFSS STATUS,Z
     GOTO else_statement_1
     MOVLW d'0'
     MOVWF PORTD
     CALL DELAY
     MOVLW 0xFF
     MOVWF PORTD
     CALL DELAY
     MOVLW d'0'
     MOVWF PORTD
     CALL DELAY
     MOVLW 0xFF
     MOVWF PORTD
     CALL DELAY
     MOVLW d'1'
     MOVWF val
     CLRF count
     MOVF MOVE_LEFT,W
     MOVWF dir
     GOTO loop_begin
     
     else_statement_1:
      if_statement_2:
       MOVLW 0x80
       SUBWF val,W
       BTFSS STATUS,Z
       GOTO if_statement_3
       MOVF MOVE_RIGHT,W
       MOVWF dir
       GOTO else_statement_2_move_right
      if_statement_3:
       MOVF MOVE_LEFT,W
       SUBWF dir,W
       BTFSS STATUS,Z
       GOTO else_statement_2_move_right
       BCF STATUS, C	; Clear the Carry bit
       RLF val,1
       GOTO loop_begin
       
       else_statement_2_move_right:
       BCF	    STATUS, C	; Clear the Carry bit
       RRF val,1
       GOTO loop_begin
    
      
     
  



DELAY:
    CALL Delay250ms
    ;CALL Delay500ms
    RETURN
    
Delay250ms:
l	EQU	    0x76		    ; Use memory slot 0x70 
m	EQU	    0x77		    ; Use memory slot 0x71
	MOVLW	    d'250'		    ; 
	MOVWF	    l			    ; j = 250
Delay250ms_OuterLoop
	MOVLW	    d'250'
	MOVWF	    m			    ; k = 250
Delay250ms_InnerLoop	
	NOP
	DECFSZ	    m, F		    ; k--
	GOTO	    Delay250ms_InnerLoop

	DECFSZ	    l, F		    ; j?
	GOTO	    Delay250ms_OuterLoop    
	RETURN

Delay500ms:
i	EQU	    0x70
j	EQU	    0x71
k	EQU	    0x72
	MOVLW	    d'2'
	MOVWF	    i			    ; i = 2
Delay500ms_Loop1_Begin
	MOVLW	    d'250'
	MOVWF	    j			    ; j = 250
Delay500ms_Loop2_Begin	
	MOVLW	    d'250'
	MOVWF	    k			    ; k = 250
Delay500ms_Loop3_Begin	
	NOP				    ; Do nothing
	DECFSZ	    k, F		    ; k--
	GOTO	    Delay500ms_Loop3_Begin

	DECFSZ	    j, F		    ; j--
	GOTO	    Delay500ms_Loop2_Begin

	DECFSZ	    i, F		    ; i?
	GOTO	    Delay500ms_Loop1_Begin    
	RETURN
    
     
    
    END





