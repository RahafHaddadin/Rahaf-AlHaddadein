// Set lower and upper limits for pH range*/
    float lower_limit = 1.24 ;//set the lower limit to 1240mV
   float upper_limit = 1.46; //set the upper limit to 1460mV


unsigned int ATD_read(void);

    int pH_value_in_voltage;
    unsigned int myreading;
    unsigned int myVoltage;


void main() {
// ph is at RA0 (input)
TRISA=TRISA|0x01;
    // Configure the ADCON1 register
    ADCON1 = 0xCE; // Configure AN0 to analog , right justified
    ADCON0 = 0x41; // Enable the ADC module, select AN0 channel , Fosc/16  , don't go


    // Set LED pin as output in RB0
    TRISB=TRISB&0xfe;


    // Loop to continuously read pH sensor
    while (1) {


        // Read the result
      myreading = ATD_read();
      delay_ms(100);
      myVoltage = (unsigned int)(myreading*5)/1023; //the range bacomes (0-5000)mV


        // Check if the voltage corresponds to the pH value is within the desired range
        if ( myreading > upper_limit || myreading < lower_limit) {
         PORTB = PORTB | 0x01; //turn on LED

        }
        else
        {
        PORTB = PORTB & 0xfe; //turn off LED
        }


    }
}


unsigned int ATD_read(void){
  ADCON0 = ADCON0 | 0x04;// GO
  while(ADCON0 & 0x04); // Wait for the conversion to complete
  return((ADRESH<<8) | ADRESL); }  //return the result from the ATD conversion