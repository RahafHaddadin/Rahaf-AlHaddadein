
_ATD_init:

;FinalPIC1.c,35 :: 		void ATD_init(void){
;FinalPIC1.c,36 :: 		ADCON0=0x41;//ON, Channel 0, Fosc/16== 500KHz, Dont Go
	MOVLW      65
	MOVWF      ADCON0+0
;FinalPIC1.c,37 :: 		ADCON1=0xC0;//RA0 Analog, others are Digital, Right Allignment
	MOVLW      192
	MOVWF      ADCON1+0
;FinalPIC1.c,38 :: 		TRISA=0xFF;
	MOVLW      255
	MOVWF      TRISA+0
;FinalPIC1.c,39 :: 		}
L_end_ATD_init:
	RETURN
; end of _ATD_init

_ATD_read:

;FinalPIC1.c,41 :: 		unsigned int ATD_read(void){
;FinalPIC1.c,42 :: 		ADCON0=ADCON0 | 0x04;
	BSF        ADCON0+0, 2
;FinalPIC1.c,43 :: 		while(ADCON0&0x04);//wait until DONE, channel0
L_ATD_read0:
	BTFSS      ADCON0+0, 2
	GOTO       L_ATD_read1
	GOTO       L_ATD_read0
L_ATD_read1:
;FinalPIC1.c,44 :: 		return (ADRESH<<8)|ADRESL;
	MOVF       ADRESH+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       ADRESL+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
;FinalPIC1.c,45 :: 		}
L_end_ATD_read:
	RETURN
; end of _ATD_read

_msDelay:

;FinalPIC1.c,47 :: 		void msDelay(unsigned int msCnt){
;FinalPIC1.c,48 :: 		unsigned int ms=0;
	CLRF       msDelay_ms_L0+0
	CLRF       msDelay_ms_L0+1
	CLRF       msDelay_cc_L0+0
	CLRF       msDelay_cc_L0+1
;FinalPIC1.c,50 :: 		for(ms=0;ms<(msCnt);ms++){
	CLRF       msDelay_ms_L0+0
	CLRF       msDelay_ms_L0+1
L_msDelay2:
	MOVF       FARG_msDelay_msCnt+1, 0
	SUBWF      msDelay_ms_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__msDelay36
	MOVF       FARG_msDelay_msCnt+0, 0
	SUBWF      msDelay_ms_L0+0, 0
L__msDelay36:
	BTFSC      STATUS+0, 0
	GOTO       L_msDelay3
;FinalPIC1.c,51 :: 		for(cc=0;cc<155;cc++);//1ms
	CLRF       msDelay_cc_L0+0
	CLRF       msDelay_cc_L0+1
L_msDelay5:
	MOVLW      0
	SUBWF      msDelay_cc_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__msDelay37
	MOVLW      155
	SUBWF      msDelay_cc_L0+0, 0
L__msDelay37:
	BTFSC      STATUS+0, 0
	GOTO       L_msDelay6
	INCF       msDelay_cc_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       msDelay_cc_L0+1, 1
	GOTO       L_msDelay5
L_msDelay6:
;FinalPIC1.c,50 :: 		for(ms=0;ms<(msCnt);ms++){
	INCF       msDelay_ms_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       msDelay_ms_L0+1, 1
;FinalPIC1.c,52 :: 		}
	GOTO       L_msDelay2
L_msDelay3:
;FinalPIC1.c,53 :: 		}
L_end_msDelay:
	RETURN
; end of _msDelay

_usDelay:

;FinalPIC1.c,54 :: 		void usDelay(unsigned int usCnt)
;FinalPIC1.c,56 :: 		unsigned int us=0;
	CLRF       usDelay_us_L0+0
	CLRF       usDelay_us_L0+1
;FinalPIC1.c,57 :: 		for(us=0; us<usCnt; us++){
	CLRF       usDelay_us_L0+0
	CLRF       usDelay_us_L0+1
L_usDelay8:
	MOVF       FARG_usDelay_usCnt+1, 0
	SUBWF      usDelay_us_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__usDelay39
	MOVF       FARG_usDelay_usCnt+0, 0
	SUBWF      usDelay_us_L0+0, 0
L__usDelay39:
	BTFSC      STATUS+0, 0
	GOTO       L_usDelay9
;FinalPIC1.c,58 :: 		asm NOP;//0.5 uS
	NOP
;FinalPIC1.c,59 :: 		asm NOP;//0.5uS
	NOP
;FinalPIC1.c,57 :: 		for(us=0; us<usCnt; us++){
	INCF       usDelay_us_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       usDelay_us_L0+1, 1
;FinalPIC1.c,60 :: 		}
	GOTO       L_usDelay8
L_usDelay9:
;FinalPIC1.c,61 :: 		}
L_end_usDelay:
	RETURN
; end of _usDelay

_findDistance:

;FinalPIC1.c,63 :: 		int findDistance()
;FinalPIC1.c,65 :: 		int distance1 = 0;
;FinalPIC1.c,66 :: 		TMR1L = 0x00;
	CLRF       TMR1L+0
;FinalPIC1.c,67 :: 		TMR1H = 0x00;
	CLRF       TMR1H+0
;FinalPIC1.c,68 :: 		PORTB=PORTB|0x01;
	BSF        PORTB+0, 0
;FinalPIC1.c,69 :: 		usDelay(10);
	MOVLW      10
	MOVWF      FARG_usDelay_usCnt+0
	MOVLW      0
	MOVWF      FARG_usDelay_usCnt+1
	CALL       _usDelay+0
;FinalPIC1.c,70 :: 		PORTB=PORTB&0xfe;
	MOVLW      254
	ANDWF      PORTB+0, 1
;FinalPIC1.c,71 :: 		while(!RB1_BIT);
L_findDistance11:
	BTFSC      RB1_bit+0, BitPos(RB1_bit+0)
	GOTO       L_findDistance12
	GOTO       L_findDistance11
L_findDistance12:
;FinalPIC1.c,72 :: 		T1CON=0x19;
	MOVLW      25
	MOVWF      T1CON+0
;FinalPIC1.c,73 :: 		while(RB1_BIT);
L_findDistance13:
	BTFSS      RB1_bit+0, BitPos(RB1_bit+0)
	GOTO       L_findDistance14
	GOTO       L_findDistance13
L_findDistance14:
;FinalPIC1.c,74 :: 		T1CON=0x18;
	MOVLW      24
	MOVWF      T1CON+0
;FinalPIC1.c,75 :: 		distance1 = (TMR1L | (TMR1H<<8));
	MOVF       TMR1H+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       TMR1L+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
;FinalPIC1.c,76 :: 		distance1 = (distance1*0.034)/2;
	CALL       _int2double+0
	MOVLW      150
	MOVWF      R4+0
	MOVLW      67
	MOVWF      R4+1
	MOVLW      11
	MOVWF      R4+2
	MOVLW      122
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      0
	MOVWF      R4+2
	MOVLW      128
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	CALL       _double2int+0
;FinalPIC1.c,78 :: 		return distance1; }
L_end_findDistance:
	RETURN
; end of _findDistance

_main:

;FinalPIC1.c,80 :: 		void main() {
;FinalPIC1.c,81 :: 		int distance = 0;
	CLRF       main_distance_L0+0
	CLRF       main_distance_L0+1
;FinalPIC1.c,82 :: 		TRISB = 0x02;
	MOVLW      2
	MOVWF      TRISB+0
;FinalPIC1.c,83 :: 		PORTB = 0x00;
	CLRF       PORTB+0
;FinalPIC1.c,84 :: 		TMR1L = 0x00;
	CLRF       TMR1L+0
;FinalPIC1.c,85 :: 		TMR1H = 0x00;
	CLRF       TMR1H+0
;FinalPIC1.c,86 :: 		T1CON=0x00;
	CLRF       T1CON+0
;FinalPIC1.c,88 :: 		ATD_init(); // Initializes the ADC Module for ADC Conversions
	CALL       _ATD_init+0
;FinalPIC1.c,89 :: 		T1CON=0x00;
	CLRF       T1CON+0
;FinalPIC1.c,90 :: 		Lcd_Init(); //Intializes the LCD modules
	CALL       _Lcd_Init+0
;FinalPIC1.c,91 :: 		msDelay(250);
	MOVLW      250
	MOVWF      FARG_msDelay_msCnt+0
	CLRF       FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;FinalPIC1.c,93 :: 		Lcd_Out(1,1, " Smart Water");// LCD Will display at row 1 column 1
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_FinalPIC1+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;FinalPIC1.c,94 :: 		Lcd_Out(2,2, "Tank"); // LCD Will display at row column 2
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_FinalPIC1+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;FinalPIC1.c,95 :: 		msDelay(3200); // Will display this for 2 seconds
	MOVLW      128
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      12
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;FinalPIC1.c,96 :: 		Lcd_Cmd(_LCD_CLEAR); // Will clear LCD for new valuse to be displayed
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;FinalPIC1.c,98 :: 		while(1)
L_main15:
;FinalPIC1.c,100 :: 		distance = findDistance();
	CALL       _findDistance+0
	MOVF       R0+0, 0
	MOVWF      main_distance_L0+0
	MOVF       R0+1, 0
	MOVWF      main_distance_L0+1
;FinalPIC1.c,101 :: 		if(distance >= 20)
	MOVLW      128
	XORWF      R0+1, 0
	MOVWF      R2+0
	MOVLW      128
	SUBWF      R2+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main42
	MOVLW      20
	SUBWF      R0+0, 0
L__main42:
	BTFSS      STATUS+0, 0
	GOTO       L_main17
;FinalPIC1.c,103 :: 		PORTB = PORTB|0x30;
	MOVLW      48
	IORWF      PORTB+0, 1
;FinalPIC1.c,104 :: 		PORTB = PORTB&0xf3;
	MOVLW      243
	ANDWF      PORTB+0, 1
;FinalPIC1.c,106 :: 		}
	GOTO       L_main18
L_main17:
;FinalPIC1.c,108 :: 		else if(distance <=2 && distance>=0)
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      main_distance_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main43
	MOVF       main_distance_L0+0, 0
	SUBLW      2
L__main43:
	BTFSS      STATUS+0, 0
	GOTO       L_main21
	MOVLW      128
	XORWF      main_distance_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main44
	MOVLW      0
	SUBWF      main_distance_L0+0, 0
L__main44:
	BTFSS      STATUS+0, 0
	GOTO       L_main21
L__main32:
;FinalPIC1.c,110 :: 		PORTB = PORTB|0x1c;
	MOVLW      28
	IORWF      PORTB+0, 1
;FinalPIC1.c,111 :: 		PORTB = PORTB&0xdf;
	MOVLW      223
	ANDWF      PORTB+0, 1
;FinalPIC1.c,113 :: 		}
	GOTO       L_main22
L_main21:
;FinalPIC1.c,115 :: 		else if(distance >= 13 && distance <= 19)
	MOVLW      128
	XORWF      main_distance_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main45
	MOVLW      13
	SUBWF      main_distance_L0+0, 0
L__main45:
	BTFSS      STATUS+0, 0
	GOTO       L_main25
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      main_distance_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main46
	MOVF       main_distance_L0+0, 0
	SUBLW      19
L__main46:
	BTFSS      STATUS+0, 0
	GOTO       L_main25
L__main31:
;FinalPIC1.c,117 :: 		PORTB = PORTB|0x18;
	MOVLW      24
	IORWF      PORTB+0, 1
;FinalPIC1.c,118 :: 		PORTB = PORTB&0xdb;
	MOVLW      219
	ANDWF      PORTB+0, 1
;FinalPIC1.c,121 :: 		}
	GOTO       L_main26
L_main25:
;FinalPIC1.c,122 :: 		else if(distance >=2 && distance <=12)
	MOVLW      128
	XORWF      main_distance_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main47
	MOVLW      2
	SUBWF      main_distance_L0+0, 0
L__main47:
	BTFSS      STATUS+0, 0
	GOTO       L_main29
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      main_distance_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main48
	MOVF       main_distance_L0+0, 0
	SUBLW      12
L__main48:
	BTFSS      STATUS+0, 0
	GOTO       L_main29
L__main30:
;FinalPIC1.c,124 :: 		PORTB = PORTB|0x1c;
	MOVLW      28
	IORWF      PORTB+0, 1
;FinalPIC1.c,125 :: 		PORTB = PORTB&0xdf;
	MOVLW      223
	ANDWF      PORTB+0, 1
;FinalPIC1.c,127 :: 		}
L_main29:
L_main26:
L_main22:
L_main18:
;FinalPIC1.c,129 :: 		temp_celcius=ATD_read(void);
	CALL       _ATD_read+0
	MOVF       R0+0, 0
	MOVWF      _temp_celcius+0
	MOVF       R0+1, 0
	MOVWF      _temp_celcius+1
;FinalPIC1.c,130 :: 		temp_celcius=(temp_celcius*0.4887) ;//5000/1023
	CALL       _word2double+0
	MOVLW      227
	MOVWF      R4+0
	MOVLW      54
	MOVWF      R4+1
	MOVLW      122
	MOVWF      R4+2
	MOVLW      125
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	CALL       _double2word+0
	MOVF       R0+0, 0
	MOVWF      _temp_celcius+0
	MOVF       R0+1, 0
	MOVWF      _temp_celcius+1
;FinalPIC1.c,132 :: 		IntToStr(temp_celcius, tmp1);// will convert values of temp_celcius to tmp1
	MOVF       R0+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       R0+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _tmp1+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;FinalPIC1.c,133 :: 		ltrim(tmp1);
	MOVLW      _tmp1+0
	MOVWF      FARG_Ltrim_string+0
	CALL       _Ltrim+0
;FinalPIC1.c,134 :: 		msDelay(20);
	MOVLW      20
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      0
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;FinalPIC1.c,137 :: 		Lcd_Cmd(_LCD_CLEAR); // Precaution clear for readings to be displayed
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;FinalPIC1.c,139 :: 		Lcd_Out(1,1, "Temp = ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_FinalPIC1+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;FinalPIC1.c,140 :: 		Lcd_Out(1,8,tmp1); // I changed column number to display result after above helping string
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      8
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _tmp1+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;FinalPIC1.c,141 :: 		msDelay(800); // Keep displaying same value for 0.5 sec
	MOVLW      32
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      3
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;FinalPIC1.c,143 :: 		Lcd_Cmd(_LCD_CLEAR); // Then clear LCD for new values
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;FinalPIC1.c,146 :: 		}
	GOTO       L_main15
;FinalPIC1.c,147 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
