#line 1 "C:/Users/Lenovo/Desktop/Final Project/PIC2/FinalPIC2.c"

 float lower_limit = 1.24 ;
 float upper_limit = 1.46;


unsigned int ATD_read(void);

 int pH_value_in_voltage;
 unsigned int myreading;
 unsigned int myVoltage;
 unsigned int Dcntr;


 void interrupt(void){
 if(INTCON&0x04){
 TMR0=248;
 Dcntr++;
 if(Dcntr==500){
 Dcntr=0;
 myreading = ATD_read();

 }
 INTCON = INTCON & 0xFB;
}
}

void main() {

TRISA=TRISA|0x01;

 ADCON1 = 0xCE;
 ADCON0 = 0x41;
 INTCON=0xA0;


 TRISB=TRISB&0xfe;



 while (1) {


 myVoltage = (unsigned int)(myreading*5)/1023;



 if ( myreading > upper_limit || myreading < lower_limit) {
 PORTB = PORTB | 0x01;

 }
 else
 {
 PORTB = PORTB & 0xfe;
 }


 }
}


unsigned int ATD_read(void){
 ADCON0 = ADCON0 | 0x04;
 while(ADCON0 & 0x04);
 return((ADRESH<<8) | ADRESL); }
