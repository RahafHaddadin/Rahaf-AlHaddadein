#line 1 "C:/Users/Lenovo/Desktop/Final Project/PIC1/FinalPIC1.c"

sbit LCD_RS at RD0_bit;
sbit LCD_EN at RD1_bit;
sbit LCD_D7 at RD5_bit;
sbit LCD_D6 at RD4_bit;
sbit LCD_D5 at RD3_bit;
sbit LCD_D4 at RD2_bit;


sbit LCD_RS_Direction at TRISD0_bit;
sbit LCD_EN_Direction at TRISD1_bit;
sbit LCD_D7_Direction at TRISD5_bit;
sbit LCD_D6_Direction at TRISD4_bit;
sbit LCD_D5_Direction at TRISD3_bit;
sbit LCD_D4_Direction at TRISD2_bit;
#line 26 "C:/Users/Lenovo/Desktop/Final Project/PIC1/FinalPIC1.c"
unsigned int temp_celcius;
char tmp1[7];
void ATD_init(void);
unsigned int ATD_read(void);
int tmp;
unsigned int temp;
void msDelay(unsigned int);
void usDelay(unsigned int usCnt);

void ATD_init(void){
ADCON0=0x41;
ADCON1=0xC0;
TRISA=0xFF;
}

unsigned int ATD_read(void){
ADCON0=ADCON0 | 0x04;
while(ADCON0&0x04);
return (ADRESH<<8)|ADRESL;
}

void msDelay(unsigned int msCnt){
 unsigned int ms=0;
 unsigned int cc=0;
 for(ms=0;ms<(msCnt);ms++){
 for(cc=0;cc<155;cc++);
 }
}
void usDelay(unsigned int usCnt)
{
 unsigned int us=0;
 for(us=0; us<usCnt; us++){
 asm NOP;
 asm NOP;
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

ATD_init();
T1CON=0x00;
Lcd_Init();
msDelay(250);

Lcd_Out(1,1, " Smart Water");
Lcd_Out(2,2, "Tank");
msDelay(3200);
Lcd_Cmd(_LCD_CLEAR);

while(1)
{
distance = findDistance();
 if(distance >= 20)
 {
 PORTB = PORTB|0x30;
 PORTB = PORTB&0xf3;

 }

else if(distance <=2 && distance>=0)
 {
 PORTB = PORTB|0x1c;
 PORTB = PORTB&0xdf;

 }

 else if(distance >= 13 && distance <= 19)
 {
 PORTB = PORTB|0x18;
 PORTB = PORTB&0xdb;


 }
 else if(distance >=2 && distance <=12)
 {
 PORTB = PORTB|0x1c;
 PORTB = PORTB&0xdf;

 }

temp_celcius=ATD_read(void);
temp_celcius=(temp_celcius*0.4887) ;

IntToStr(temp_celcius, tmp1);
ltrim(tmp1);
msDelay(20);


Lcd_Cmd(_LCD_CLEAR);

Lcd_Out(1,1, "Temp = ");
Lcd_Out(1,8,tmp1);
msDelay(800);

Lcd_Cmd(_LCD_CLEAR);


}
}
