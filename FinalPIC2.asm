
_main:

;FinalPIC2.c,13 :: 		void main() {
;FinalPIC2.c,15 :: 		TRISA=TRISA|0x01;
	BSF        TRISA+0, 0
;FinalPIC2.c,17 :: 		ADCON1 = 0xCE; // Configure AN0 to analog , right justified
	MOVLW      206
	MOVWF      ADCON1+0
;FinalPIC2.c,18 :: 		ADCON0 = 0x41; // Enable the ADC module, select AN0 channel , Fosc/16  , don't go
	MOVLW      65
	MOVWF      ADCON0+0
;FinalPIC2.c,22 :: 		TRISB=TRISB&0xfe;
	MOVLW      254
	ANDWF      TRISB+0, 1
;FinalPIC2.c,26 :: 		while (1) {
L_main0:
;FinalPIC2.c,30 :: 		myreading = ATD_read();
	CALL       _ATD_read+0
	MOVF       R0+0, 0
	MOVWF      _myreading+0
	MOVF       R0+1, 0
	MOVWF      _myreading+1
;FinalPIC2.c,31 :: 		delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main2:
	DECFSZ     R13+0, 1
	GOTO       L_main2
	DECFSZ     R12+0, 1
	GOTO       L_main2
	DECFSZ     R11+0, 1
	GOTO       L_main2
	NOP
;FinalPIC2.c,32 :: 		myVoltage = (unsigned int)(myreading*5)/1023; //the range bacomes (0-5000)mV
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
;FinalPIC2.c,36 :: 		if ( myreading > upper_limit || myreading < lower_limit) {
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
	GOTO       L__main9
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
	GOTO       L__main9
	GOTO       L_main5
L__main9:
;FinalPIC2.c,37 :: 		PORTB = PORTB | 0x01; //turn on LED
	BSF        PORTB+0, 0
;FinalPIC2.c,39 :: 		}
	GOTO       L_main6
L_main5:
;FinalPIC2.c,42 :: 		PORTB = PORTB & 0xfe; //turn off LED
	MOVLW      254
	ANDWF      PORTB+0, 1
;FinalPIC2.c,43 :: 		}
L_main6:
;FinalPIC2.c,46 :: 		}
	GOTO       L_main0
;FinalPIC2.c,47 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_ATD_read:

;FinalPIC2.c,50 :: 		unsigned int ATD_read(void){
;FinalPIC2.c,51 :: 		ADCON0 = ADCON0 | 0x04;// GO
	BSF        ADCON0+0, 2
;FinalPIC2.c,52 :: 		while(ADCON0 & 0x04); // Wait for the conversion to complete
L_ATD_read7:
	BTFSS      ADCON0+0, 2
	GOTO       L_ATD_read8
	GOTO       L_ATD_read7
L_ATD_read8:
;FinalPIC2.c,53 :: 		return((ADRESH<<8) | ADRESL); }  //return the result from the ATD conversion
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
