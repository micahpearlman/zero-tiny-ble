## Overview

The Zero Tiny BLE is a small low cost and low powered embeddable board with an AVR ATTiny85 microcontroller and a Bluetooth 4.0 (Bluetooth Low Energy or BLE) radio.

* AVR ATTiny85 microcontroller running at 8MHz internal clock and 3.3V. [ATTiny85 Datasheet](http://www.atmel.com/images/atmel-2586-avr-8-bit-microcontroller-attiny25-attiny45-attiny85_datasheet.pdf).
* HM-10 Bluetooth 4.0 Low Energy module.  [HM-10 Datasheet](http://www.jnhuamao.cn/bluetooth40_en.zip).
* Powered by single cell 3.7V Lithium Polymer battery (LiPo) or USB B mini port.
* LiPo battery recharge capabilities via the USB B mini port.
* Standard UART communication over Bluetooth 4.0.
* Easy prototyping via breadboard.
* Use either Arduino or AVR-GCC development environments.
* Small form factor of 20mm x 47mm (0.79” x 1.85”)

## Pinouts
![what](https://raw.githubusercontent.com/micahpearlman/zero-tiny-ble/master/docs/pinouts.png "Pin Outs")

## Programming Notes

* The ATTiny85 cannot be programmed in circuit.  It must be removed and a separate programmer such as the excellent [Sparkfun Tiny AVR Programmer](https://www.sparkfun.com/products/11801).  
* The ATTiny85 pins PB3 (RX) and PB4 (TX) are used for serial communication with the Bluetooth 4.0 radio.
* The ATTiny85 does not have hardware UART serial.  The Arduino SoftwareSerial library should be used. Example:

```
#  define rxPin 3
#  define txPin 4
SoftwareSerial _bluetoothSerial = SoftwareSerial(rxPin, txPin);

void setup() {
	// initialize serial communications at 9600 bps:
	_bluetoothSerial.begin(9600);
}

void loop() {
	_bluetoothSerial.print(“Hello World”);
}
```

* Important: make sure that when programming your ATiny85 in the Arduino IDE that the board is set to “ATTiny85 (internal 8MHz)”
