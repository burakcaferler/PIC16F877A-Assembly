 LIST P=16F877A
    INCLUDE P16F877.INC
    radix dec
    __CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF

x       EQU    0x20 ;x=5
y EQU    0x21 ;y=6
z EQU    0x22 ; z=7
tmp1    EQU         0x23; 5*x
tmp2    EQU         0x24;(5*x-2*y+z)
tmp3    EQU         0x25;(5*x-2*y+z-3)
tmp4    EQU         0x26;(x+5)
tmp5    EQU         0x27;(x+5)*4
tmp6    EQU         0x28;(x+5)*4-3y+z
tmp7    EQU         0x29;x/2
tmp8    EQU         0x30;y/2
tmp9    EQU         0x31;z/4
tmp10   EQU         0x32;x/2+y/2+z/4
tmp11   EQU         0x33;3*x
tmp12   EQU         0x34;3*x-3*z)
tmp13   EQU         0x35;(3*x-3*z)-y
tmp14   EQU         0x36;(3*x-y-3*z)*2
tmp15   EQU         0x37;(3*x-y-3*z)*2-30
tmp16   EQU         0x38;3*r1
tmp17   EQU         0x39;2*r2
tmp18   EQU         0x40;3*r1+2*r2
tmp19   EQU         0x41;r3/2
tmp20   EQU         0x42;3*r1+2*r2-r3/2
tmp21   EQU         0x43;3*r1+2*r2-r3/2-r4




       
    org 0x00
main
    BANKSEL TRISD
    CLRF    TRISD
    BANKSEL PORTD

    MOVLW d'5' ;WREG=5
    MOVWF x    ;x = 5
   
    MOVLW d'6' ; WREG=6
    MOVWF y ; y=6
   
    MOVLW d'7' ;WREG=7
    MOVWF z ; z=7
   
    ; r1=(5*x-2*y+z-3)=17
   
       ;5*x
   
       MOVF x,W ; WREG=x
       ADDWF x,W; WREG=WREG+x= x+x=2*x
       ADDWF x,W; WREG=WREG+x= x+x=3*x
       ADDWF x,W; WREG=WREG+x= x+x=4*x
       ADDWF x,W; WREG=WREG+x= x+x=5*x
       MOVWF tmp1; WREG=tmp1
       
       ;2*y
       MOVF y,W; WREG=y
       ADDWF y,W; WREG=WREG+y=y+y=2*y
       
       SUBWF tmp1,W; WREG=tmp1-WREG=WREG-->(5*x-2*y)
       ADDWF z,W; WREG=WREG+z=WREG-->(5*x-2*y+z)
       MOVWF tmp2; WREG=tmp2
       CLRW
       
       MOVLW d'3'   ;WREG=3
       SUBWF tmp2,W ;WREG=tmp2-3=(5*x-2*y+z-3)
       MOVWF tmp3;WREG=tmp3
      ;r2=(x+5)*4-3*y+z 
       ;(x+5)*4
       MOVLW d'5'   ;WREG=5
       ADDWF x,W;WREG=x+5
       MOVWF tmp4; WREG=tmp1
       ADDWF tmp4,W;WREG=tmp1+WREG=(x+5)*2
       ADDWF tmp4,W;WREG=tmp1+WREG=(x+5)*3
       ADDWF tmp4,W;WREG=tmp1+WREG=(x+5)*4
       MOVWF tmp5; WREG=tmp2=(x+5)*4
    
       ;3y
       MOVF y,W;WREG=y
       ADDWF y,W; WREG=2y
       ADDWF y,W; WREG=2y
       SUBWF tmp5,W; WREG= tmp2-WREG= (x+5)*4-3y
       ADDWF z,W; WREG=WREG+z=(x+5)*4-3y+z
       MOVWF tmp6;WREG=tmp6
       
       ;r3=x/2+y/2+z/4
       CLRW;WREG=0
       MOVF x,W;WREG=x
       MOVWF tmp7;
       BCF STATUS,C
       RRF tmp7,F ;tmp7=x/2
       ;y/2
       MOVF y,W
       MOVWF tmp8;
       BCF STATUS,C
       RRF tmp8,F ;tmp8=y/2
       ;z/2
       MOVF z,W
       MOVWF tmp9;
       BCF STATUS,C
       RRF tmp9,F;tmp9=z/2
       ;z/4
       BCF STATUS,C
       RRF tmp9,F;tmp9=z/4
       
       CLRW ;WREG=0
       ADDWF 0x29,W;WREG=WREG+x/2
       ADDWF 0x30,W;  WREG=x/2+y/2
       ADDWF 0x31,W;WREG=x/2+y/2+z/4
       MOVWF tmp10; WREG=tmp10
       
       ;r4=(3*x-y-3*z)*2-30
       ;3*x
       MOVF x,W; WREG=x
       ADDWF x,W; WREG=2*x
       ADDWF x,W; WREG*3x
       MOVWF tmp11; WREG= tmp1
       ;3*z
       MOVF z,W; WREG=z
       ADDWF z,W; WREG=2*z
       ADDWF z,W; WREG=3*z
       ;(3*x-3*z)
       SUBWF tmp11,W; WREG=tmp1-WREG=(3*x-3*z)
       MOVWF tmp12; WREG=tmp2=(3*x-3*z)
       ;(3*x-y-3*z)
       MOVF y,W;
       SUBWF tmp12,W; tmp2-WREG= (3*x-3*z)-y
       MOVWF tmp13; WREG=tmp3
       ;(3*x-y-3*z)*2
       ADDWF tmp13,W; WREG=WREG+tmp3(3*x-y-3*z)*2
       MOVWF tmp14;tmp4=WREG=(3*x-y-3*z)*2
       ;(3*x-y-3*z)*2-30
       MOVLW d'30' ;WREG=30
       SUBWF tmp14,W;  tmp4-WREG=(3*x-y-3*z)*2-30
       MOVWF tmp15; WREG=tmp15
       
       ;r=3*r1+2*r2-r3/2-r4
        ;3*r1
        MOVF tmp3,W;WREG=tmp3=r1
	ADDWF tmp3,W;WREG=tmp3+WREG=2*r1
	ADDWF tmp3,W;WREG=tmp3+WREG=3*r1
	MOVWF tmp16;tmp16=WREG=3*r1
	;2*r2
	MOVF tmp6,W;WREG=tmp6=r2
	ADDWF tmp6,W;WREG=tmp6+WREG=2*r2
	MOVWF tmp17; WREG=tmp17=2*r2
	;3*r1+2*r2
	CLRW; WREG=0
	MOVF tmp16,W;WREG=tmp16=3*r1
	ADDWF tmp17,W;WREG=3*r1+tmp17=3*r1+2*r2
	MOVWF tmp18; WREG=tmp18=3*r1+2*r2
	;r3/2
	CLRW;WREG=0
	MOVF tmp10,W;WREG=tmp10=r3
        MOVWF tmp19;
        BCF STATUS,C
        RRF tmp19,F;tmp19=r3/2
	
	CLRW;
	ADDWF 0x41,W;WREG=0+r3/2
	SUBWF tmp18,W;WREG tmp18-WREG=3*r1+2*r2-r3/2
	MOVWF tmp20;WREG=tmp20=3*r1+2*r2-r3/2
	CLRW;WREG=0
	ADDWF 0x37,W;WREG=tmp15
	SUBWF tmp20,W;WREG=tmp20-WREG=3*r1+2*r2-r3/2-r4
	MOVWF tmp21;
	CLRW
	ADDWF 0x43,W;
	
	
	MOVWF   PORTD ; PORTD = WREG
       GOTO    $
    
   
 
    END ; End of the program
	
	
	
	
	
	
	
	
	
	
       
       
    
    
       
       
       


