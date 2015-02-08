//
//  ZOBluetooth.m
//
//  Created by Micah Pearlman on 12/29/13.
//  Copyright (c) 2013 Micah Pearlman. All rights reserved.
//

#import "ZOBluetooth.h"


// HM-10
#define SERVICE_UUID @"FFE0"
#define CHARACTERISTIC_UUID @"FFE1"


@interface ZOBluetooth () <CBCentralManagerDelegate, CBPeripheralDelegate> {
	CBCentralManager*		_centralManager;
	NSMutableArray*			_peripherals;	// CBPeripheral
	CBPeripheral*			_connectedPeripheral;
}

@end

@implementation ZOBluetooth

@synthesize delegate = _delegate;

- (id) init {
	if ( self = [super init] ) {
		_peripherals = [[NSMutableArray alloc] init];
		
		// setup bluetooth connection
		_centralManager = [[CBCentralManager alloc] initWithDelegate:self
															   queue:dispatch_get_main_queue()];

	}
	return self;
}

- (id) initWithDelegate:(id<ZOBluetoothDelegate>) delegate {
	if( self = [self init] ) {
		self.delegate = delegate;
	}
	return self;
}

#pragma mark Various BLE utility methods

-(NSString *) CBUUIDToString:(CBUUID *) cbuuid {
    NSData *data = cbuuid.data;
    
    if ([data length] == 2) {
        const unsigned char *tokenBytes = [data bytes];
        return [NSString stringWithFormat:@"%02x%02x", tokenBytes[0], tokenBytes[1]];
    }
    else if ([data length] == 16) {
        NSUUID* nsuuid = [[NSUUID alloc] initWithUUIDBytes:[data bytes]];
        return [nsuuid UUIDString];
    }
    
    return [cbuuid description];
}

-(int) compareCBUUID:(CBUUID *) UUID1 UUID2:(CBUUID *)UUID2 {
    char b1[16];
    char b2[16];
    [UUID1.data getBytes:b1];
    [UUID2.data getBytes:b2];
    
    if (memcmp(b1, b2, UUID1.data.length) == 0)
        return 1;
    else
        return 0;
}

-(CBCharacteristic *) findCharacteristicFromUUID:(CBUUID *)UUID service:(CBService*)service {
    for(int i=0; i < service.characteristics.count; i++) {
        CBCharacteristic *c = [service.characteristics objectAtIndex:i];
        if ([self compareCBUUID:c.UUID UUID2:UUID]) return c;
    }
    
    return nil; //Characteristic not found on this service
}


-(CBService *) findServiceFromUUID:(CBUUID *)UUID p:(CBPeripheral *)p {
    for(int i = 0; i < p.services.count; i++) {
        CBService *s = [p.services objectAtIndex:i];
        if ([self compareCBUUID:s.UUID UUID2:UUID])
            return s;
    }
    
    return nil; //Service not found on this peripheral
}

-(void) read {
    CBUUID *uuid_service = [CBUUID UUIDWithString:SERVICE_UUID];
    CBUUID *uuid_char = [CBUUID UUIDWithString:CHARACTERISTIC_UUID];
    
    [self readValue:uuid_service characteristicUUID:uuid_char p:_connectedPeripheral];
}

-(void) write:(NSData *)d {
    CBUUID *uuid_service = [CBUUID UUIDWithString:SERVICE_UUID];
    CBUUID *uuid_char = [CBUUID UUIDWithString:CHARACTERISTIC_UUID];
    
    [self writeValue:uuid_service characteristicUUID:uuid_char p:_connectedPeripheral data:d];
}


-(void) readValue: (CBUUID *)serviceUUID characteristicUUID:(CBUUID *)characteristicUUID p:(CBPeripheral *)p
{
    CBService *service = [self findServiceFromUUID:serviceUUID p:p];
    
    if (!service) {
        NSLog(@"Could not find service with UUID %@ on peripheral with UUID %@",
              [self CBUUIDToString:serviceUUID],
              p.identifier.UUIDString);
        
        return;
    }
    
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:characteristicUUID service:service];
    
    if (!characteristic) {
        NSLog(@"Could not find characteristic with UUID %@ on service with UUID %@ on peripheral with UUID %@",
              [self CBUUIDToString:characteristicUUID],
              [self CBUUIDToString:serviceUUID],
              p.identifier.UUIDString);
        
        return;
    }
    
    [p readValueForCharacteristic:characteristic];
}


-(void) writeValue:(CBUUID *)serviceUUID characteristicUUID:(CBUUID *)characteristicUUID p:(CBPeripheral *)p data:(NSData *)data {
    CBService *service = [self findServiceFromUUID:serviceUUID p:p];
    
    if (!service) {
        NSLog(@"Could not find service with UUID %@ on peripheral with UUID %@",
              [self CBUUIDToString:serviceUUID],
              p.identifier.UUIDString);
        
        return;
    }
    
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:characteristicUUID service:service];
    
    if (!characteristic) {
        NSLog(@"Could not find characteristic with UUID %@ on service with UUID %@ on peripheral with UUID %@",
              [self CBUUIDToString:characteristicUUID],
              [self CBUUIDToString:serviceUUID],
              p.identifier.UUIDString);
        
        return;
    }
    
    [p writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
}




#pragma mark CBPeripheralDelegate



- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
	NSLog(@"didDiscoverServices");
	
	for ( CBService* service in peripheral.services ) {
		[peripheral discoverCharacteristics:nil forService:service];
	}
}



///### NOTE: this is the final part of the BlueToth initialization.  Can now start reading and writing...
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
	
	
	// enable read notifications
	CBUUID *uuid_service = [CBUUID UUIDWithString:SERVICE_UUID];
    CBUUID *uuid_char = [CBUUID UUIDWithString:CHARACTERISTIC_UUID];
	
    
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:uuid_char service:service];
    
    if (!characteristic) {
        NSLog(@"Could not find characteristic with UUID %@ on service with UUID %@ on peripheral with UUID %@",
              [self CBUUIDToString:uuid_char],
              [self CBUUIDToString:uuid_service],
              peripheral.identifier.UUIDString);
        
        return;
    }
    
	// this starts up didUpdateValueForCharacteristic below
    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
	
	// notify delegate that we are connected
	if ( [self.delegate respondsToSelector:@selector(zoBluetoothDidConnect:)] ) {
		[self.delegate zoBluetoothDidConnect:self];
	}
	
	
}


-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
	NSLog(@"didUpdateNotificationStateForCharacteristic");
	
}

///### NOTE: this is where incoming data
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {

	if ( [self.delegate respondsToSelector:@selector(zoBluetoothDidReceiveData:length:)] ) {
		[self.delegate zoBluetoothDidReceiveData:(uint8_t*)[characteristic.value bytes]
										  length:(uint32_t)[characteristic.value length]];
	}
}



#pragma mark CBCentralManagerDelegate

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
	
	_connectedPeripheral = peripheral;
	_connectedPeripheral.delegate = self;
	
	[_connectedPeripheral discoverServices:nil];
	
	NSLog(@"didConnectPeripheral");
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
	NSLog(@"didDisconnectPeripheral");
	if ( [self.delegate respondsToSelector:@selector(zoBluetoothDidDisconnect:)] ) {
		[self.delegate zoBluetoothDidDisconnect:self];
		[_peripherals removeAllObjects];
	}
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
	NSLog(@"didFailToConnectPeripheral");
	
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
	
	NSLog(@"------------------------------------");
	NSLog(@"Peripheral Info :");
	
	if (peripheral.identifier != NULL)
		NSLog(@"UUID : %@", peripheral.identifier.UUIDString);
	else
		NSLog(@"UUID : NULL");
	
	NSLog(@"Name : %@", peripheral.name);
	NSLog(@"-------------------------------------");
	
	// notify delegate that we are connected
	BOOL connectToPeripheral = NO;
	if ( [self.delegate respondsToSelector:@selector(zoBluetoothDidDiscoverPeripheral:peripheral:)] ) {
		connectToPeripheral = [self.delegate zoBluetoothDidDiscoverPeripheral:self peripheral:peripheral];
	}

	if (connectToPeripheral == YES) {
		[_peripherals addObject:peripheral];
		[_centralManager connectPeripheral:peripheral options:nil];
		
	}
	
}

- (void) centralManagerDidUpdateState:(CBCentralManager *)central {
    static CBCentralManagerState previousState = -1;
    
    switch ([_centralManager state]) {
        case CBCentralManagerStatePoweredOff:
        {
            break;
        }
            
        case CBCentralManagerStateUnauthorized:
        {
            /* Tell user the app is not allowed. */
            break;
        }
            
        case CBCentralManagerStateUnknown:
        {
            /* Bad news, let's wait for another event. */
            break;
        }
            
        case CBCentralManagerStatePoweredOn:
        {
			
            [_centralManager scanForPeripheralsWithServices:nil
													options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @NO }];
			
			
            break;
        }
            
        case CBCentralManagerStateResetting:
        {
            break;
        }
			
		case CBCentralManagerStateUnsupported:
		{
			break;
		}
    }
    
    previousState = [_centralManager state];
}

- (void) connectPeripheral:(CBPeripheral*)peripheral {
	[_centralManager connectPeripheral:peripheral options:nil];
}

- (void) disconnectPeripheral:(CBPeripheral*)peripheral {
	[_centralManager cancelPeripheralConnection:peripheral];
}



@end


