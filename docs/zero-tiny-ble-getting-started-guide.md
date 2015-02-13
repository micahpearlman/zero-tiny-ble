# Zero Tiny BLE Getting Started Guide

## Before You Get Started

You will need the following:

* USB mini B cable for power -OR- a 3.7V single cell LiPo battery with a JST PH 2 pin connector. [Adafruit sells a nice 3.7V 150mAH battery](https://www.adafruit.com/products/1317).
* [Arduino IDE](http://arduino.cc/en/Main/Software).  _Note: that the ATTiny85 is flashed with an Arduino bootloader_
* A programmer for the Atmel AVR ATTiny85 microcontroller.
	* [SparkFun Tiny AVR Programmer](https://www.sparkfun.com/products/11801)
	* [High-Low Tech has an excellent article on using an Arduino Duo as a programmer](http://highlowtech.org/?p=1706)
	* There are also a ton of low cost options on EBay as well.
* For iOS you will need [XCode with the iOS SDK](https://developer.apple.com/devcenter/ios/index.action).
* Example code and upto date documents on the [Zero Tiny BLE Github](https://github.com/micahpearlman/zero-tiny-ble)

## Powering Up Your Zero Tiny BLE

* Plug in a USB mini B cable -OR- 3.7V LiPo battery.
* You should see a blinking blue LED.  This means that the Bluetooth radio is up and running.  When solid blue that means Bluetooth is connected.
* _IF_ you have both a LiPo battery and a the USB plugged in you will see a green LED.  This means that the USB is charging the battery _and_ powering the board.


## Setting Up Arduino Environment for ATTiny85

_Instructions are derived from [High-Low Tech tutorial](http://highlowtech.org/?p=1695)._

1. Download and install the [Arduino IDE](http://arduino.cc/en/Main/Software)
2. Download the [ATTiny hardware files](https://github.com/damellis/attiny/archive/master.zip) for the Arduino.
3. Unzip the attiny master.zip file. It should contain an “attiny-master” folder that contains an “attiny” folder.
4. Locate your Arduino sketchbook folder (you can find its location in the preferences dialog in the Arduino software)
5. Create a new sub-folder called “hardware” in the sketchbook folder, if it doesn’t exist already.
6. Copy the “attiny” folder (not the attiny-master folder) from the unzipped ATtiny master.zip to the “hardware” folder. You should end up with folder structure like Documents > Arduino > hardware > attiny that contains the file boards.txt and another folder called variants.
7. Restart the Arduino development environment.
8. You should see ATtiny entries in the Tools > Board menu. Important: make sure that when programming your ATiny85 in the Arduino IDE that the board is set to “ATTiny85 (internal 8MHz)”

## Hello World on the Arduino

1. Download the [Hello World example sketch](https://github.com/micahpearlman/zero-tiny-ble/tree/master/arduino-example/hello-world)
2. Open this up in the Arduino IDE and compile and run using your chosen ATTiny85 programmer.

## Setting up the ZOBluetoothUART iOS Project

1. Download the [ZOBluetoothUART project from GitHub](https://github.com/micahpearlman/zero-tiny-ble/tree/master/ios-examples/ZOBluetoothUART).
2. Power up your Zero Tiny BLE.
3. Compile and run from XCode.
4. The Zero Tiny BLE blue LED should change from blinking to always on.  This means you are connected.
5. You should see "Hello Zero Tiny!" printing out every second.
