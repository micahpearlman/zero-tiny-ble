//
//  ZOBluetooth.h
//  ZeroGPSLapTimer
//
//  Created by Micah Pearlman on 12/29/13.
//  Copyright (c) 2013 Micah Pearlman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h> 

@protocol ZOBluetoothDelegate;
@interface ZOBluetooth : NSObject

@property (nonatomic,assign) id<ZOBluetoothDelegate> delegate;
@property (nonatomic,readonly) NSArray* peripherals;

-(id) initWithDelegate:(id<ZOBluetoothDelegate>) delegate;

-(void) write:(NSData *)d;

- (void) connectPeripheral:(CBPeripheral*)peripheral;
- (void) disconnectPeripheral:(CBPeripheral*)peripheral;



@end


@protocol ZOBluetoothDelegate <NSObject>
@optional
-(BOOL) zoBluetoothDidDiscoverPeripheral:(ZOBluetooth*)ble peripheral:(CBPeripheral *)peripheral; // return YES to connect to this peripheral otherwise NO
-(void) zoBluetoothDidConnect:(ZOBluetooth*)ble;
-(void) zoBluetoothDidDisconnect:(ZOBluetooth*)ble;
-(void) zoBluetoothDidReceiveData:(uint8_t*)data length:(uint32_t)length;
@required
@end
