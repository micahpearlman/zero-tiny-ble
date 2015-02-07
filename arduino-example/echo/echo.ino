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
  


  // initialize HM-10 (see datasheet)
  // set mode 2:
  // Mode 2:
  // Before establishing a connection, you can use the AT command configuration module through UART.
  // After established a connection, you can send data to remote side. Remote side can do fellows:
  // Send AT command configuration module.
  // Remote control PIO2 to PIO11 pins output state of HM-10.
  // Remote control PIO2, PIO3 pins output state of HM-11.
  // Send data to module UART port (not include any AT command and per
  // package must less than 20 bytes).
  // set the name
  delay(100);  
  _bluetoothSerial.write("AT+NAMEZeroTiny");
  delay(100);  
  _bluetoothSerial.write("AT+MODE2");
  delay(100);  
  _bluetoothSerial.write("AT+RESET");
  delay(100); 

}



char buffer[64];
void loop() {
  int byte_cnt = _bluetoothSerial.available();
  if(byte_cnt) {

    for(int i = 0; i < byte_cnt; i++) {
        buffer[i] = _bluetoothSerial.read();        
        delay(10);
    }
      
    buffer[byte_cnt] = '\0'; // terminate string
    _bluetoothSerial.print(buffer);
  }
  
  

  delay(10);  
}
