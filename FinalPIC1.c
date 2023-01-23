// Lcd pinout settings
sbit LCD_RS at RD0_bit;
sbit LCD_EN at RD1_bit;
sbit LCD_D7 at RD5_bit;
sbit LCD_D6 at RD4_bit;
sbit LCD_D5 at RD3_bit;
sbit LCD_D4 at RD2_bit;

// Pin direction
sbit LCD_RS_Direction at TRISD0_bit;
sbit LCD_EN_Direction at TRISD1_bit;
sbit LCD_D7_Direction at TRISD5_bit;
sbit LCD_D6_Direction at TRISD4_bit;
sbit LCD_D5_Direction at TRISD3_bit;
sbit LCD_D4_Direction at TRISD2_bit;

/*
RB0 is Trig Pin
RB1 is Echo pin
RB2 is green led pin
RB3 is yellow led pin
RB4 is red led pin
RB5 is for pump
*/

unsigned int temp_celcius;
char tmp1[7]; // intialize char to store a string of 3 chars
void ATD_init(void);
unsigned int ATD_read(void);
int tmp;
unsigned int temp;
void msDelay(unsigned int);
void usDelay(unsigned int usCnt);

void ATD_init(void){
ADCON0=0x41;//ON, Channel 0, Fosc/16== 500KHz, Dont Go
ADCON1=0xC0;//RA0 Analog, others are Digital, Right Allignment
TRISA=0xFF;
}

unsigned int ATD_read(void){
ADCON0=ADCON0 | 0x04;
while(ADCON0&0x04);//wait until DONE, channel0
return (ADRESH<<8)|ADRESL;
}

void msDelay(unsigned int msCnt){
    unsigned int ms=0;
    unsigned int cc=0;
    for(ms=0;ms<(msCnt);ms++){
    for(cc=0;cc<155;cc++);//1ms
    }
}
void usDelay(unsigned int usCnt)
{
    unsigned int us=0;
    for(us=0; us<usCnt; us++){
      asm NOP;//0.5 uS
      asm NOP;//0.5uS
    }
}

int findDistance()
{
    int distance1 = 0;
    TMR1L = 0x00;
    TMR1H = 0x00;
    PORTB=PORTB|0x01;
    usDelay(10);
    PORTB=PORTB&0xfe;
    while(!RB1_BIT);
    T1CON=0x19;
    while(RB1_BIT);
    T1CON=0x18;
    distance1 = (TMR1L | (TMR1H<<8));
    distance1 = (distance1*0.034)/2;

    return distance1; }

void main() {
int distance = 0;
TRISB = 0x02;
PORTB = 0x00;
TMR1L = 0x00;
TMR1H = 0x00;
T1CON=0x00;

ATD_init(); // Initializes the ADC Module for ADC Conversions
T1CON=0x00;
Lcd_Init(); //Intializes the LCD modules
msDelay(250);

Lcd_Out(1,1, " Smart Water");// LCD Will display at row 1 column 1
Lcd_Out(2,2, "Tank"); // LCD Will display at row column 2
msDelay(3200); // Will display this for 2 seconds
Lcd_Cmd(_LCD_CLEAR); // Will clear LCD for new valuse to be displayed

while(1)
{
distance = findDistance();
            if(distance >= 20)
            {
       PORTB = PORTB|0x30;
       PORTB = PORTB&0xf3;
       //RB4, RB5 are on and RB2, RB3 are off
            }
            
else if(distance <=2 && distance>=0)
            {
       PORTB = PORTB|0x1c;
       PORTB = PORTB&0xdf;
       // RB2, RB3, RB4 are on and RB5 is off
          }

 else if(distance >= 13 && distance <= 19)
    {
       PORTB = PORTB|0x18;
       PORTB = PORTB&0xdb;
       //RB3, RB4 are on and RB2, RB5 are off

    }
    else if(distance >=2 && distance <=12)
    {
       PORTB = PORTB|0x1c;
       PORTB = PORTB&0xdf;
       // RB2, RB3, RB4 are on and RB5 is off
    }

temp_celcius=ATD_read(void);
temp_celcius=(temp_celcius*0.4887) ;//5000/1023

IntToStr(temp_celcius, tmp1);// will convert values of temp_celcius to tmp1
ltrim(tmp1);
msDelay(20);


Lcd_Cmd(_LCD_CLEAR); // Precaution clear for readings to be displayed

Lcd_Out(1,1, "Temp = ");
Lcd_Out(1,8,tmp1); // I changed column number to display result after above helping string
msDelay(800); // Keep displaying same value for 0.5 sec

Lcd_Cmd(_LCD_CLEAR); // Then clear LCD for new values


}
}