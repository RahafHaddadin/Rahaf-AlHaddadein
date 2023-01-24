
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;FinalPIC2.c,14 :: 		void interrupt(void){
;FinalPIC2.c,15 :: 		if(INTCON&0x04){// will get here every 1ms
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt0
;FinalPIC2.c,16 :: 		TMR0=248;
	MOVLW      248
	MOVWF      TMR0+0
;FinalPIC2.c,17 :: 		Dcntr++;
	INCF       _Dcntr+0, 1
	BTFSC      STATUS+0, 2
	INCF       _Dcntr+1, 1
;FinalPIC2.c,18 :: 		if(Dcntr==500){//after 500 ms
	MOVF       _Dcntr+1, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt13
	MOVLW      244
	XORWF      _Dcntr+0, 0
L__interrupt13:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt1
;FinalPIC2.c,19 :: 		Dcntr=0;
	CLRF       _Dcntr+0
	CLRF       _Dcntr+1
;FinalPIC2.c,20 :: 		myreading = ATD_read(); //taking the result every 500ms
	CALL       _ATD_read+0
	MOVF       R0+0, 0
	MOVWF      _myreading+0
	MOVF       R0+1, 0
	MOVWF      _myreading+1
;FinalPIC2.c,22 :: 		}
L_interrupt1:
;FinalPIC2.c,23 :: 		INTCON = INTCON & 0xFB; //clear T0IF
	MOVLW      251
	ANDWF      INTCON+0, 1
;FinalPIC2.c,24 :: 		}
L_interrupt0:
;FinalPIC2.c,25 :: 		}
L_end_interrupt:
L__interrupt12:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;FinalPIC2.c,27 :: 		void main() {
;FinalPIC2.c,29 :: 		TRISA=TRISA|0x01;
	BSF        TRISA+0, 0
;FinalPIC2.c,31 :: 		ADCON1 = 0xCE; // Configure AN0 to analog , right justified
	MOVLW      206
	MOVWF      ADCON1+0
;FinalPIC2.c,32 :: 		ADCON0 = 0x41; // Enable the ADC module, select AN0 channel , Fosc/16  , don't go
	MOVLW      65
	MOVWF      ADCON0+0
;FinalPIC2.c,33 :: 		INTCON=0xA0; //enable GIE and TMR0 interrupt
	MOVLW      160
	MOVWF      INTCON+0
;FinalPIC2.c,36 :: 		TRISB=TRISB&0xfe;
	MOVLW      254
	ANDWF      TRISB+0, 1
;FinalPIC2.c,40 :: 		while (1) {
L_main2:
;FinalPIC2.c,43 :: 		myVoltage = (unsigned int)(myreading*5)/1023; //the range bacomes (0-5000)mV
	MOVF       _myreading+0, 0
	MOVWF      R0+0
	MOVF       _myreading+1, 0
	MOVWF      R0+1
	MOVLW      5
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVLW      255
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _myVoltage+0
	MOVF       R0+1, 0
	MOVWF      _myVoltage+1
;FinalPIC2.c,47 :: 		if ( myreading > upper_limit || myreading < lower_limit) {
	MOVF       _myreading+0, 0
	MOVWF      R0+0
	MOVF       _myreading+1, 0
	MOVWF      R0+1
	CALL       _word2double+0
	MOVF       R0+0, 0
	MOVWF      R4+0
	MOVF       R0+1, 0
	MOVWF      R4+1
	MOVF       R0+2, 0
	MOVWF      R4+2
	MOVF       R0+3, 0
	MOVWF      R4+3
	MOVF       _upper_limit+0, 0
	MOVWF      R0+0
	MOVF       _upper_limit+1, 0
	MOVWF      R0+1
	MOVF       _upper_limit+2, 0
	MOVWF      R0+2
	MOVF       _upper_limit+3, 0
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main10
	MOVF       _myreading+0, 0
	MOVWF      R0+0
	MOVF       _myreading+1, 0
	MOVWF      R0+1
	CALL       _word2double+0
	MOVF       _lower_limit+0, 0
	MOVWF      R4+0
	MOVF       _lower_limit+1, 0
	MOVWF      R4+1
	MOVF       _lower_limit+2, 0
	MOVWF      R4+2
	MOVF       _lower_limit+3, 0
	MOVWF      R4+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main10
	GOTO       L_main6
L__main10:
;FinalPIC2.c,48 :: 		PORTB = PORTB | 0x01; //turn on LED
	BSF        PORTB+0, 0
;FinalPIC2.c,50 :: 		}
	GOTO       L_main7
L_main6:
;FinalPIC2.c,53 :: 		PORTB = PORTB & 0xfe; //turn off LED
	MOVLW      254
	ANDWF      PORTB+0, 1
;FinalPIC2.c,54 :: 		}
L_main7:
;FinalPIC2.c,57 :: 		}
	GOTO       L_main2
;FinalPIC2.c,58 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_ATD_read:

;FinalPIC2.c,61 :: 		unsigned int ATD_read(void){
;FinalPIC2.c,62 :: 		ADCON0 = ADCON0 | 0x04;// GO
	BSF        ADCON0+0, 2
;FinalPIC2.c,63 :: 		while(ADCON0 & 0x04); // Wait for the conversion to complete
L_ATD_read8:
	BTFSS      ADCON0+0, 2
	GOTO       L_ATD_read9
	GOTO       L_ATD_read8
L_ATD_read9:
;FinalPIC2.c,64 :: 		return((ADRESH<<8) | ADRESL); }  //return the result from the ATD conversion
	MOVF       ADRESH+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       ADRESL+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
L_end_ATD_read:
	RETURN
; end of _ATD_read
