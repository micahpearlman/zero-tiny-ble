//
//  FirstViewController.m
//  ZOBluetoothUART
//
//  Created by Micah Pearlman on 2/7/15.
//  Copyright (c) 2015 Micah Pearlman. All rights reserved.
//

#import "ZOMainViewController.h"
#import "ZOBluetooth.h"

@interface ZOMainViewController () <ZOBluetoothDelegate, UITextFieldDelegate> {
	ZOBluetooth* _bluetooth;
	BOOL _isBluetoothConnected;
	NSString* _peripheralName;
}

@end

@implementation ZOMainViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	_bluetooth = [[ZOBluetooth alloc] initWithDelegate:self];
	self._connectionStatusLabel.text = @"Not Connected";
	_isBluetoothConnected = false;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark UITextFieldDeleage
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	[_bluetooth write:[self._inputTextField.text dataUsingEncoding:NSASCIIStringEncoding]];
	return YES;
}

#pragma mark Send Button
- (IBAction) onSendPressed:(id)sender {
	if ( _isBluetoothConnected && [self._inputTextField.text length] > 0 ) {
		[_bluetooth write:[self._inputTextField.text dataUsingEncoding:NSASCIIStringEncoding]];
	}
}

#pragma mark ZOBluetoothDelegate

-(void) zoBluetoothDidConnect:(ZOBluetooth*)ble {
	NSLog(@"zoBluetoothDidConnect");
	self._connectionStatusLabel.text = [NSString stringWithFormat:@"Connected: %@", _peripheralName];
	_isBluetoothConnected = true;
	
}

-(void) zoBluetoothDidDisconnect:(ZOBluetooth*)ble {
	NSLog(@"zoBluetoothDidDisconnect");
	self._connectionStatusLabel.text = @"Disconnected";
	_isBluetoothConnected = false;
}

-(void) zoBluetoothDidReceiveData:(uint8_t*)data length:(uint32_t)length {
	NSString* receivedDataString = [[NSString alloc] initWithBytes:data
															length:length
														  encoding:NSUTF8StringEncoding];

	self._outputTextView.text = [self._outputTextView.text stringByAppendingString:receivedDataString];
}

- (BOOL) zoBluetoothDidDiscoverPeripheral:(ZOBluetooth *)ble peripheral:(CBPeripheral *)peripheral {
	if ( _isBluetoothConnected == NO ) {
		_peripheralName = peripheral.name;
		return YES;
	}
	return NO;	// already connected to device so reject
}


@end
