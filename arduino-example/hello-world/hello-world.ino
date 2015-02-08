/*
 
 created: 11-22-2014
 by Micah Pearlman
 micah@zeroengineering.io
 www.zeroengineering.io
 
 This is BSD licensed
 
 */
// attiny85 uses software serial
#include <SoftwareSerial.h>
#  define rxPin 3
#  define txPin 4 // NOTE: pin 3 is equal to physical pin 2: see http://fc04.deviantart.net/fs70/f/2013/038/3/7/attiny_web_by_pighixxx-d5u4aur.png
  SoftwareSerial _bluetoothSerial = SoftwareSerial(rxPin, txPin);


void setup() {
  
  // initialize serial communications at 9600 bps:
  _bluetoothSerial.begin(9600); 

  delay(100); 
}


void loop() {
  _bluetoothSerial.println("Hello Zero Tiny!");     

  // delay for 1 second
  delay(1000);  
}
