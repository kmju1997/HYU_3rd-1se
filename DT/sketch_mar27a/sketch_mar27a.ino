#define SERIAL 0x0
#define DISPLAY 0x1

const int ledPin=13;
int blinkRate=0;
char Input[6];

void blink()
{
    digitalWrite(ledPin,HIGH);
    delay(blinkRate);
    digitalWrite(ledPin,LOW);
    delay(blinkRate);
}

void setup()
{
    Serial.begin(9600);
    pinMode(ledPin,OUTPUT);
}

void loop()
{
  int i;
  char ch;
    if(Serial.available())
    {
        for (i=0;i<5;i++)
        {
            if(((ch = Serial.read()) != -1) && isDigit(ch) )
            {
                Input[i] = (ch - '0');
                blinkRate=atoi(Input);
            }
        }
    }
    blink();
}
