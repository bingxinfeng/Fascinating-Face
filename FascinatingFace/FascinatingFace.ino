/*
Physical Computing Project : Fascinating Face ;-)

Author: Bingxin Feng

To do: 
1. Use light dependent resistor to sense the facial expression changing.
2. Put the serial data into Processing.
3. Use a rotatory pot to switch the output of two different light dependent resistors data.
*/

//ldr1 for wink mode, ldr2 for smile mode
const int ldrPin1 = A5;
const int ldrPin2 = A2;
const int potPin = A0;

void setup() {
  // initial the serial port for data upload:
  Serial.begin(9600); //the boundary it runs per second
}

void loop() {
  // capture data in arduino:

  // my code here:
  int ldrVal1;
  int ldrVal2;

  int potPinVal;
  potPinVal = analogRead(potPin);
  
  // switch to wink mode
  if (potPinVal == 1023) {
    ldrVal1 = analogRead(ldrPin1);
    ldrVal2 = 0;
    // put the data onto the serials port:
    Serial.println(ldrVal1); 
    delay(100);
  }
  
// switch to smile mode
  if (potPinVal == 0) {
    ldrVal1 = 0;
    ldrVal2 = analogRead(ldrPin2);
    // put the data onto the serials port:
    Serial.println(ldrVal2); 
    delay(100);
  }
}
